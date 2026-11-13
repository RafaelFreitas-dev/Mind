import '../core/network/api_client.dart';
import '../models/horario_model.dart';

/// -----------------------------------------------------------------------
/// HorarioService
/// -----------------------------------------------------------------------
/// Horários de atendimento dos psicólogos.
///
///   GET    /horarios/psicologo/{id}
///   GET    /horarios/psicologo/{id}/disponiveis
///   POST   /horarios              (somente psicólogo)
///   DELETE /horarios/{id}         (somente psicólogo)
/// -----------------------------------------------------------------------
class HorarioService {
  HorarioService._();

  static final HorarioService instance = HorarioService._();

  final ApiClient _api = ApiClient.instance;

  Future<List<HorarioModel>> listarDoPsicologo(String psicologoId) async {
    final resposta = await _api.get('/horarios/psicologo/$psicologoId');
    return _converterLista(resposta);
  }

  Future<List<HorarioModel>> listarDisponiveis(String psicologoId) async {
    final resposta =
        await _api.get('/horarios/psicologo/$psicologoId/disponiveis');
    return _converterLista(resposta);
  }

  /// Busca um horário específico dentro da lista do psicólogo.
  /// O backend não expõe GET /horarios/{id}, então filtramos localmente.
  Future<HorarioModel?> buscarNoPsicologo({
    required String psicologoId,
    required String horarioId,
  }) async {
    final lista = await listarDoPsicologo(psicologoId);
    for (final h in lista) {
      if (h.id == horarioId) return h;
    }
    return null;
  }

  /// Cria um horário de atendimento (exige perfil de psicólogo).
  Future<HorarioModel?> criar({
    required String psicologoId,
    required String diaDaSemana,
    required String horaInicio,
    required String horaFim,
    bool disponivel = true,
  }) async {
    final resposta = await _api.post('/horarios', corpo: {
      'psicologoId': psicologoId,
      'diaDaSemana': diaDaSemana,
      'horaInicio': horaInicio,
      'horaFim': horaFim,
      'disponivel': disponivel,
    });
    if (resposta is! Map) return null;
    return HorarioModel.fromJson(Map<String, dynamic>.from(resposta));
  }

  Future<void> deletar(String horarioId) => _api.delete('/horarios/$horarioId');

  List<HorarioModel> _converterLista(dynamic resposta) {
    if (resposta is! List) return const [];
    return resposta
        .whereType<Map>()
        .map((item) => HorarioModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
