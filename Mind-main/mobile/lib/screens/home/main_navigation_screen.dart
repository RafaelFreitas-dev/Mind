import 'package:flutter/material.dart';
import '../../widgets/main_bottom_nav.dart';
import '../appointments/appointments_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'home_screen.dart';

/// -----------------------------------------------------------------------
/// MainNavigationScreen
/// -----------------------------------------------------------------------
/// Tela "casca" que hospeda as 4 abas principais do app (Início, Buscar,
/// Consultas, Perfil) e a barra de navegação inferior compartilhada.
///
/// Usamos [IndexedStack] em vez de trocar o widget diretamente porque
/// ele preserva o estado de cada aba (ex: posição de scroll, filtros
/// aplicados) mesmo quando o usuário navega entre elas.
/// -----------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _abaAtual = 0;

  late final List<Widget> _telas = [
    // A Home precisa conseguir levar o usuário para a aba de busca.
    HomeScreen(onIrParaBusca: () => _irParaAba(1)),
    const SearchScreen(),
    const AppointmentsScreen(),
    const ProfileScreen(),
  ];

  void _irParaAba(int indice) => setState(() => _abaAtual = indice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _abaAtual,
        children: _telas,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _abaAtual,
        onTap: _irParaAba,
      ),
    );
  }
}
