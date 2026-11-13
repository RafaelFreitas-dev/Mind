/// -----------------------------------------------------------------------
/// AppConstants
/// -----------------------------------------------------------------------
/// Valores fixos reutilizados em várias telas (paddings, raios de borda,
/// durações de animação, etc). Evita "números mágicos" espalhados pelo
/// código e padroniza o espaçamento visual do app.
/// -----------------------------------------------------------------------
class AppConstants {
  AppConstants._();

  // Espaçamentos (padding/margin)
  static const double spaceXS = 4;
  static const double spaceS = 8;
  static const double spaceM = 16;
  static const double spaceL = 24;
  static const double spaceXL = 32;

  // Raios de borda (border radius)
  static const double radiusS = 8;
  static const double radiusM = 14;
  static const double radiusL = 20;
  static const double radiusPill = 100;

  // Padding horizontal padrão usado na maioria das telas
  static const double screenPadding = 20;

  // Duração padrão de animações/transições
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);

  // Nome do app
  static const String appName = 'Mind';
  static const String appTagline = 'your mind';
}
