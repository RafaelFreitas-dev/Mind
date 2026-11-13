import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// AppColors
/// -----------------------------------------------------------------------
/// Centraliza TODAS as cores usadas no app.
///
/// Por que fazer isso?
/// - Evita cores "mágicas" espalhadas pelo código (ex: Color(0xFF1E4B3C))
/// - Se o time de design mudar a paleta, alteramos em um único lugar
/// - Facilita futuramente implementar um tema escuro (dark mode)
/// -----------------------------------------------------------------------
class AppColors {
  // Construtor privado: impede que a classe seja instanciada.
  // Ela deve ser usada apenas de forma estática (AppColors.primary).
  AppColors._();

  // ---------------------------------------------------------------------
  // Cores de marca (Brand)
  // ---------------------------------------------------------------------
  /// Verde escuro principal - usado em headers, textos de destaque e logo.
  static const Color primary = Color(0xFF1E4B3C);

  /// Verde um pouco mais claro, usado em variações/hover do primary.
  static const Color primaryLight = Color(0xFF2E6B54);

  /// Laranja - cor de ação (CTA), botões principais, elementos ativos.
  static const Color accent = Color(0xFFE8834A);

  /// Variação mais escura do laranja (ex: estado pressionado do botão).
  static const Color accentDark = Color(0xFFD4712F);

  // ---------------------------------------------------------------------
  // Backgrounds (fundos de tela)
  // ---------------------------------------------------------------------
  /// Fundo padrão do app (bege claro, usado em login/cadastro/perfil).
  static const Color background = Color(0xFFF5EFE3);

  /// Fundo verde-claro (usado no onboarding "Encontre o psicólogo ideal").
  static const Color backgroundMint = Color(0xFFDCEAE2);

  /// Fundo pêssego (usado no onboarding "Agende com facilidade").
  static const Color backgroundPeach = Color(0xFFF3E1D2);

  /// Branco puro - cards, inputs, superfícies elevadas.
  static const Color surface = Color(0xFFFFFFFF);

  /// Fundo levemente acinzentado para inputs e campos de formulário.
  static const Color inputFill = Color(0xFFECE6D9);

  // ---------------------------------------------------------------------
  // Textos
  // ---------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF2A2A28);
  static const Color textSecondary = Color(0xFF6E6B63);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFF9B978C);

  // ---------------------------------------------------------------------
  // Estados e feedback
  // ---------------------------------------------------------------------
  static const Color success = Color(0xFF3E8E5C);
  static const Color warning = Color(0xFFE0A63A);
  static const Color error = Color(0xFFD64545);
  static const Color star = Color(0xFFF2B01E);

  // ---------------------------------------------------------------------
  // Bordas e divisores
  // ---------------------------------------------------------------------
  static const Color border = Color(0xFFE1DACB);
  static const Color divider = Color(0xFFEDE7DA);

  // ---------------------------------------------------------------------
  // Cores de avatar (fallback quando o psicólogo não tem foto)
  // Usadas ciclicamente pelos cards de listagem.
  // ---------------------------------------------------------------------
  static const List<Color> avatarPalette = [
    Color(0xFFE8834A), // laranja
    Color(0xFF5B8A72), // verde
    Color(0xFFC97B93), // rosa
    Color(0xFF6E93B7), // azul
  ];
}
