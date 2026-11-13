import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/storage/auth_storage.dart';
import '../models/user_model.dart';

/// -----------------------------------------------------------------------
/// AuthService
/// -----------------------------------------------------------------------
/// Autenticação contra o backend Spring Boot. Espelha o fluxo já usado
/// pelo frontend web (frontend/src/services/authService.js):
///
///   POST /pacientes/login  | /psicologos/login       → JWT + refresh token
///   GET  /pacientes/login/{login}                    → dados da sessão
///   GET  /pacientes/{id}/configuracoes               → perfil completo
///   POST /pacientes/cadastrar | /psicologos/cadastrar
///   POST /api/auth/logout
/// -----------------------------------------------------------------------
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final ApiClient _api = ApiClient.instance;
  final AuthStorage _storage = AuthStorage.instance;

  String _base(UserRole role) =>
      role == UserRole.psicologo ? '/psicologos' : '/pacientes';

  // ------------------------------------------------------------------ login

  /// Faz login e devolve o usuário já carregado.
  ///
  /// [login] aceita e-mail ou nome de usuário — o backend resolve os dois.
  Future<UserModel> login({
    required String login,
    required String senha,
    required UserRole role,
  }) async {
    final resposta = await _api.post(
      '${_base(role)}/login',
      corpo: {'login': login, 'senha': senha},
      autenticado: false,
    );

    if (resposta is! Map) {
      throw const ApiException('Resposta inesperada do servidor no login.');
    }

    final token = resposta['token']?.toString();
    if (token == null || token.isEmpty) {
      throw const ApiException('Login ou senha inválidos.');
    }

    final username = resposta['username']?.toString() ?? login;
    final tipo = resposta['tipo']?.toString() ?? role.apiValue;

    await _storage.salvarSessao(
      token: token,
      refreshToken: resposta['refreshToken']?.toString(),
      username: username,
      tipo: tipo,
    );

    final usuario = await carregarUsuario(
      login: username,
      role: UserRole.fromApi(tipo),
    );
    await _storage.salvarUsuario(usuario.toJson());
    return usuario;
  }

  // ------------------------------------------------------------------ cadastro

  /// Cadastra um paciente e já faz login em seguida.
  ///
  /// O backend usa o e-mail como `login` quando o campo não é enviado.
  Future<UserModel> cadastrarPaciente({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    String? telefone,
    String? genero,
    String? cep,
    String? numeroResidencia,
    DateTime? dtNascimento,
  }) async {
    await _api.post(
      '/pacientes/cadastrar',
      autenticado: false,
      corpo: _semNulos({
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'login': email,
        'senha': senha,
        'telefone': telefone,
        'genero': genero,
        'cep': cep,
        'numeroResidencia': numeroResidencia,
        'dtNascimento': _formatarData(dtNascimento),
      }),
    );

    return login(login: email, senha: senha, role: UserRole.paciente);
  }

  /// Cadastra um psicólogo e já faz login em seguida.
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
    await _api.post(
      '/psicologos/cadastrar',
      autenticado: false,
      corpo: _semNulos({
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'login': email,
        'senha': senha,
        'crp': crp,
        'especialidades': especialidades,
        'cep': cep,
        'numeroResidencia': numeroResidencia,
      }),
    );

    return login(login: email, senha: senha, role: UserRole.psicologo);
  }

  // ------------------------------------------------------------------ usuário

  /// Busca os dados da sessão e, quando possível, completa com o perfil.
  Future<UserModel> carregarUsuario({
    required String login,
    required UserRole role,
  }) async {
    final sessao = await _api.get('${_base(role)}/login/$login');
    if (sessao is! Map) {
      throw const ApiException('Não foi possível carregar seus dados.');
    }

    var usuario = UserModel.fromSessao(
      Map<String, dynamic>.from(sessao),
      login: login,
      role: role,
    );

    // O perfil completo é um bônus: se falhar (403, 404), seguimos com a
    // sessão básica em vez de impedir a entrada no app.
    try {
      final config = await _api.get('${_base(role)}/${usuario.id}/configuracoes');
      if (config is Map) {
        usuario = usuario.comConfiguracoes(Map<String, dynamic>.from(config));
      }
    } on ApiException {
      // Silencioso de propósito — ver comentário acima.
    }

    await _storage.salvarUsuario(usuario.toJson());
    return usuario;
  }

  /// Restaura a sessão guardada no dispositivo (usada ao abrir o app).
  /// Retorna null quando não há sessão válida.
  Future<UserModel?> restaurarSessao() async {
    final token = await _storage.token;
    final login = await _storage.username;
    final tipo = await _storage.tipo;
    if (token == null || token.isEmpty || login == null || tipo == null) {
      return null;
    }

    final role = UserRole.fromApi(tipo);

    try {
      return await carregarUsuario(login: login, role: role);
    } on ApiException catch (e) {
      // Sem rede: abre o app com o último usuário conhecido.
      if (!e.isNaoAutenticado) {
        final salvo = await _storage.usuario;
        if (salvo != null) return UserModel.fromJson(salvo);
      }
      await _storage.limpar();
      return null;
    }
  }

  /// Atualiza dados do usuário (PUT /{tipo}/{id}).
  Future<UserModel> atualizarPerfil({
    required UserModel usuario,
    required Map<String, dynamic> dados,
  }) async {
    await _api.put('${_base(usuario.role)}/${usuario.id}',
        corpo: _semNulos(dados));
    return carregarUsuario(login: usuario.login, role: usuario.role);
  }

  // ------------------------------------------------------------------ logout

  /// Invalida o refresh token no backend e limpa a sessão local.
  Future<void> logout() async {
    try {
      await _api.post('/api/auth/logout');
    } on ApiException {
      // Se o servidor estiver fora do ar, o logout local já basta.
    }
    await _storage.limpar();
  }

  // ------------------------------------------------------------------ helpers

  /// Remove campos nulos ou vazios para não sobrescrever dados no backend.
  Map<String, dynamic> _semNulos(Map<String, dynamic> dados) {
    final resultado = <String, dynamic>{};
    dados.forEach((chave, valor) {
      if (valor == null) return;
      if (valor is String && valor.trim().isEmpty) return;
      if (valor is List && valor.isEmpty) return;
      resultado[chave] = valor;
    });
    return resultado;
  }

  /// O backend espera LocalDate (yyyy-MM-dd).
  String? _formatarData(DateTime? data) {
    if (data == null) return null;
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    return '${data.year}-$mes-$dia';
  }
}
