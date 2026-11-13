import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../notifications/notifications_screen.dart';

/// -----------------------------------------------------------------------
/// HomeHeader
/// -----------------------------------------------------------------------
/// Cabeçalho verde-escuro no topo da Home: logo, sino de notificações,
/// saudação ao usuário e o seletor de humor do dia ("Como você está hoje?").
/// -----------------------------------------------------------------------
class HomeHeader extends StatelessWidget {
  final String nomeUsuario;
  final bool temNotificacaoNaoLida;
  final String? humorSelecionado;
  final ValueChanged<String> onHumorSelecionado;

  const HomeHeader({
    super.key,
    required this.nomeUsuario,
    this.temNotificacaoNaoLida = true,
    this.humorSelecionado,
    required this.onHumorSelecionado,
  });

  // Emojis disponíveis para o check-in de humor diário.
  static const Map<String, String> _opcoesDeHumor = {
    'Ótimo': '😄',
    'Bem': '🙂',
    'Ok': '😐',
    'Mal': '😔',
    'Ansioso': '😰',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.screenPadding,
        AppConstants.spaceS,
        AppConstants.screenPadding,
        AppConstants.spaceL,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusL),
          bottomRight: Radius.circular(AppConstants.radiusL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context),
          const SizedBox(height: AppConstants.spaceM),
          Text(
            'Olá, $nomeUsuario 👋',
            style: AppTextStyles.body.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            'Como você está hoje?',
            style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: AppConstants.spaceM),
          _buildSeletorDeHumor(),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.spa_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              AppConstants.appName,
              style: AppTextStyles.heading3.copyWith(color: Colors.white),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            if (temNotificacaoNaoLida)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Linha horizontal com os emojis de humor. Ao tocar, o emoji fica
  /// destacado com um fundo branco levemente transparente.
  Widget _buildSeletorDeHumor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _opcoesDeHumor.entries.map((entrada) {
        final isSelecionado = humorSelecionado == entrada.key;
        return GestureDetector(
          onTap: () => onHumorSelecionado(entrada.key),
          child: AnimatedContainer(
            duration: AppConstants.animationFast,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelecionado ? Colors.white.withValues(alpha: 0.25) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(entrada.value, style: const TextStyle(fontSize: 24)),
          ),
        );
      }).toList(),
    );
  }
}
