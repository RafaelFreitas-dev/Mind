/// -----------------------------------------------------------------------
/// HorarioModel
/// -----------------------------------------------------------------------
/// Horário de atendimento cadastrado por um psicólogo.
/// Espelha o HorarioResponseDTO do backend:
///
///   { id, psicologoId, diaDaSemana, horaInicio, horaFim, disponivel }
///
/// O backend guarda apenas o dia da semana ("Segunda", "Terca", ...) e as
/// horas em texto ("14:00") — não uma data absoluta. Por isso este model
/// calcula a [proximaOcorrencia] quando o app precisa de um DateTime.
/// -----------------------------------------------------------------------
class HorarioModel {
  final String id;
  final String psicologoId;

  /// Como veio do backend: "Domingo", "Segunda", "Terca", "Quarta",
  /// "Quinta", "Sexta" ou "Sabado".
  final String diaDaSemana;

  final String horaInicio; // "14:00"
  final String horaFim; // "15:00"
  final bool disponivel;

  const HorarioModel({
    required this.id,
    required this.psicologoId,
    required this.diaDaSemana,
    required this.horaInicio,
    required this.horaFim,
    this.disponivel = true,
  });

  factory HorarioModel.fromJson(Map<String, dynamic> json) {
    return HorarioModel(
      id: (json['id'] ?? '').toString(),
      psicologoId: (json['psicologoId'] ?? '').toString(),
      diaDaSemana: (json['diaDaSemana'] ?? '').toString(),
      horaInicio: (json['horaInicio'] ?? '').toString(),
      horaFim: (json['horaFim'] ?? '').toString(),
      disponivel: json['disponivel'] != false,
    );
  }

  Map<String, dynamic> toJson() => {
        'psicologoId': psicologoId,
        'diaDaSemana': diaDaSemana,
        'horaInicio': horaInicio,
        'horaFim': horaFim,
        'disponivel': disponivel,
      };

  /// Dia da semana no padrão do Dart (segunda = 1 ... domingo = 7).
  /// Retorna null se o backend enviar algo inesperado.
  int? get weekday {
    switch (_semAcento(diaDaSemana)) {
      case 'segunda':
      case 'segunda-feira':
        return DateTime.monday;
      case 'terca':
      case 'terca-feira':
        return DateTime.tuesday;
      case 'quarta':
      case 'quarta-feira':
        return DateTime.wednesday;
      case 'quinta':
      case 'quinta-feira':
        return DateTime.thursday;
      case 'sexta':
      case 'sexta-feira':
        return DateTime.friday;
      case 'sabado':
        return DateTime.saturday;
      case 'domingo':
        return DateTime.sunday;
      default:
        return null;
    }
  }

  /// Rótulo curto para exibir na interface ("Seg", "Ter", ...).
  String get diaAbreviado {
    const rotulos = {
      DateTime.monday: 'Seg',
      DateTime.tuesday: 'Ter',
      DateTime.wednesday: 'Qua',
      DateTime.thursday: 'Qui',
      DateTime.friday: 'Sex',
      DateTime.saturday: 'Sáb',
      DateTime.sunday: 'Dom',
    };
    return rotulos[weekday] ?? diaDaSemana;
  }

  /// "Seg · 14:00 - 15:00"
  String get descricao => '$diaAbreviado · $horaInicio - $horaFim';

  /// Próxima data em que este horário acontece, a partir de [referencia]
  /// (por padrão, agora). Usado para montar a agenda do paciente.
  DateTime? proximaOcorrencia({DateTime? referencia}) {
    final dia = weekday;
    final hora = _horaMinuto(horaInicio);
    if (dia == null || hora == null) return null;

    final agora = referencia ?? DateTime.now();
    var diasAFrente = (dia - agora.weekday) % 7;

    var data = DateTime(
      agora.year,
      agora.month,
      agora.day + diasAFrente,
      hora.$1,
      hora.$2,
    );

    // Se é hoje mas o horário já passou, pula para a semana seguinte.
    if (data.isBefore(agora)) {
      data = data.add(const Duration(days: 7));
    }
    return data;
  }

  static (int, int)? _horaMinuto(String texto) {
    final partes = texto.split(':');
    if (partes.isEmpty) return null;
    final h = int.tryParse(partes[0].trim());
    final m = partes.length > 1 ? int.tryParse(partes[1].trim()) ?? 0 : 0;
    if (h == null) return null;
    return (h, m);
  }

  static String _semAcento(String texto) => texto
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
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c');
}
