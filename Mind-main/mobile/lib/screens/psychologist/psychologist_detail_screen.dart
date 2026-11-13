import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/horario_model.dart';
import '../../models/psychologist_model.dart';
import '../../services/agenda_service.dart';
import '../../services/horario_service.dart';
import '../../widgets/avatar_circle.dart';
import '../../widgets/primary_button.dart';

/// -----------------------------------------------------------------------
/// PsychologistDetailScreen
/// -----------------------------------------------------------------------
/// Perfil do profissional com os horários livres e o agendamento.
///
///   GET  /horarios/psicologo/{id}/disponiveis
///   POST /agendas  { pacienteId, psicologoId, horarioId }
///
/// Ao agendar, o backend marca o horário como indisponível. A tela devolve
/// `true` no `pop` para que a Home/Consultas se atualizem.
/// -----------------------------------------------------------------------
class PsychologistDetailScreen extends StatefulWidget {
  final PsychologistModel psicologo;

  const PsychologistDetailScreen({super.key, required this.psicologo});

  @override
  State<PsychologistDetailScreen> createState() =>
      _PsychologistDetailScreenState();
}

class _PsychologistDetailScreenState extends State<PsychologistDetailScreen> {
  List<HorarioModel> _horarios = const [];
  HorarioModel? _selecionado;

  bool _carregando = true;
  bool _agendando = false;
  String? _erro;

  PsychologistModel get _psicologo => widget.psicologo;

  @override
  void initState() {
    super.initState();
    _carregarHorarios();
  }

  Future<void> _carregarHorarios() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final horarios =
          await HorarioService.instance.listarDisponiveis(_psicologo.id);
      if (!mounted) return;
      setState(() {
        _horarios = horarios;
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

  Future<void> _agendar() async {
    final horario = _selecionado;
    final usuario = auth.usuario;

    if (horario == null || usuario == null) return;

    // Só paciente agenda: o backend cria a agenda com pacienteId.
    if (usuario.isPsicologo) {
      _mostrarMensagem('Apenas contas de paciente podem agendar sessões.');
      return;
    }

    setState(() {
      _agendando = true;
      _erro = null;
    });

    try {
      await AgendaService.instance.agendar(
        pacienteId: usuario.id,
        psicologoId: _psicologo.id,
        horarioId: horario.id,
      );

      if (!mounted) return;
      _mostrarMensagem('Sessão agendada para ${horario.descricao}.');
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.mensagem;
        _agendando = false;
      });
      // O horário pode ter sido tomado por outra pessoa: recarrega a lista.
      _carregarHorarios();
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_psicologo.nomeCompleto)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          children: [
            _buildCabecalho(),
            const SizedBox(height: AppConstants.spaceL),
            if (_psicologo.sobreMim != null && _psicologo.sobreMim!.isNotEmpty) ...[
              Text('Sobre', style: AppTextStyles.heading3),
              const SizedBox(height: AppConstants.spaceS),
              Text(_psicologo.sobreMim!, style: AppTextStyles.body),
              const SizedBox(height: AppConstants.spaceL),
            ],
            Text('Horários disponíveis', style: AppTextStyles.heading3),
            const SizedBox(height: AppConstants.spaceS),
            if (_carregando)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spaceL),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_horarios.isEmpty)
              Text(
                'Este profissional ainda não publicou horários livres.',
                style: AppTextStyles.bodySecondary,
              )
            else
              Wrap(
                spacing: AppConstants.spaceS,
                runSpacing: AppConstants.spaceS,
                children: _horarios
                    .map((h) => _HorarioChip(
                          horario: h,
                          selecionado: _selecionado?.id == h.id,
                          onTap: () => setState(() => _selecionado = h),
                        ))
                    .toList(),
              ),
            if (_erro != null) ...[
              const SizedBox(height: AppConstants.spaceM),
              Text(_erro!,
                  style:
                      AppTextStyles.bodySecondary.copyWith(color: AppColors.error)),
            ],
            const SizedBox(height: AppConstants.spaceL),
            PrimaryButton(
              label: _selecionado == null
                  ? 'Escolha um horário'
                  : 'Agendar ${_selecionado!.descricao}',
              isLoading: _agendando,
              onPressed: _selecionado == null ? null : _agendar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalho() {
    final detalhes = <String>[
      if (_psicologo.crp != null && _psicologo.crp!.isNotEmpty)
        'CRP ${_psicologo.crp}',
      if (_psicologo.local != null && _psicologo.local!.isNotEmpty)
        _psicologo.local!,
      if (_psicologo.idade != null) '${_psicologo.idade} anos',
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarCircle(
            iniciais: _psicologo.iniciais,
            seed: _psicologo.id,
            fotoUrl: _psicologo.fotoUrl,
            size: 64,
          ),
          const SizedBox(width: AppConstants.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_psicologo.nomeCompleto, style: AppTextStyles.heading2),
                if (detalhes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(detalhes.join(' · '), style: AppTextStyles.bodySecondary),
                ],
                if (_psicologo.especialidades.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spaceS),
                  Text(_psicologo.especialidades.join(' • '),
                      style: AppTextStyles.bodySecondary),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip selecionável de horário ("Seg · 14:00 - 15:00").
class _HorarioChip extends StatelessWidget {
  final HorarioModel horario;
  final bool selecionado;
  final VoidCallback onTap;

  const _HorarioChip({
    required this.horario,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(
              color: selecionado ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          horario.descricao,
          style: AppTextStyles.body.copyWith(
            color: selecionado ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
