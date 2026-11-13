import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../models/psychologist_model.dart';
import '../../services/agenda_service.dart';
import '../../services/psicologo_service.dart';
import '../../widgets/psychologist_card.dart';
import '../psychologist/psychologist_detail_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/next_session_card.dart';
import 'widgets/quick_stats_row.dart';

/// -----------------------------------------------------------------------
/// HomeScreen
/// -----------------------------------------------------------------------
/// Tela inicial (dashboard). Os dados vêm do backend:
///
///   GET /psicologos              → seção "Recomendados"
///   GET /agendas/paciente/{id}   → "Próxima sessão" e estatísticas
///   GET /agendas/psicologo/{id}  → idem, quando quem entrou é psicólogo
///
/// A tela mostra estado de carregamento e de erro (com "Tentar novamente"),
/// e suporta "puxar para atualizar".
/// -----------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  /// Permite que a Home leve o usuário para a aba de busca ao tocar no
  /// campo de pesquisa (a troca de abas é controlada pelo
  /// MainNavigationScreen).
  final VoidCallback? onIrParaBusca;

  const HomeScreen({super.key, this.onIrParaBusca});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _humorSelecionado;

  List<AppointmentModel> _consultas = const [];
  List<PsychologistModel> _recomendados = const [];

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
      final usuario = auth.usuario;

      // A lista de psicólogos é pública; as agendas dependem do usuário.
      final recomendadosFuture = PsicologoService.instance.listarTodos();
      final consultasFuture = usuario == null
          ? Future<List<AppointmentModel>>.value(const [])
          : usuario.isPsicologo
              ? AgendaService.instance.listarDoPsicologo(usuario.id)
              : AgendaService.instance.listarDoPaciente(usuario.id);

      final recomendados = await recomendadosFuture;
      final consultas = await consultasFuture;

      if (!mounted) return;
      setState(() {
        _recomendados = recomendados;
        _consultas = consultas;
        _carregando = false;
      });

      _publicarEstatisticas(consultas);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.mensagem;
        _carregando = false;
      });
    }
  }

  /// Alimenta o perfil com números reais em vez de valores fixos.
  void _publicarEstatisticas(List<AppointmentModel> consultas) {
    final concluidas =
        consultas.where((c) => c.status == AppointmentStatus.concluida).length;
    final psicologosDistintos =
        consultas.map((c) => c.psicologo.id).toSet().length;

    auth.atualizarEstatisticas(
      totalSessoes: concluidas,
      totalPsicologos: psicologosDistintos,
    );
  }

  /// Próxima consulta agendada ainda por acontecer.
  AppointmentModel? get _proximaConsulta {
    for (final consulta in _consultas) {
      if (!consulta.isAgendada) continue;
      final data = consulta.dataHora;
      if (data == null || data.isAfter(DateTime.now())) return consulta;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final usuario = auth.usuario;
    final proximaConsulta = _proximaConsulta;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _carregar,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              HomeHeader(
                nomeUsuario: usuario?.primeiroNome ?? 'visitante',
                humorSelecionado: _humorSelecionado,
                onHumorSelecionado: (humor) =>
                    setState(() => _humorSelecionado = humor),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBarraDeBusca(context),
                    const SizedBox(height: AppConstants.spaceL),

                    if (_erro != null) _buildErro(_erro!),

                    if (proximaConsulta != null) ...[
                      _buildTituloSecao('Próxima sessão'),
                      const SizedBox(height: AppConstants.spaceS),
                      NextSessionCard(
                        consulta: proximaConsulta,
                        onEntrarNaSala: _avisarVideochamada,
                      ),
                      const SizedBox(height: AppConstants.spaceL),
                    ],

                    _buildTituloSecao(
                      'Recomendados',
                      onVerTodas: widget.onIrParaBusca,
                    ),
                    const SizedBox(height: AppConstants.spaceS),
                    if (_carregando)
                      _buildCarregando()
                    else if (_recomendados.isEmpty)
                      _buildListaVazia()
                    else
                      ..._recomendados.take(5).map(
                            (psicologo) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppConstants.spaceM),
                              child: PsychologistCard(
                                psicologo: psicologo,
                                onVerPerfil: () => _abrirPerfil(psicologo),
                              ),
                            ),
                          ),

                    _buildBannerPlanos(),
                    const SizedBox(height: AppConstants.spaceL),

                    QuickStatsRow.perfil(
                      sessoes: usuario?.totalSessoes ?? 0,
                      meses: usuario?.mesesDeJornada ?? 0,
                      psicologos: usuario?.totalPsicologos ?? 0,
                    ),
                    const SizedBox(height: AppConstants.spaceL),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _avisarVideochamada() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A sala de atendimento está disponível no site do Mind.'),
      ),
    );
  }

  Widget _buildBarraDeBusca(BuildContext context) {
    return TextField(
      readOnly: true, // Ao tocar, leva para a aba de busca completa.
      onTap: widget.onIrParaBusca,
      decoration: const InputDecoration(
        hintText: 'Buscar psicólogos...',
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint),
      ),
    );
  }

  Widget _buildTituloSecao(String titulo, {VoidCallback? onVerTodas}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: AppTextStyles.heading2),
        if (onVerTodas != null)
          GestureDetector(
            onTap: onVerTodas,
            child: Text('Ver todas', style: AppTextStyles.link),
          ),
      ],
    );
  }

  Widget _buildCarregando() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.spaceXL),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildListaVazia() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spaceL),
      child: Text(
        'Nenhum psicólogo cadastrado ainda.',
        style: AppTextStyles.bodySecondary,
      ),
    );
  }

  Widget _buildErro(String mensagem) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppConstants.spaceL),
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mensagem,
              style: AppTextStyles.bodySecondary.copyWith(color: AppColors.error)),
          const SizedBox(height: AppConstants.spaceS),
          TextButton(onPressed: _carregar, child: const Text('Tentar novamente')),
        ],
      ),
    );
  }

  /// Banner promocional de planos exibido no fim do feed da Home.
  Widget _buildBannerPlanos() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceM),
      margin: const EdgeInsets.only(bottom: AppConstants.spaceL),
      decoration: BoxDecoration(
        color: AppColors.backgroundMint,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONHEÇA NOSSOS PLANOS',
              style: AppTextStyles.inputLabel.copyWith(color: AppColors.primary)),
          const SizedBox(height: 4),
          Text('A partir de R\$ 50/mês', style: AppTextStyles.heading2),
          const SizedBox(height: 2),
          Text('Sessões ilimitadas com valores reduzidos',
              style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}
