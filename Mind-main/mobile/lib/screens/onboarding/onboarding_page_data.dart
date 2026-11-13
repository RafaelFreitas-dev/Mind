import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// -----------------------------------------------------------------------
/// OnboardingPageData
/// -----------------------------------------------------------------------
/// Estrutura simples com o conteúdo de cada página do onboarding
/// (imagem/ícone, título, descrição e cor de fundo).
///
/// Manter esses dados separados da tela permite adicionar/remover
/// páginas do onboarding sem tocar na lógica de navegação/PageView.
/// -----------------------------------------------------------------------
class OnboardingPageData {
  final IconData icon;
  final String titulo;
  final String descricao;
  final Color corFundo;

  const OnboardingPageData({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.corFundo,
  });

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      icon: Icons.search_rounded,
      titulo: 'Encontre o psicólogo ideal',
      descricao: 'Filtre por abordagem, valor e horário. Todos os profissionais têm CRP ativo e verificado.',
      corFundo: AppColors.backgroundMint,
    ),
    OnboardingPageData(
      icon: Icons.calendar_month_rounded,
      titulo: 'Agende com facilidade',
      descricao: 'Escolha data e horário que funcionam para você. Confirmação imediata e lembrete automático.',
      corFundo: AppColors.backgroundPeach,
    ),
    OnboardingPageData(
      icon: Icons.laptop_mac_rounded,
      titulo: 'Sessões online seguras',
      descricao: 'Videoconferência com criptografia de ponta a ponta. Prontuário eletrônico protegido.',
      corFundo: AppColors.backgroundMint,
    ),
  ];
}
