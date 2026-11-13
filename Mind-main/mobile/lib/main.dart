import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/state/auth_controller.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_navigation_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

/// -----------------------------------------------------------------------
/// main
/// -----------------------------------------------------------------------
/// Ponto de entrada da aplicação. Mantido enxuto de propósito: tema em
/// `core/theme`, rotas em `core/routes` e sessão em `core/state`.
///
/// Antes de mostrar a primeira tela, tentamos restaurar a sessão salva no
/// dispositivo (JWT + refresh token), para que o usuário já logado entre
/// direto na navegação principal.
/// -----------------------------------------------------------------------
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // A verificação da sessão roda em paralelo à primeira renderização; a
  // AuthGate mostra um splash enquanto o status é "verificando".
  auth.inicializar();

  runApp(const MindApp());
}

/// Widget raiz do aplicativo Mind.
class MindApp extends StatelessWidget {
  const MindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
      routes: AppRoutes.routes,
    );
  }
}

/// -----------------------------------------------------------------------
/// AuthGate
/// -----------------------------------------------------------------------
/// Decide a primeira tela conforme o estado da sessão:
///   verificando → splash
///   logado      → navegação principal
///   deslogado   → onboarding (primeira vez) ou login
/// -----------------------------------------------------------------------
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        switch (auth.status) {
          case AuthStatus.verificando:
            return const _SplashScreen();
          case AuthStatus.logado:
            return const MainNavigationScreen();
          case AuthStatus.deslogado:
            return auth.onboardingVisto
                ? const LoginScreen()
                : const OnboardingScreen();
        }
      },
    );
  }
}

/// Tela de carregamento exibida enquanto a sessão é verificada.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.spa_rounded, size: 44, color: cores.primary),
            const SizedBox(height: AppConstants.spaceS),
            Text(AppConstants.appName,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppConstants.spaceL),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
