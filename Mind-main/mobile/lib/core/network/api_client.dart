import 'dart:async';
import 'dart:convert';

// Nada de dart:io aqui: assim a mesma camada de rede compila em Android,
// iOS e Flutter Web. Erros de conexão chegam como http.ClientException.
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../storage/auth_storage.dart';
import 'api_exception.dart';

/// -----------------------------------------------------------------------
/// ApiClient
/// -----------------------------------------------------------------------
/// Cliente HTTP único do app. Faz o mesmo que o `authenticatedFetch` do
/// frontend web:
///
///   1. envia o JWT no header Authorization quando a rota é protegida;
///   2. se o backend responder 401, chama POST /api/auth/refresh,
///      troca o token salvo e repete a requisição uma vez;
///   3. se o refresh também falhar, limpa a sessão e avisa o app
///      através de [onSessaoExpirada].
///
/// Uso:
///   final lista = await ApiClient.instance.get('/psicologos', autenticado: false);
/// -----------------------------------------------------------------------
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _http = http.Client();
  final AuthStorage _storage = AuthStorage.instance;

  /// Chamado quando a sessão não pode mais ser renovada.
  /// O AuthController registra aqui a sua função de logout.
  void Function()? onSessaoExpirada;

  /// Garante que dois 401 simultâneos não disparem dois refresh.
  Future<bool>? _refreshEmAndamento;

  static const Duration _timeout = Duration(seconds: 20);

  // --------------------------------------------------------------- verbos HTTP

  Future<dynamic> get(String path, {bool autenticado = true}) =>
      _enviar('GET', path, autenticado: autenticado);

  Future<dynamic> post(String path, {Object? corpo, bool autenticado = true}) =>
      _enviar('POST', path, corpo: corpo, autenticado: autenticado);

  Future<dynamic> put(String path, {Object? corpo, bool autenticado = true}) =>
      _enviar('PUT', path, corpo: corpo, autenticado: autenticado);

  Future<dynamic> delete(String path, {bool autenticado = true}) =>
      _enviar('DELETE', path, autenticado: autenticado);

  // --------------------------------------------------------------- núcleo

  Future<dynamic> _enviar(
    String metodo,
    String path, {
    Object? corpo,
    bool autenticado = true,
    bool jaTentouRenovar = false,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    http.Response resposta;
    try {
      resposta = await _executar(metodo, uri, corpo, autenticado);
    } on ApiException {
      rethrow; // Ex: sem token salvo numa rota autenticada.
    } on TimeoutException {
      throw const ApiException('O servidor demorou para responder. Tente novamente.');
    } catch (_) {
      // ClientException, SocketException, erro de DNS, host inacessível...
      throw ApiException.semConexao();
    }

    // Sessão expirada: tenta renovar o JWT uma única vez e repetir.
    if (resposta.statusCode == 401 && autenticado && !jaTentouRenovar) {
      final renovou = await _renovarToken();
      if (renovou) {
        return _enviar(metodo, path,
            corpo: corpo, autenticado: autenticado, jaTentouRenovar: true);
      }
      _encerrarSessao();
      throw ApiException.naoAutenticado();
    }

    return _interpretar(resposta);
  }

  Future<http.Response> _executar(
    String metodo,
    Uri uri,
    Object? corpo,
    bool autenticado,
  ) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (corpo != null) headers['Content-Type'] = 'application/json';

    if (autenticado) {
      final token = await _storage.token;
      if (token == null || token.isEmpty) throw ApiException.naoAutenticado();
      headers['Authorization'] = 'Bearer $token';
    }

    final body = corpo == null ? null : jsonEncode(corpo);

    switch (metodo) {
      case 'POST':
        return _http.post(uri, headers: headers, body: body).timeout(_timeout);
      case 'PUT':
        return _http.put(uri, headers: headers, body: body).timeout(_timeout);
      case 'DELETE':
        return _http.delete(uri, headers: headers).timeout(_timeout);
      case 'GET':
      default:
        return _http.get(uri, headers: headers).timeout(_timeout);
    }
  }

  /// Converte a resposta em Map/List, ou lança [ApiException] com a
  /// mensagem devolvida pelo backend.
  dynamic _interpretar(http.Response resposta) {
    final status = resposta.statusCode;
    final texto = utf8.decode(resposta.bodyBytes, allowMalformed: true);

    if (status >= 200 && status < 300) {
      if (texto.trim().isEmpty) return null; // 204 No Content
      try {
        return jsonDecode(texto);
      } catch (_) {
        return texto; // Alguns endpoints devolvem texto puro.
      }
    }

    throw ApiException(_mensagemDeErro(status, texto), statusCode: status);
  }

  String _mensagemDeErro(int status, String texto) {
    // O backend às vezes responde JSON ({message: ...}) e às vezes texto puro.
    String? doCorpo;
    try {
      final decodificado = jsonDecode(texto);
      if (decodificado is Map) {
        doCorpo = (decodificado['message'] ??
                decodificado['error'] ??
                decodificado['mensagem'])
            ?.toString();
      }
    } catch (_) {
      if (texto.trim().isNotEmpty && texto.length < 300) doCorpo = texto.trim();
    }

    if (doCorpo != null && doCorpo.isNotEmpty) return doCorpo;

    switch (status) {
      case 400:
        return 'Dados inválidos. Revise as informações e tente novamente.';
      case 401:
        return 'Login ou senha inválidos.';
      case 403:
        return 'Você não tem permissão para acessar estes dados.';
      case 404:
        return 'Não encontramos o que você procura.';
      case 409:
        return 'Esses dados já estão cadastrados.';
      default:
        return status >= 500
            ? 'Erro no servidor. Tente novamente em instantes.'
            : 'Não foi possível concluir a operação (erro $status).';
    }
  }

  // --------------------------------------------------------------- refresh

  /// Renova o JWT usando o refresh token. Retorna true em caso de sucesso.
  /// Chamadas simultâneas compartilham o mesmo Future.
  Future<bool> _renovarToken() {
    return _refreshEmAndamento ??= _executarRefresh()
        .whenComplete(() => _refreshEmAndamento = null);
  }

  Future<bool> _executarRefresh() async {
    final refreshToken = await _storage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final resposta = await _http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(_timeout);

      if (resposta.statusCode != 200) return false;

      final dados = jsonDecode(utf8.decode(resposta.bodyBytes));
      if (dados is! Map) return false;

      final novoToken = dados['token'] as String?;
      if (novoToken == null || novoToken.isEmpty) return false;

      await _storage.salvarToken(novoToken);

      // O backend rotaciona o refresh token a cada renovação.
      final novoRefresh = dados['refreshToken'] as String?;
      if (novoRefresh != null && novoRefresh.isNotEmpty) {
        await _storage.salvarRefreshToken(novoRefresh);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void _encerrarSessao() {
    _storage.limpar();
    onSessaoExpirada?.call();
  }
}
