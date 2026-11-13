import 'package:flutter/foundation.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import '../storage/auth_storage.dart';

/// Situação da sessão no app.
enum AuthStatus {
  /// Ainda verificando se existe sessão salva (tela de splash).
  verificando,

  /// Sem usuário logado.
  deslogado,

  /// Usuário autenticado.
  logado,
}

/// -----------------------------------------------------------------------
/// AuthController
/// -----------------------------------------------------------------------
/// Estado global da sessão. É um [ChangeNotifier] simples (sem pacotes de
/// gerenciamento de estado): as telas escutam com `ListenableBuilder` ou
/// chamam os métodos direto pelo singleton [auth].
///
///   await auth.login(login: email, senha: senha, role: UserRole.paciente);
///   auth.usuario!.primeiroNome
/// -----------------------------------------------------------------------
class AuthController extends ChangeNotifier {
  AuthController._() {
    // Quando o refresh token também expira, o ApiClient avisa aqui.
    ApiClient.instance.onSessaoExpirada = _aoExpirarSessao;
  }

  static final AuthController instance = AuthController._();

  final AuthService _service = AuthService.instance;
  final AuthStorage _storage = AuthStorage.instance;

  AuthStatus _status = AuthStatus.verificando;
  UserModel? _usuario;
  bool _onboardingVisto = false;

  AuthStatus get status => _status;
  UserModel? get usuario => _usuario;
  bool get estaLogado => _status == AuthStatus.logado && _usuario != null;
  bool get onboardingVisto => _onboardingVisto;

  /// Sinaliza para a UI que a sessão caiu no meio do uso, para mostrar
  /// uma mensagem na tela de login.
  String? sessaoExpiradaMensagem;

  // ------------------------------------------------------------------ início

  /// Chamado uma vez na abertura do app: tenta restaurar a sessão salva.
  Future<void> inicializar() async {
    _onboardingVisto = await _storage.onboardingVisto;

    final usuario = await _service.restaurarSessao();
    _usuario = usuario;
    _status = usuario == null ? AuthStatus.deslogado : AuthStatus.logado;
    notifyListeners();
  }

  /// Registra que o onboarding já foi visto. Notifica a AuthGate, que passa
  /// a mostrar o login em vez dos slides.
  Future<void> marcarOnboardingVisto() async {
    if (_onboardingVisto) return;
    _onboardingVisto = true;
    notifyListeners();
    await _storage.marcarOnboardingVisto();
  }

  // ------------------------------------------------------------------ ações

  /// Autentica e passa a expor o usuário. Lança [ApiException] em erro,
  /// para a tela mostrar a mensagem ao usuário.
  Future<UserModel> login({
    required String login,
    required String senha,
    required UserRole role,
  }) async {
    final usuario = await _service.login(login: login, senha: senha, role: role);
    _definirUsuario(usuario);
    return usuario;
  }

  Future<UserModel> cadastrarPaciente({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    String? telefone,
    String? cep,
    String? numeroResidencia,
  }) async {
    final usuario = await _service.cadastrarPaciente(
      nome: nome,
      sobrenome: sobrenome,
      email: email,
      senha: senha,
      telefone: telefone,
      cep: cep,
      numeroResidencia: numeroResidencia,
    );
    _definirUsuario(usuario);
    return usuario;
  }

  Future<UserModel> cadastrarPsicologo({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String crp,
    List<String> especialidades = const [],
    String? cep,
    String? numeroResidencia,
  }) async {
    final usuario = await _service.cadastrarPsicologo(
      nome: nome,
      sobrenome: sobrenome,
      email: email,
      senha: senha,
      crp: crp,
      especialidades: especialidades,
      cep: cep,
      numeroResidencia: numeroResidencia,
    );
    _definirUsuario(usuario);
    return usuario;
  }

  /// Recarrega os dados do usuário logado (após editar o perfil, por exemplo).
  Future<void> recarregarUsuario() async {
    final atual = _usuario;
    if (atual == null) return;
    try {
      _usuario = await _service.carregarUsuario(
        login: atual.login,
        role: atual.role,
      );
      notifyListeners();
    } on ApiException {
      // Mantém os dados atuais se a atualização falhar.
    }
  }

  /// Atualiza as estatísticas mostradas no perfil a partir das consultas.
  void atualizarEstatisticas({
    int? totalSessoes,
    int? totalPsicologos,
    int? mesesDeJornada,
  }) {
    final atual = _usuario;
    if (atual == null) return;
    _usuario = atual.copyWith(
      totalSessoes: totalSessoes,
      totalPsicologos: totalPsicologos,
      mesesDeJornada: mesesDeJornada,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    await _service.logout();
    _usuario = null;
    _status = AuthStatus.deslogado;
    sessaoExpiradaMensagem = null;
    notifyListeners();
  }

  // ------------------------------------------------------------------ interno

  void _definirUsuario(UserModel usuario) {
    _usuario = usuario;
    _status = AuthStatus.logado;
    sessaoExpiradaMensagem = null;
    notifyListeners();
  }

  void _aoExpirarSessao() {
    if (_status == AuthStatus.deslogado) return;
    _usuario = null;
    _status = AuthStatus.deslogado;
    sessaoExpiradaMensagem = 'Sua sessão expirou. Faça login novamente.';
    notifyListeners();
  }
}

/// Atalho global para o estado de autenticação.
final AuthController auth = AuthController.instance;
