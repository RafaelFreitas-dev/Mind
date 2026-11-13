import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// -----------------------------------------------------------------------
/// PrimaryButton
/// -----------------------------------------------------------------------
/// Botão de ação principal (laranja), usado em "Próximo", "Entrar",
/// "Criar conta", "Aplicar filtros", etc.
///
/// Centralizar esse widget evita duplicar o mesmo ElevatedButton em
/// dezenas de telas e permite adicionar comportamentos globais depois
/// (ex: haptic feedback, loading state) em um único lugar.
/// -----------------------------------------------------------------------
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: backgroundColor != null
          ? ElevatedButton.styleFrom(backgroundColor: backgroundColor)
          : null,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: AppColors.textOnPrimary),
                  const SizedBox(width: 8),
                ],
                Text(label, style: AppTextStyles.button),
              ],
            ),
    );
  }
}
