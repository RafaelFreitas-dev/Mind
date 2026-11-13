import 'package:flutter/material.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/home/main_navigation_screen.dart';
import '../../screens/search/filters_screen.dart';
import '../../screens/legal/terms_of_use_screen.dart';

/// -----------------------------------------------------------------------
/// AppRoutes
/// -----------------------------------------------------------------------
/// Centraliza os nomes de rota (evita strings soltas como '/login' em
/// várias telas) e o mapa de rotas usado pelo MaterialApp.
///
/// A rota inicial NÃO está aqui: quem decide a primeira tela é a
/// `AuthGate` (em main.dart), conforme o estado da sessão. Por isso
/// nenhuma entrada usa '/' — ele é ocupado pelo `home:` do MaterialApp.
///
/// Para navegar: Navigator.pushNamed(context, AppRoutes.login)
/// -----------------------------------------------------------------------
class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String filters = '/filters';
  static const String terms = '/terms';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
        main: (context) => const MainNavigationScreen(),
        filters: (context) => const FiltersScreen(),
        terms: (context) => const TermsOfUseScreen(),
      };
}
