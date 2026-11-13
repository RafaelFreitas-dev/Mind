import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../legal/terms_of_use_screen.dart';

/// -----------------------------------------------------------------------
/// SignupScreen
/// -----------------------------------------------------------------------
/// Criação de conta. Envia para o backend:
///
///   POST /pacientes/cadastrar   → nome, sobrenome, email, login, senha,
///                                 telefone, cep, numeroResidencia
///   POST /psicologos/cadastrar  → idem + crp e especialidades
///
/// O `login` enviado é o próprio e-mail (mesmo padrão do site). O CEP é
/// opcional: quando informado, o backend consulta o ViaCEP e preenche
/// cidade/UF/logradouro automaticamente.
///
/// Após o cadastro o app já faz login e entra na navegação principal.
/// -----------------------------------------------------------------------
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();

  // Exclusivos do psicólogo
  final _crpController = TextEditingController();
  final _especialidadesController = TextEditingController();

  // Papel selecionado (Paciente por padrão, como no design).
  UserRole _roleSelecionado = UserRole.paciente;
  bool _isLoading = false;
  String? _erro;

  bool get _isPsicologo => _roleSelecionado == UserRole.psicologo;

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    _crpController.dispose();
    _especialidadesController.dispose();
    super.dispose();
  }

  Future<void> _handleCriarConta() async {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    final aceitou = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const TermsOfUseScreen(askForAcceptance: true)),
    );
    if (!mounted || aceitou != true) return;

    setState(() {
      _isLoading = true;
      _erro = null;
    });

    try {
      final nome = _nomeController.text.trim();
      final sobrenome = _sobrenomeController.text.trim();
      final email = _emailController.text.trim();
      final senha = _senhaController.text;
      final cep = _somenteDigitos(_cepController.text);
      final numero = _numeroController.text.trim();

      if (_isPsicologo) {
        await auth.cadastrarPsicologo(
          nome: nome,
          sobrenome: sobrenome,
          email: email,
          senha: senha,
          crp: _crpController.text.trim(),
          especialidades: _especialidades(),
          cep: cep,
          numeroResidencia: numero,
        );
      } else {
        await auth.cadastrarPaciente(
          nome: nome,
          sobrenome: sobrenome,
          email: email,
          senha: senha,
          telefone: _telefoneController.text.trim(),
          cep: cep,
          numeroResidencia: numero,
        );
      }

      if (!mounted) return;
      // Volta à raiz (AuthGate), que já vê o usuário logado e mostra a
      // navegação principal — ver comentário na LoginScreen.
      Navigator.of(context).popUntil((rota) => rota.isFirst);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.mensagem);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = 'Não foi possível criar a conta. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// "Ansiedade, TCC, Luto" → ["Ansiedade", "TCC", "Luto"]
  List<String> _especialidades() => _especialidadesController.text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  String? _somenteDigitos(String texto) {
    final digitos = texto.replaceAll(RegExp(r'\D'), '');
    return digitos.isEmpty ? null : digitos;
  }

  String? _validarObrigatorio(String? valor, String mensagem) {
    if (valor == null || valor.trim().isEmpty) return mensagem;
    return null;
  }

  String? _validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Informe seu e-mail';
    final valido =
        RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(valor.trim());
    return valido ? null : 'E-mail inválido';
  }

  String? _validarCep(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null; // opcional
    final digitos = valor.replaceAll(RegExp(r'\D'), '');
    return digitos.length == 8 ? null : 'CEP deve ter 8 dígitos';
  }

  String? _validarConfirmacaoSenha(String? valor) {
    if (valor != _senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Criar conta', style: AppTextStyles.heading3),
            Text('Comece sua jornada', style: AppTextStyles.caption),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SOU UM', style: AppTextStyles.inputLabel),
                const SizedBox(height: 8),
                _buildSeletorDeRole(),
                const SizedBox(height: AppConstants.spaceM),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Nome',
                        hint: 'João',
                        controller: _nomeController,
                        validator: (v) => _validarObrigatorio(v, 'Informe seu nome'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceS),
                    Expanded(
                      child: AppTextField(
                        label: 'Sobrenome',
                        hint: 'Silva',
                        controller: _sobrenomeController,
                        validator: (v) => _validarObrigatorio(v, 'Informe o sobrenome'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'E-mail',
                  hint: 'joao@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarEmail,
                ),
                const SizedBox(height: AppConstants.spaceM),

                if (!_isPsicologo) ...[
                  AppTextField(
                    label: 'Telefone',
                    hint: '(11) 99999-9999',
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => _validarObrigatorio(v, 'Informe seu telefone'),
                  ),
                  const SizedBox(height: AppConstants.spaceM),
                ],

                if (_isPsicologo) ...[
                  AppTextField(
                    label: 'CRP',
                    hint: '06/123456',
                    controller: _crpController,
                    validator: (v) => _validarObrigatorio(v, 'Informe seu CRP'),
                  ),
                  const SizedBox(height: AppConstants.spaceM),
                  AppTextField(
                    label: 'Especialidades e abordagens',
                    hint: 'Ansiedade, Depressão, TCC',
                    controller: _especialidadesController,
                  ),
                  const SizedBox(height: 4),
                  Text('Separe por vírgula.', style: AppTextStyles.caption),
                  const SizedBox(height: AppConstants.spaceM),
                ],

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        label: 'CEP (opcional)',
                        hint: '04571-010',
                        controller: _cepController,
                        keyboardType: TextInputType.number,
                        validator: _validarCep,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceS),
                    Expanded(
                      child: AppTextField(
                        label: 'Número',
                        hint: '123',
                        controller: _numeroController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Senha',
                  hint: 'Mín. 8 caracteres',
                  controller: _senhaController,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length < 8) return 'Mínimo de 8 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Confirmar senha',
                  hint: 'Repita a senha',
                  controller: _confirmarSenhaController,
                  obscureText: true,
                  validator: _validarConfirmacaoSenha,
                ),

                const SizedBox(height: AppConstants.spaceM),

                if (_erro != null) ...[
                  const SizedBox(height: AppConstants.spaceM),
                  _buildMensagemDeErro(_erro!),
                ],

                const SizedBox(height: AppConstants.spaceL),
                PrimaryButton(
                  label: 'Continuar',
                  isLoading: _isLoading,
                  onPressed: _handleCriarConta,
                  backgroundColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Seletor "Paciente" / "Psicólogo" (segmented control customizado).
  Widget _buildSeletorDeRole() {
    return Row(
      children: [
        Expanded(
          child: _RoleOption(
            label: 'Paciente',
            selecionado: _roleSelecionado == UserRole.paciente,
            onTap: () => setState(() => _roleSelecionado = UserRole.paciente),
          ),
        ),
        const SizedBox(width: AppConstants.spaceS),
        Expanded(
          child: _RoleOption(
            label: 'Psicólogo',
            selecionado: _roleSelecionado == UserRole.psicologo,
            onTap: () => setState(() => _roleSelecionado = UserRole.psicologo),
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
