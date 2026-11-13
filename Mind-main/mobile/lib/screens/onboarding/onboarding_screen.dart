import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import 'onboarding_page_data.dart';

/// -----------------------------------------------------------------------
/// OnboardingScreen
/// -----------------------------------------------------------------------
/// Primeira tela vista pelo usuário: 3 slides explicando o app
/// (buscar, agendar, sessão online). Corresponde às imagens 1, 2 e 3
/// do design.
///
/// Usa um [PageController] para controlar o carrossel e um
/// [AnimatedBuilder]/setState simples para sincronizar os indicadores
/// de página (bolinhas) com o slide atual.
/// -----------------------------------------------------------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  // Observação: usamos `static final` (não `const`) porque chamar `.length`
  // em um campo `const` pode falhar na avaliação de constantes do
  // compilador web (DDC) em algumas versões do Flutter.
  static final int _totalPaginas = OnboardingPageData.pages.length;

  @override
  void dispose() {
    // Sempre liberar controllers para evitar vazamento de memória.
    _pageController.dispose();
    super.dispose();
  }

  void _irParaProximaPagina() {
    final isUltimaPagina = _paginaAtual == _totalPaginas - 1;
    if (isUltimaPagina) {
      _finalizarOnboarding();
    } else {
      _pageController.nextPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    }
  }

  /// Ao terminar o onboarding (ou pular), marcamos que ele já foi visto — nas
  /// próximas aberturas o app vai direto para o login.
  ///
  /// Quem troca a tela é a AuthGate (em main.dart), que observa esse estado.
  /// Só navegamos manualmente se esta tela tiver sido empilhada por outra
  /// (rota nomeada), caso em que basta voltar.
  Future<void> _finalizarOnboarding() async {
    final navigator = Navigator.of(context);
    final podeVoltar = navigator.canPop();

    await auth.marcarOnboardingVisto();
    if (!mounted) return;

    if (podeVoltar) {
      navigator.pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagina = OnboardingPageData.pages[_paginaAtual];

    return Scaffold(
      // O fundo muda de cor conforme a página, com uma transição suave.
      backgroundColor: pagina.corFundo,
      body: AnimatedContainer(
        duration: AppConstants.animationMedium,
        color: pagina.corFundo,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _totalPaginas,
                  onPageChanged: (index) => setState(() => _paginaAtual = index),
                  itemBuilder: (context, index) {
                    return _OnboardingSlide(data: OnboardingPageData.pages[index]);
                  },
                ),
              ),
              _buildIndicadores(),
              _buildBotaoAcao(),
            ],
          ),
        ),
      ),
    );
  }

  /// Cabeçalho com a logo "Mind" e o botão "Pular".
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPadding,
        vertical: AppConstants.spaceS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.spa_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                  ),
                  Text(AppConstants.appTagline, style: AppTextStyles.caption.copyWith(fontSize: 9)),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: _finalizarOnboarding,
            child: Text('Pular', style: AppTextStyles.link.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  /// Bolinhas indicadoras de progresso do carrossel.
  Widget _buildIndicadores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPaginas, (index) {
        final isAtiva = index == _paginaAtual;
        return AnimatedContainer(
          duration: AppConstants.animationFast,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isAtiva ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isAtiva ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          ),
        );
      }),
    );
  }

  Widget _buildBotaoAcao() {
    final isUltimaPagina = _paginaAtual == _totalPaginas - 1;
    return Padding(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      child: PrimaryButton(
        label: isUltimaPagina ? 'Começar' : 'Próximo',
        onPressed: _irParaProximaPagina,
      ),
    );
  }
}

/// Conteúdo visual de um único slide (ícone, título e descrição).
class _OnboardingSlide extends StatelessWidget {
  final OnboardingPageData data;
  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceXL),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Círculo branco com o ícone ilustrativo, conforme o design.
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 56, color: AppColors.textPrimary),
          ),
          const Spacer(flex: 2),
          Text(
            data.titulo,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppConstants.spaceS),
          Text(
            data.descricao,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
