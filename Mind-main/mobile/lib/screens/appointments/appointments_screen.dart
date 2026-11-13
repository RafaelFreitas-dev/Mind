import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../services/agenda_service.dart';
import '../../widgets/avatar_circle.dart';

/// -----------------------------------------------------------------------
/// AppointmentsScreen
/// -----------------------------------------------------------------------
/// "Minhas consultas", com abas "Próximas" e "Histórico".
///
///   GET /agendas/paciente/{id}   (paciente)
///   GET /agendas/psicologo/{id}  (psicólogo)
///   PUT /agendas/{id}/cancelar
///
/// Usa [SingleTickerProviderStateMixin] porque o TabController precisa de
/// um "ticker" para sincronizar a animação de troca de abas.
/// -----------------------------------------------------------------------
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<AppointmentModel> _todasAsConsultas = const [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _carregar();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final usuario = auth.usuario;
    if (usuario == null) {
      setState(() => _carregando = false);
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final consultas = usuario.isPsicologo
          ? await AgendaService.instance.listarDoPsicologo(usuario.id)
          : await AgendaService.instance.listarDoPaciente(usuario.id);

      if (!mounted) return;
      setState(() {
        _todasAsConsultas = consultas;
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

  /// Agendadas que ainda não passaram (com uma folga de 1h para a sessão
  /// em andamento continuar visível).
  List<AppointmentModel> get _proximas => _todasAsConsultas.where((c) {
        if (!c.isAgendada) return false;
        final data = c.dataHora;
        if (data == null) return true; // sem horário resolvido: mostra aqui
        return !data.isBefore(DateTime.now().subtract(const Duration(hours: 1)));
      }).toList();

  /// Canceladas, concluídas e as agendadas cuja data já passou.
  List<AppointmentModel> get _historico => _todasAsConsultas.where((c) {
        if (!c.isAgendada) return true;
        final data = c.dataHora;
        if (data == null) return false;
        return data.isBefore(DateTime.now().subtract(const Duration(hours: 1)));
      }).toList();

  Future<void> _cancelar(AppointmentModel consulta) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar consulta'),
        content: Text(
          'Deseja cancelar a sessão com ${consulta.psicologo.nomeCompleto}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancelar sessão',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    try {
      await AgendaService.instance.cancelar(consulta.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consulta cancelada.')),
      );
      _carregar();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Minhas consultas',
            style: AppTextStyles.heading1.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _carregando ? null : _carregar,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accent,
          labelStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Próximas'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: SafeArea(
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _erro != null
                ? _buildErro(_erro!)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildListaConsultas(_proximas, podeCancelar: true),
                      _buildListaConsultas(_historico, podeCancelar: false),
                    ],
                  ),
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
            Text(mensagem,
                textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
            const SizedBox(height: AppConstants.spaceM),
            ElevatedButton(
                onPressed: _carregar, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }

  Widget _buildListaConsultas(
    List<AppointmentModel> consultas, {
    required bool podeCancelar,
  }) {
    if (consultas.isEmpty) {
      return RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          children: [
            SizedBox(
              height: 240,
              child: Center(
                child: Text('Nenhuma consulta por aqui.',
                    style: AppTextStyles.bodySecondary),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        itemCount: consultas.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppConstants.spaceM),
        itemBuilder: (context, index) {
          final consulta = consultas[index];
          // O primeiro item de "Próximas" ganha destaque quando é hoje,
          // igual ao comportamento visto no design.
          final isDestaque = podeCancelar && index == 0 && consulta.isHoje;
          return _AppointmentListItem(
            consulta: consulta,
            destaque: isDestaque,
            onCancelar: podeCancelar ? () => _cancelar(consulta) : null,
          );
        },
      ),
    );
  }
}

/// Item de lista representando uma única consulta (próxima ou passada).
class _AppointmentListItem extends StatelessWidget {
  final AppointmentModel consulta;
  final bool destaque;
  final VoidCallback? onCancelar;

  const _AppointmentListItem({
    required this.consulta,
    required this.destaque,
    this.onCancelar,
  });

  /// "Hoje", "Ter, 14 Out" ou o dia da semana quando não há data resolvida.
  String get _dataFormatada {
    const diasDaSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
    ];

    if (consulta.isHoje) return 'Hoje';

    final data = consulta.dataHora;
    if (data == null) return consulta.horario?.diaAbreviado ?? 'A confirmar';

    return '${diasDaSemana[data.weekday - 1]}, ${data.day} ${meses[data.month - 1]}';
  }

  String _horaFormatada(BuildContext context) {
    final data = consulta.dataHora;
    if (data != null) return TimeOfDay.fromDateTime(data).format(context);
    return consulta.horario?.horaInicio ?? '--:--';
  }

  String get _rotuloStatus {
    switch (consulta.status) {
      case AppointmentStatus.cancelada:
        return 'Cancelada';
      case AppointmentStatus.concluida:
        return 'Concluída';
      case AppointmentStatus.agendada:
        return 'Online';
    }
  }

  @override
  Widget build(BuildContext context) {
    final corDeFundo = destaque ? AppColors.accent : AppColors.surface;
    final corDeTexto = destaque ? Colors.white : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: corDeFundo,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: destaque ? null : Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          AvatarCircle(
            iniciais: consulta.psicologo.iniciais,
            seed: consulta.psicologo.id,
            fotoUrl: consulta.psicologo.fotoUrl,
          ),
          const SizedBox(width: AppConstants.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consulta.psicologo.nomeCompleto,
                  style: AppTextStyles.heading3.copyWith(color: corDeTexto),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_dataFormatada · ${_horaFormatada(context)} · $_rotuloStatus',
                  style: AppTextStyles.caption.copyWith(
                    color: destaque ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onCancelar != null)
            IconButton(
              tooltip: 'Cancelar consulta',
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: destaque ? Colors.white : AppColors.error,
              ),
              onPressed: onCancelar,
            )
          else
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
        ],
      ),
    );
  }
}
