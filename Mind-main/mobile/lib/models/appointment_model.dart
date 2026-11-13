import 'horario_model.dart';
import 'psychologist_model.dart';

/// Status possíveis de uma consulta.
/// No backend (models/Agenda.java) são: AGENDADO, CANCELADO, CONCLUIDO.
enum AppointmentStatus {
  agendada('AGENDADO'),
  concluida('CONCLUIDO'),
  cancelada('CANCELADO');

  final String apiValue;
  const AppointmentStatus(this.apiValue);

  static AppointmentStatus fromApi(String? valor) {
    switch ((valor ?? '').toUpperCase()) {
      case 'CONCLUIDO':
        return AppointmentStatus.concluida;
      case 'CANCELADO':
        return AppointmentStatus.cancelada;
      default:
        return AppointmentStatus.agendada;
    }
  }
}

/// -----------------------------------------------------------------------
/// AppointmentModel
/// -----------------------------------------------------------------------
/// Uma consulta agendada. Monta-se a partir de três recursos do backend:
///
///   GET /agendas/paciente/{id}  → { id, pacienteId, psicologoId, horarioId, status }
///   GET /horarios/psicologo/{id} → dia da semana e horas
///   GET /psicologos/{id}         → dados do profissional
///
/// Como a agenda não guarda uma data absoluta, [dataHora] é a próxima
/// ocorrência do horário semanal (ver HorarioModel.proximaOcorrencia).
/// -----------------------------------------------------------------------
class AppointmentModel {
  final String id;
  final String pacienteId;
  final PsychologistModel psicologo;
  final HorarioModel? horario;
  final DateTime? dataHora;
  final Modalidade modalidade;
  final AppointmentStatus status;

  const AppointmentModel({
    required this.id,
    required this.pacienteId,
    required this.psicologo,
    this.horario,
    this.dataHora,
    this.modalidade = Modalidade.online,
    this.status = AppointmentStatus.agendada,
  });

  /// Monta a consulta juntando a agenda com o horário e o psicólogo já
  /// carregados (ver AgendaService.listarDoPaciente).
  factory AppointmentModel.fromJson(
    Map<String, dynamic> json, {
    HorarioModel? horario,
    PsychologistModel? psicologo,
  }) {
    final psicologoId = (json['psicologoId'] ?? '').toString();
    return AppointmentModel(
      id: (json['id'] ?? '').toString(),
      pacienteId: (json['pacienteId'] ?? '').toString(),
      psicologo: psicologo ?? PsychologistModel.placeholder(psicologoId),
      horario: horario,
      dataHora: horario?.proximaOcorrencia(),
      status: AppointmentStatus.fromApi(json['status']?.toString()),
    );
  }

  bool get isAgendada => status == AppointmentStatus.agendada;

  /// Indica se a consulta é hoje — usado para destacar o card
  /// "Próxima sessão" e habilitar o botão "Entrar na sala".
  bool get isHoje {
    final data = dataHora;
    if (data == null) return false;
    final agora = DateTime.now();
    return data.year == agora.year &&
        data.month == agora.month &&
        data.day == agora.day;
  }

  /// Tempo restante até a consulta, formatado de forma amigável
  /// (ex: "2h 15min"). Retorna null se a consulta já passou ou se não há
  /// horário associado.
  String? get tempoRestanteFormatado {
    final data = dataHora;
    if (data == null) return null;
    final diferenca = data.difference(DateTime.now());
    if (diferenca.isNegative) return null;
    final horas = diferenca.inHours;
    final minutos = diferenca.inMinutes.remainder(60);
    if (horas > 0) return '${horas}h ${minutos}min';
    return '${minutos}min';
  }

  /// Ordena consultas pela data (as sem data vão para o fim).
  static int compararPorData(AppointmentModel a, AppointmentModel b) {
    if (a.dataHora == null) return 1;
    if (b.dataHora == null) return -1;
    return a.dataHora!.compareTo(b.dataHora!);
  }
}
