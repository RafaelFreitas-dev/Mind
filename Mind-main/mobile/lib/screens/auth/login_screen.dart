import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// -----------------------------------------------------------------------
/// LoginScreen
/// -----------------------------------------------------------------------
/// Tela de login. Autentica no backend Spring Boot:
///
///   POST /pacientes/login   (paciente)
///   POST /psicologos/login  (psicólogo)
///
/// O seletor "Paciente / Psicólogo" existe porque o backend tem dois
/// endpoints distintos de autenticação, um por tipo de conta.
/// -----------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey do formulário: permite validar todos os campos de uma vez.
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  UserRole _role = UserRole.paciente;
  bool _isLoading = false;
  bool _senhaVisivel = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    // Mensagem vinda de uma sessão que expirou durante o uso.
    _erro = auth.sessaoExpiradaMensagem;
  }

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  /// Autentica no backend e entra no app.
  Future<void> _handleLogin() async {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      await auth.login(
        login: _loginController.text.trim(),
        senha: _senhaController.text,
        role: _role,
      );

      if (!mounted) return;
      // Voltamos à raiz (AuthGate), que agora observa "logado" e mostra a
      // navegação principal. Fazer isso — em vez de empilhar a Home aqui —
      // mantém a AuthGate no topo da árvore, então o logout e a expiração
      // de sessão conseguem trazer o login de volta sozinhos.
      Navigator.of(context).popUntil((rota) => rota.isFirst);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.mensagem);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = 'Não foi possível entrar. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Aceita e-mail ou nome de usuário — o backend resolve os dois
  /// (ver PacienteService.buscarPorLoginAuth).
  String? _validarLogin(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe seu e-mail ou usuário';
    }
    return null;
  }

  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe sua senha';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spaceXL),
                _buildLogo(),
                const SizedBox(height: AppConstants.spaceL),
                Text('Bem-vindo de volta', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text('Faça login para continuar', style: AppTextStyles.bodySecondary),
                const SizedBox(height: AppConstants.spaceL),

                AppTextField(
                  label: 'E-mail ou usuário',
                  hint: 'joao@email.com',
                  controller: _loginController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarLogin,
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Senha',
                  hint: '••••••••',
                  controller: _senhaController,
                  obscureText: !_senhaVisivel,
                  validator: _validarSenha,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
                const SizedBox(height: AppConstants.spaceM),

                Text('ENTRAR COMO', style: AppTextStyles.inputLabel),
                const SizedBox(height: 8),
                _buildSeletorDeRole(),

                if (_erro != null) ...[
                  const SizedBox(height: AppConstants.spaceM),
                  _buildMensagemDeErro(_erro!),
                ],

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _mostrarAvisoRecuperacaoSenha,
                    child: Text('Esqueci minha senha', style: AppTextStyles.link),
                  ),
                ),

                const SizedBox(height: AppConstants.spaceS),
                PrimaryButton(
                  label: 'Entrar',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: AppConstants.spaceXL),
                _buildRodapeCadastro(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// O fluxo de recuperação de senha existe no site, mas ainda não há
  /// endpoint dedicado no backend — avisamos em vez de deixar um botão morto.
  void _mostrarAvisoRecuperacaoSenha() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recuperação de senha disponível no site do Mind.'),
      ),
    );
  }

  Widget _buildSeletorDeRole() {
    return Row(
      children: [
        Expanded(
          child: _RoleOption(
            label: 'Paciente',
            selecionado: _role == UserRole.paciente,
            onTap: () => setState(() => _role = UserRole.paciente),
          ),
        ),
        const SizedBox(width: AppConstants.spaceS),
        Expanded(
          child: _RoleOption(
            label: 'Psicólogo',
            selecionado: _role == UserRole.psicologo,
            onTap: () => setState(() => _role = UserRole.psicologo),
          ),
        ),
      ],
    );
  }

  Widget _buildMensagemDeErro(String mensagem) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
          const SizedBox(width: AppConstants.spaceS),
          Expanded(
            child: Text(
              mensagem,
              style: AppTextStyles.bodySecondary.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        const Icon(Icons.spa_rounded, color: AppColors.primary, size: 22),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.appName, style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
            Text(AppConstants.appTagline, style: AppTextStyles.caption.copyWith(fontSize: 9)),
          ],
        ),
      ],
    );
  }

  Widget _buildRodapeCadastro() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text('Não tem conta? ', style: AppTextStyles.bodySecondary),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
            child: Text(
              'Criar agora',
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão de seleção usado no seletor "Paciente / Psicólogo".
class _RoleOption extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: selecionado ? AppColors.accent : AppColors.border,
            width: selecionado ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selecionado ? AppColors.accent : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
