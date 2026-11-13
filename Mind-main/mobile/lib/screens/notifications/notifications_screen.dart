import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/notification_model.dart';

/// -----------------------------------------------------------------------
/// NotificationsScreen
/// -----------------------------------------------------------------------
/// Tela de notificações (imagem 9 do design). Lista alertas de sessão,
/// lembretes, pedidos de avaliação, dicas de bem-estar e conquistas.
/// -----------------------------------------------------------------------
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Nota: dados de exemplo — o backend ainda não expõe endpoint de notificações.
    final notificacoes = NotificationModel.mockList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Notificações', style: AppTextStyles.heading3),
      ),
      body: SafeArea(
        child: notificacoes.isEmpty
            ? Center(child: Text('Você está em dia! 🎉', style: AppTextStyles.bodySecondary))
            : ListView.separated(
                padding: const EdgeInsets.all(AppConstants.screenPadding),
                itemCount: notificacoes.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppConstants.spaceM),
                itemBuilder: (context, index) => _NotificationTile(notificacao: notificacoes[index]),
              ),
      ),
    );
  }
}

/// Item individual da lista de notificações.
class _NotificationTile extends StatelessWidget {
  final NotificationModel notificacao;
  const _NotificationTile({required this.notificacao});

  /// Cor de destaque do ícone de acordo com o tipo de notificação,
  /// seguindo a paleta do design (laranja para alertas de sessão,
  /// amarelo para avaliação/dica, verde para conquistas).
  Color get _corDoIcone {
    switch (notificacao.type) {
      case NotificationType.sessaoConfirmada:
      case NotificationType.lembrete:
        return AppColors.accent;
      case NotificationType.avaliacao:
      case NotificationType.dica:
        return AppColors.warning;
      case NotificationType.conquista:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: notificacao.lida ? AppColors.surface : AppColors.backgroundPeach.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _corDoIcone.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(notificacao.icone, color: _corDoIcone, size: 20),
          ),
          const SizedBox(width: AppConstants.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notificacao.titulo, style: AppTextStyles.heading3),
                const SizedBox(height: 2),
                Text(notificacao.descricao, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 6),
                Text(notificacao.tempoRelativo, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (!notificacao.lida)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
