import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// -----------------------------------------------------------------------
/// AuthStorage
/// -----------------------------------------------------------------------
/// Guarda a sessão no dispositivo (equivalente ao localStorage usado pelo
/// frontend web): JWT, refresh token, login e tipo de usuário.
///
/// Assim o usuário continua logado ao reabrir o app.
/// -----------------------------------------------------------------------
class AuthStorage {
  AuthStorage._();

  static final AuthStorage instance = AuthStorage._();

  static const _kToken = 'mind.token';
  static const _kRefreshToken = 'mind.refreshToken';
  static const _kUsername = 'mind.username';
  static const _kTipo = 'mind.tipo';
  static const _kUsuario = 'mind.usuario';
  static const _kOnboardingVisto = 'mind.onboardingVisto';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _p async =>
      _prefs ??= await SharedPreferences.getInstance();

  // ------------------------------------------------------------------ tokens

  Future<void> salvarSessao({
    required String token,
    required String? refreshToken,
    required String username,
    required String tipo,
  }) async {
    final p = await _p;
    await p.setString(_kToken, token);
    await p.setString(_kUsername, username);
    await p.setString(_kTipo, tipo);
    if (refreshToken != null) {
      await p.setString(_kRefreshToken, refreshToken);
    }
  }

  Future<void> salvarToken(String token) async =>
      (await _p).setString(_kToken, token);

  Future<void> salvarRefreshToken(String refreshToken) async =>
      (await _p).setString(_kRefreshToken, refreshToken);

  Future<String?> get token async => (await _p).getString(_kToken);
  Future<String?> get refreshToken async => (await _p).getString(_kRefreshToken);
  Future<String?> get username async => (await _p).getString(_kUsername);
  Future<String?> get tipo async => (await _p).getString(_kTipo);

  // ------------------------------------------------------------------ usuário

  /// Guarda o usuário serializado para abrir o app já com os dados em tela
  /// enquanto a requisição de sessão acontece em segundo plano.
  Future<void> salvarUsuario(Map<String, dynamic> json) async =>
      (await _p).setString(_kUsuario, jsonEncode(json));

  Future<Map<String, dynamic>?> get usuario async {
    final bruto = (await _p).getString(_kUsuario);
    if (bruto == null || bruto.isEmpty) return null;
    try {
      final decodificado = jsonDecode(bruto);
      return decodificado is Map<String, dynamic> ? decodificado : null;
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------------ onboarding

  Future<bool> get onboardingVisto async =>
      (await _p).getBool(_kOnboardingVisto) ?? false;

  Future<void> marcarOnboardingVisto() async =>
      (await _p).setBool(_kOnboardingVisto, true);

  // ------------------------------------------------------------------ limpeza

  Future<void> limpar() async {
    final p = await _p;
    await p.remove(_kToken);
    await p.remove(_kRefreshToken);
    await p.remove(_kUsername);
    await p.remove(_kTipo);
    await p.remove(_kUsuario);
    // O onboarding não é apagado de propósito: já foi visto uma vez.
  }
}
