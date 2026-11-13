import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// -----------------------------------------------------------------------
/// MainBottomNav
/// -----------------------------------------------------------------------
/// Barra de navegação inferior compartilhada pelas 4 telas principais do
/// app: Início, Buscar, Consultas e Perfil.
///
/// Ela é "burra" de propósito: apenas recebe o índice atual e um
/// callback de mudança. Quem decide o que fazer com a navegação é o
/// widget pai (geralmente um controlador de tabs em MainNavigationScreen).
/// Isso mantém o componente simples e fácil de testar.
/// -----------------------------------------------------------------------
class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.surface,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Consultas'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
      ],
    );
  }
}
