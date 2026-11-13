import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/state/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../home/widgets/quick_stats_row.dart';
import '../legal/terms_of_use_screen.dart';
import '../notifications/notifications_screen.dart';

/// -----------------------------------------------------------------------
/// ProfileScreen
/// -----------------------------------------------------------------------
/// Perfil do usuário autenticado. Os dados vêm da sessão carregada no
/// login (GET /{tipo}/login/{login} + /{tipo}/{id}/configuracoes) e são
/// mantidos pelo AuthController.
///
/// "Sair da conta" chama POST /api/auth/logout, que invalida o refresh
/// token no backend, e limpa a sessão local.
/// -----------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificacoesAtivas = true;
  bool _saindo = false;

  Future<void> _confirmarSairDaConta() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    setState(() => _saindo = true);
    await auth.logout();
    // A AuthGate (em main.dart) observa o estado e volta para o login
    // automaticamente — não é preciso navegar aqui.
    if (mounted) setState(() => _saindo = false);
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder redesenha o perfil quando os dados do usuário
    // mudam (ex: após recarregar a sessão ou atualizar estatísticas).
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        final usuario = auth.usuario;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: usuario == null
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: auth.recarregarUsuario,
                    child: ListView(
                      padding: const EdgeInsets.all(AppConstants.screenPadding),
                      children: [
                        _buildCabecalhoUsuario(usuario),
                        const SizedBox(height: AppConstants.spaceL),
                        QuickStatsRow.perfil(
                          sessoes: usuario.totalSessoes,
                          meses: usuario.mesesDeJornada,
                          psicologos: usuario.totalPsicologos,
                        ),
                        const SizedBox(height: AppConstants.spaceL),
                        _buildSecaoDados(usuario),
                        const SizedBox(height: AppConstants.spaceL),
                        _buildSecaoConfiguracoes(),
                        const SizedBox(height: AppConstants.spaceL),
                        _buildBotaoSair(),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// Cartão verde no topo com foto/inicial, nome, e-mail e tipo de conta.
  Widget _buildCabecalhoUsuario(UserModel usuario) {
    final foto = usuario.fotoUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceL),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white24,
            backgroundImage: foto == null ? null : NetworkImage(foto),
            child: foto != null
                ? null
                : Text(
                    usuario.inicial,
                    style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
          ),
          const SizedBox(height: AppConstants.spaceS),
          Text(usuario.nomeCompleto,
              style: AppTextStyles.heading2.copyWith(color: Colors.white)),
          if (usuario.email.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(usuario.email,
                style: AppTextStyles.bodySecondary.copyWith(color: Colors.white70)),
          ],
          const SizedBox(height: AppConstants.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            ),
            child: Text(
              usuario.isPsicologo ? 'Psicólogo(a)' : usuario.plano,
              style: AppTextStyles.caption
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  /// Dados cadastrais vindos do endpoint de configurações.
  Widget _buildSecaoDados(UserModel usuario) {
    final itens = <_SettingsItemData>[
      _SettingsItemData(
        icon: Icons.alternate_email_rounded,
        label: 'Usuário',
        trailing: Text(usuario.login, style: AppTextStyles.bodySecondary),
      ),
      if (usuario.telefone != null && usuario.telefone!.isNotEmpty)
        _SettingsItemData(
          icon: Icons.phone_rounded,
          label: 'Telefone',
          trailing: Text(usuario.telefone!, style: AppTextStyles.bodySecondary),
        ),
      if (usuario.cidade != null && usuario.cidade!.isNotEmpty)
        _SettingsItemData(
          icon: Icons.place_outlined,
          label: 'Cidade',
          trailing: Text(
            [usuario.cidade, usuario.uf].whereType<String>().join(' / '),
            style: AppTextStyles.bodySecondary,
          ),
        ),
      if (usuario.isPsicologo && usuario.crp != null && usuario.crp!.isNotEmpty)
        _SettingsItemData(
          icon: Icons.badge_outlined,
          label: 'CRP',
          trailing: Text(usuario.crp!, style: AppTextStyles.bodySecondary),
        ),
    ];

    return _SettingsGroup(itens: itens);
  }

  Widget _buildSecaoConfiguracoes() {
    return _SettingsGroup(
      itens: [
        _SettingsItemData(
          icon: Icons.notifications_none_rounded,
          label: 'Notificações',
          trailing: Switch(
            value: _notificacoesAtivas,
            activeThumbColor: AppColors.accent,
            onChanged: (valor) => setState(() => _notificacoesAtivas = valor),
          ),
        ),
        _SettingsItemData(
          icon: Icons.inbox_rounded,
          label: 'Minhas notificações',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        ),
        _SettingsItemData(
          icon: Icons.description_outlined,
          label: 'Termos de Uso',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TermsOfUseScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoSair() {
    return TextButton.icon(
      onPressed: _saindo ? null : _confirmarSairDaConta,
      icon: _saindo
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
      label: const Text('Sair da conta',
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
    );
  }
}

/// Estrutura de um item da lista de configurações/atalhos.
class _SettingsItemData {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsItemData(
      {required this.icon, required this.label, this.onTap, this.trailing});
}

/// Agrupamento visual (card branco arredondado) de itens de configuração,
/// separados por divisores — reaproveitado nas seções do perfil.
class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItemData> itens;
  const _SettingsGroup({required this.itens});

  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(itens.length, (index) {
          final item = itens[index];
          final isUltimo = index == itens.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: AppColors.textPrimary),
                title: Text(item.label, style: AppTextStyles.body),
                trailing: item.trailing ??
                    (item.onTap == null
                        ? null
                        : const Icon(Icons.chevron_right_rounded,
                            color: AppColors.textHint)),
                onTap: item.onTap,
              ),
              if (!isUltimo) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }
}
