import '../core/config/api_config.dart';

/// -----------------------------------------------------------------------
/// Tipo de conta do usuário.
/// Reflete a escolha feita na tela de cadastro ("Paciente" ou "Psicólogo")
/// e o campo `tipo` devolvido pelo backend no login ("paciente"/"psicologo").
/// -----------------------------------------------------------------------
enum UserRole {
  paciente,
  psicologo;

  /// Valor usado pelo backend (`tipo` no JwtResponseDTO).
  String get apiValue => name;

  static UserRole fromApi(String? valor) =>
      valor == 'psicologo' ? UserRole.psicologo : UserRole.paciente;
}

/// -----------------------------------------------------------------------
/// UserModel
/// -----------------------------------------------------------------------
/// Representa o usuário autenticado no app (paciente ou psicólogo).
///
/// Os dados vêm de dois endpoints do backend:
///   - GET /{pacientes|psicologos}/login/{login}  → dados da sessão
///   - GET /{pacientes|psicologos}/{id}/configuracoes → perfil completo
///
/// Mantemos a classe imutável (campos `final`) com `copyWith` para
/// atualizações parciais.
/// -----------------------------------------------------------------------
class UserModel {
  final String id;
  final String nome;
  final String? sobrenome;
  final String email;

  /// Login usado na autenticação (pode ser o próprio e-mail).
  final String login;

  final String? telefone;
  final UserRole role;
  final String plano;

  /// Nome do arquivo da imagem no backend (ex: "perfil-joao-a1b2.png").
  final String? imgPerfil;

  final String? sobreMim;
  final String? cidade;
  final String? uf;

  // Exclusivos de psicólogo
  final String? crp;
  final List<String> especialidades;

  // Estatísticas exibidas no perfil (calculadas a partir das agendas)
  final int totalSessoes;
  final int mesesDeJornada;
  final int totalPsicologos;

  const UserModel({
    required this.id,
    required this.nome,
    this.sobrenome,
    required this.email,
    required this.login,
    this.telefone,
    required this.role,
    this.plano = 'Plano Básico',
    this.imgPerfil,
    this.sobreMim,
    this.cidade,
    this.uf,
    this.crp,
    this.especialidades = const [],
    this.totalSessoes = 0,
    this.mesesDeJornada = 0,
    this.totalPsicologos = 0,
  });

  /// Nome completo (nome + sobrenome quando houver).
  String get nomeCompleto =>
      (sobrenome == null || sobrenome!.isEmpty) ? nome : '$nome $sobrenome';

  /// Primeiro nome, usado na saudação da Home.
  String get primeiroNome => nome.split(' ').first;

  /// Primeira letra do nome, usada como avatar quando não há foto.
  String get inicial => nome.isNotEmpty ? nome[0].toUpperCase() : '?';

  /// URL completa da foto de perfil, ou null quando não há imagem.
  String? get fotoUrl => ApiConfig.imagemUrl(imgPerfil);

  bool get isPsicologo => role == UserRole.psicologo;

  // ------------------------------------------------------------------ parsing

  /// Cria o usuário a partir de GET /{tipo}/login/{login}
  /// (PacienteSessionResponseDTO / PsicologoSessionResponseDTO).
  ///
  /// Esses DTOs não trazem e-mail, então passamos o `login` usado na
  /// autenticação — que no cadastro padrão é o próprio e-mail.
  factory UserModel.fromSessao(
    Map<String, dynamic> json, {
    required String login,
    required UserRole role,
  }) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      nome: (json['nome'] ?? '').toString(),
      sobrenome: json['sobrenome']?.toString(),
      email: login.contains('@') ? login : '',
      login: login,
      role: UserRole.fromApi(json['tipo']?.toString()) == UserRole.psicologo
          ? UserRole.psicologo
          : role,
      imgPerfil: json['imgPerfil']?.toString(),
    );
  }

  /// Completa o usuário com GET /{tipo}/{id}/configuracoes
  /// (Paciente/PsicologoConfiguracoesResponseDTO).
  UserModel comConfiguracoes(Map<String, dynamic> json) {
    return copyWith(
      nome: json['nome']?.toString(),
      sobrenome: json['sobrenome']?.toString(),
      email: json['email']?.toString(),
      login: json['login']?.toString(),
      telefone: json['telefone']?.toString(),
      imgPerfil: json['imgPerfil']?.toString(),
      sobreMim: json['sobreMim']?.toString(),
      cidade: json['cidade']?.toString(),
      uf: json['uf']?.toString(),
      crp: json['crp']?.toString(),
      especialidades: (json['especialidades'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  /// Serialização usada para guardar a sessão no dispositivo.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'login': login,
        'telefone': telefone,
        'role': role.apiValue,
        'plano': plano,
        'imgPerfil': imgPerfil,
        'sobreMim': sobreMim,
        'cidade': cidade,
        'uf': uf,
        'crp': crp,
        'especialidades': especialidades,
      };

  /// Reconstrói o usuário guardado localmente (ver [toJson]).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      nome: (json['nome'] ?? '').toString(),
      sobrenome: json['sobrenome']?.toString(),
      email: (json['email'] ?? '').toString(),
      login: (json['login'] ?? '').toString(),
      telefone: json['telefone']?.toString(),
      role: UserRole.fromApi(json['role']?.toString()),
      plano: (json['plano'] ?? 'Plano Básico').toString(),
      imgPerfil: json['imgPerfil']?.toString(),
      sobreMim: json['sobreMim']?.toString(),
      cidade: json['cidade']?.toString(),
      uf: json['uf']?.toString(),
      crp: json['crp']?.toString(),
      especialidades:
          (json['especialidades'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
    );
  }

  UserModel copyWith({
    String? id,
    String? nome,
    String? sobrenome,
    String? email,
    String? login,
    String? telefone,
    UserRole? role,
    String? plano,
    String? imgPerfil,
    String? sobreMim,
    String? cidade,
    String? uf,
    String? crp,
    List<String>? especialidades,
    int? totalSessoes,
    int? mesesDeJornada,
    int? totalPsicologos,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      sobrenome: sobrenome ?? this.sobrenome,
      email: email ?? this.email,
      login: login ?? this.login,
      telefone: telefone ?? this.telefone,
      role: role ?? this.role,
      plano: plano ?? this.plano,
      imgPerfil: imgPerfil ?? this.imgPerfil,
      sobreMim: sobreMim ?? this.sobreMim,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      crp: crp ?? this.crp,
      especialidades: especialidades ?? this.especialidades,
      totalSessoes: totalSessoes ?? this.totalSessoes,
      mesesDeJornada: mesesDeJornada ?? this.mesesDeJornada,
      totalPsicologos: totalPsicologos ?? this.totalPsicologos,
    );
  }
}
