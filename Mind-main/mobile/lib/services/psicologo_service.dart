import '../core/network/api_client.dart';
import '../models/psychologist_model.dart';

/// -----------------------------------------------------------------------
/// PsicologoService
/// -----------------------------------------------------------------------
/// Consulta os psicólogos cadastrados.
///
///   GET /psicologos           (público)
///   GET /psicologos/{id}      (requer JWT)
/// -----------------------------------------------------------------------
class PsicologoService {
  PsicologoService._();

  static final PsicologoService instance = PsicologoService._();

  final ApiClient _api = ApiClient.instance;

  /// Cache simples por id — evita repetir a mesma busca ao montar a lista
  /// de consultas (várias agendas podem ser do mesmo profissional).
  final Map<String, PsychologistModel> _cache = {};

  /// Lista todos os psicólogos. Endpoint público: funciona mesmo antes do
  /// login (por isso `autenticado: false`).
  Future<List<PsychologistModel>> listarTodos() async {
    final resposta = await _api.get('/psicologos', autenticado: false);
    if (resposta is! List) return const [];

    final lista = resposta
        .whereType<Map>()
        .map((item) => PsychologistModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    for (final p in lista) {
      _cache[p.id] = p;
    }
    return lista;
  }

  /// Busca um psicólogo por id, usando o cache quando já foi carregado.
  Future<PsychologistModel?> buscarPorId(String id, {bool usarCache = true}) async {
    if (id.isEmpty) return null;
    if (usarCache && _cache.containsKey(id)) return _cache[id];

    final resposta = await _api.get('/psicologos/$id');
    if (resposta is! Map) return null;

    final psicologo =
        PsychologistModel.fromJson(Map<String, dynamic>.from(resposta));
    _cache[id] = psicologo;
    return psicologo;
  }

  /// Igual a [buscarPorId], mas devolve null em caso de erro em vez de
  /// lançar — útil ao montar listas onde um item ausente não deve
  /// derrubar a tela inteira.
  Future<PsychologistModel?> buscarPorIdOuNulo(String id) async {
    try {
      return await buscarPorId(id);
    } catch (_) {
      return null;
    }
  }

  void limparCache() => _cache.clear();
}
