import '../core/network/api_client.dart';
import '../models/appointment_model.dart';
import '../models/horario_model.dart';
import '../models/psychologist_model.dart';
import 'horario_service.dart';
import 'psicologo_service.dart';

/// -----------------------------------------------------------------------
/// AgendaService
/// -----------------------------------------------------------------------
/// Agendamentos entre paciente e psicólogo.
///
///   POST /agendas
///   GET  /agendas/paciente/{id}
///   GET  /agendas/psicologo/{id}
///   PUT  /agendas/{id}/cancelar
///
/// O AgendaResponseDTO traz apenas ids. Para a tela de consultas ficar
/// útil, este service "hidrata" cada agenda com o psicólogo e o horário
/// correspondentes, em paralelo e sem repetir requisições.
/// -----------------------------------------------------------------------
class AgendaService {
  AgendaService._();

  static final AgendaService instance = AgendaService._();

  final ApiClient _api = ApiClient.instance;
  final PsicologoService _psicologos = PsicologoService.instance;
  final HorarioService _horarios = HorarioService.instance;

  /// Consultas do paciente, já com psicólogo e horário resolvidos e
  /// ordenadas por data.
  Future<List<AppointmentModel>> listarDoPaciente(String pacienteId) async {
    final resposta = await _api.get('/agendas/paciente/$pacienteId');
    return _hidratar(resposta);
  }

  /// Consultas do psicólogo (agenda profissional).
  Future<List<AppointmentModel>> listarDoPsicologo(String psicologoId) async {
    final resposta = await _api.get('/agendas/psicologo/$psicologoId');
    return _hidratar(resposta);
  }

  /// Agenda uma sessão. O backend marca o horário como indisponível.
  Future<AppointmentModel?> agendar({
    required String pacienteId,
    required String psicologoId,
    required String horarioId,
  }) async {
    final resposta = await _api.post('/agendas', corpo: {
      'pacienteId': pacienteId,
      'psicologoId': psicologoId,
      'horarioId': horarioId,
    });
    if (resposta is! Map) return null;

    final json = Map<String, dynamic>.from(resposta);
    final psicologo = await _psicologos.buscarPorIdOuNulo(psicologoId);
    final horario = await _horarioOuNulo(psicologoId, horarioId);

    return AppointmentModel.fromJson(json,
        horario: horario, psicologo: psicologo);
  }

  Future<void> cancelar(String agendaId) =>
      _api.put('/agendas/$agendaId/cancelar');

  // ------------------------------------------------------------------ interno

  Future<List<AppointmentModel>> _hidratar(dynamic resposta) async {
    if (resposta is! List) return const [];

    final agendas = resposta
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    if (agendas.isEmpty) return const [];

    // Ids únicos de psicólogo — uma requisição por profissional, não por agenda.
    final idsPsicologos = agendas
        .map((a) => (a['psicologoId'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet();

    final psicologosPorId = <String, PsychologistModel>{};
    final horariosPorPsicologo = <String, List<HorarioModel>>{};

    await Future.wait(idsPsicologos.map((id) async {
      final psicologoFuture = _psicologos.buscarPorIdOuNulo(id);
      final horariosFuture = _listarHorariosOuVazio(id);

      final psicologo = await psicologoFuture;
      if (psicologo != null) psicologosPorId[id] = psicologo;
      horariosPorPsicologo[id] = await horariosFuture;
    }));

    final consultas = agendas.map((json) {
      final psicologoId = (json['psicologoId'] ?? '').toString();
      final horarioId = (json['horarioId'] ?? '').toString();

      HorarioModel? horario;
      for (final h in horariosPorPsicologo[psicologoId] ?? const <HorarioModel>[]) {
        if (h.id == horarioId) {
          horario = h;
          break;
        }
      }

      return AppointmentModel.fromJson(
        json,
        horario: horario,
        psicologo: psicologosPorId[psicologoId],
      );
    }).toList();

    consultas.sort(AppointmentModel.compararPorData);
    return consultas;
  }

  Future<List<HorarioModel>> _listarHorariosOuVazio(String psicologoId) async {
    try {
      return await _horarios.listarDoPsicologo(psicologoId);
    } catch (_) {
      return const [];
    }
  }

  Future<HorarioModel?> _horarioOuNulo(String psicologoId, String horarioId) async {
    try {
      return await _horarios.buscarNoPsicologo(
        psicologoId: psicologoId,
        horarioId: horarioId,
      );
    } catch (_) {
      return null;
    }
  }
}
