import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/psychologist_model.dart';
import '../../services/psicologo_service.dart';
import '../../widgets/psychologist_card.dart';
import '../psychologist/psychologist_detail_screen.dart';

/// -----------------------------------------------------------------------
/// SearchScreen
/// -----------------------------------------------------------------------
/// Busca de psicólogos sobre os dados reais de GET /psicologos (endpoint
/// público). Como o backend ainda não tem busca por texto, o filtro é
/// aplicado localmente sobre a lista carregada — nome, especialidades,
/// abordagens e cidade.
/// -----------------------------------------------------------------------
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _buscaController = TextEditingController();

  /// Abordagem selecionada nos chips do topo (null = "Todas").
  Abordagem? _abordagemFiltro;

  List<PsychologistModel> _todosOsPsicologos = const [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await PsicologoService.instance.listarTodos();
      if (!mounted) return;
      setState(() {
        _todosOsPsicologos = lista;
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.mensagem;
        _carregando = false;
      });
    }
  }

  /// Abordagens que realmente aparecem nos dados — evita oferecer filtro
  /// para algo que nenhum profissional cadastrou.
  List<Abordagem> get _abordagensDisponiveis {
    final encontradas = <Abordagem>{};
    for (final p in _todosOsPsicologos) {
      encontradas.addAll(p.abordagens);
    }
    final lista = encontradas.toList()
      ..sort((a, b) => a.label.compareTo(b.label));
    return lista;
  }

  /// Lista filtrada de acordo com o texto buscado e a abordagem escolhida.
  List<PsychologistModel> get _resultados {
    final termo = _buscaController.text.trim().toLowerCase();
    return _todosOsPsicologos.where((p) {
      final combinaTermo = termo.isEmpty || p.textoBuscavel.contains(termo);
      final combinaAbordagem =
          _abordagemFiltro == null || p.abordagens.contains(_abordagemFiltro);
      return combinaTermo && combinaAbordagem;
    }).toList();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _abrirPerfil(PsychologistModel psicologo) async {
    final agendou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PsychologistDetailScreen(psicologo: psicologo),
      ),
    );
    if (agendou == true) _carregar();
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.screenPadding,
                AppConstants.spaceM,
                AppConstants.screenPadding,
                AppConstants.spaceS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampoBusca(),
                  if (_abordagensDisponiveis.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.spaceM),
                    _buildChipsAbordagem(),
                  ],
                  const SizedBox(height: AppConstants.spaceS),
                  Text(
                    _carregando
                        ? 'Carregando profissionais...'
                        : '${resultados.length} profissionais encontrados',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
            Expanded(child: _buildCorpo(resultados)),
          ],
        ),
      ),
    );
  }

  Widget _buildCorpo(List<PsychologistModel> resultados) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erro != null) {
      return _buildErro(_erro!);
    }
    if (resultados.isEmpty) {
      return _buildEstadoVazio();
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.screenPadding,
          0,
          AppConstants.screenPadding,
          AppConstants.screenPadding,
        ),
        itemCount: resultados.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppConstants.spaceM),
        itemBuilder: (context, index) {
          final psicologo = resultados[index];
          final temTelefone =
              psicologo.telefone != null && psicologo.telefone!.isNotEmpty;

          return PsychologistCard(
            psicologo: psicologo,
            showWhatsApp: temTelefone,
            onVerPerfil: () => _abrirPerfil(psicologo),
            onWhatsApp: () => _mostrarContato(psicologo),
          );
        },
      ),
    );
  }

  /// Mostra o telefone cadastrado. Abrir o WhatsApp exige um pacote de
  /// deep link (url_launcher), então por ora exibimos o contato.
  void _mostrarContato(PsychologistModel psicologo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contato: ${psicologo.telefone}')),
    );
  }

  Widget _buildCampoBusca() {
    return TextField(
      controller: _buscaController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Nome, abordagem, especialidade...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
        suffixIcon: _buscaController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textHint),
                onPressed: () {
                  _buscaController.clear();
                  setState(() {});
                },
              ),
      ),
    );
  }

  /// Chips horizontais de filtro rápido por abordagem terapêutica.
  Widget _buildChipsAbordagem() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FiltroChip(
            label: 'Todas',
            selecionado: _abordagemFiltro == null,
            onTap: () => setState(() => _abordagemFiltro = null),
          ),
          for (final abordagem in _abordagensDisponiveis) ...[
            const SizedBox(width: 8),
            _FiltroChip(
              label: abordagem.label,
              selecionado: _abordagemFiltro == abordagem,
              onTap: () => setState(() => _abordagemFiltro = abordagem),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErro(String mensagem) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: AppConstants.spaceM),
            Text(mensagem, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
            const SizedBox(height: AppConstants.spaceM),
            ElevatedButton(onPressed: _carregar, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: AppConstants.spaceM),
            Text('Nenhum psicólogo encontrado', style: AppTextStyles.heading3),
            const SizedBox(height: 4),
            Text(
              'Tente ajustar os termos de busca ou os filtros aplicados.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de seleção usado nos filtros rápidos.
class _FiltroChip extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(color: selecionado ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selecionado ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
