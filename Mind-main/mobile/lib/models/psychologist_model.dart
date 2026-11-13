import '../core/config/api_config.dart';

/// -----------------------------------------------------------------------
/// Abordagem terapêutica do psicólogo (usada em tags e filtros).
/// -----------------------------------------------------------------------
enum Abordagem {
  tcc('TCC'),
  psicanalise('Psicanálise'),
  humanista('Humanista'),
  emdr('EMDR'),
  gestalt('Gestalt'),
  act('ACT'),
  sistemica('Sistêmica'),
  transpessoal('Transpessoal');

  final String label;
  const Abordagem(this.label);

  /// Tenta casar um texto vindo do backend (lista `especialidades`) com uma
  /// abordagem conhecida. Retorna null quando é só uma especialidade comum
  /// (ex: "Ansiedade"), que segue sendo exibida como especialidade.
  static Abordagem? tryParse(String valor) {
    final normalizado = _normalizar(valor);
    for (final a in Abordagem.values) {
      if (_normalizar(a.label) == normalizado || a.name == normalizado) return a;
    }
    return null;
  }

  static String _normalizar(String texto) => texto
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('â', 'a')
      .replaceAll('ã', 'a')
      .replaceAll('é', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ô', 'o')
      .replaceAll('õ', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c');
}

/// Modalidade de atendimento oferecida.
enum Modalidade { online, presencial }

/// -----------------------------------------------------------------------
/// PsychologistModel
/// -----------------------------------------------------------------------
/// Representa um profissional listado no app (busca, recomendados, etc).
///
/// Vem de GET /psicologos e GET /psicologos/{id} (PsicologoResponseDTO).
/// Campos que o backend ainda não possui — avaliação, preço da sessão,
/// anos de experiência — são nulos e simplesmente não aparecem na tela.
/// -----------------------------------------------------------------------
class PsychologistModel {
  final String id;
  final String nome;
  final String? sobrenome;

  /// Nome do arquivo de imagem no backend (`imgPerfil`).
  final String? imgPerfil;

  final List<String> especialidades; // Ex: ["Ansiedade", "Depressão"]
  final List<Abordagem> abordagens;

  final String? crp;
  final String? telefone;
  final String? sobreMim;
  final String? local;
  final int? idade;

  // Dados ainda não fornecidos pela API (ficam nulos enquanto não existirem).
  final double? avaliacao;
  final int? totalAvaliacoes;
  final int? anosExperiencia;
  final double? precoSessao;

  final List<Modalidade> modalidades;

  const PsychologistModel({
    required this.id,
    required this.nome,
    this.sobrenome,
    this.imgPerfil,
    this.especialidades = const [],
    this.abordagens = const [],
    this.crp,
    this.telefone,
    this.sobreMim,
    this.local,
    this.idade,
    this.avaliacao,
    this.totalAvaliacoes,
    this.anosExperiencia,
    this.precoSessao,
    this.modalidades = const [Modalidade.online],
  });

  /// Nome completo exibido nos cards.
  String get nomeCompleto =>
      (sobrenome == null || sobrenome!.isEmpty) ? nome : '$nome $sobrenome';

  String get inicial => nome.isNotEmpty ? nome[0].toUpperCase() : '?';

  /// Retorna as iniciais (ex: "Laura Almeida" -> "LA"), usadas como
  /// avatar padrão quando o profissional não possui foto cadastrada.
  String get iniciais {
    final partes = nomeCompleto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  /// URL completa da foto, ou null quando não há imagem cadastrada.
  String? get fotoUrl => ApiConfig.imagemUrl(imgPerfil);

  String? get precoFormatado =>
      precoSessao == null ? null : 'R\$ ${precoSessao!.toStringAsFixed(0)}';

  /// Texto usado na busca local (nome, especialidades, abordagens, cidade).
  String get textoBuscavel => [
        nomeCompleto,
        ...especialidades,
        ...abordagens.map((a) => a.label),
        local ?? '',
      ].join(' ').toLowerCase();

  // ------------------------------------------------------------------ parsing

  /// Converte um item de GET /psicologos (PsicologoResponseDTO).
  factory PsychologistModel.fromJson(Map<String, dynamic> json) {
    final brutas = (json['especialidades'] as List?)
            ?.map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList() ??
        const <String>[];

    // Separa o que é abordagem terapêutica do que é especialidade clínica.
    final abordagens = <Abordagem>[];
    final especialidades = <String>[];
    for (final item in brutas) {
      final abordagem = Abordagem.tryParse(item);
      if (abordagem != null) {
        abordagens.add(abordagem);
      } else {
        especialidades.add(item);
      }
    }

    return PsychologistModel(
      id: (json['id'] ?? '').toString(),
      nome: (json['nome'] ?? '').toString(),
      sobrenome: json['sobrenome']?.toString(),
      imgPerfil: json['imgPerfil']?.toString(),
      especialidades: especialidades,
      abordagens: abordagens,
      crp: json['crp']?.toString(),
      telefone: json['telefone']?.toString(),
      sobreMim: json['sobreMim']?.toString(),
      local: json['local']?.toString(),
      idade: json['idade'] is int
          ? json['idade'] as int
          : int.tryParse(json['idade']?.toString() ?? ''),
    );
  }

  /// Usado quando só conhecemos o id do psicólogo (ex: uma agenda cujo
  /// perfil não pôde ser carregado) — evita quebrar a tela de consultas.
  factory PsychologistModel.placeholder(String id) =>
      PsychologistModel(id: id, nome: 'Psicólogo');
}
