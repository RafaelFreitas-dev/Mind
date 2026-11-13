import 'package:flutter/material.dart';
import 'app_colors.dart';

/// -----------------------------------------------------------------------
/// AppTextStyles
/// -----------------------------------------------------------------------
/// Centraliza os estilos de texto (tipografia) do app.
/// Assim como as cores, manter os estilos em um único lugar garante
/// consistência visual e facilita mudanças globais de fonte/tamanho.
/// -----------------------------------------------------------------------
class AppTextStyles {
  AppTextStyles._();

  // Título grande (ex: "Bem-vindo de volta", "Encontre o psicólogo ideal")
  static const TextStyle heading1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  // Título médio (ex: título de seções "Recomendados", "Próxima sessão")
  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Título de card / nome de psicólogo
  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Texto padrão do corpo
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Texto secundário (subtítulos, descrições)
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Texto pequeno (labels, tags, legendas)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Texto de botão
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  // Label de campo de formulário (ex: "E-MAIL", "SENHA")
  static const TextStyle inputLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // Links (ex: "Esqueci minha senha", "Criar agora")
  static const TextStyle link = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );
}
