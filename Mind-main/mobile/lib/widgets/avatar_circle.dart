import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// -----------------------------------------------------------------------
/// AvatarCircle
/// -----------------------------------------------------------------------
/// Círculo colorido com as iniciais do nome, usado como avatar sempre
/// que o usuário/psicólogo não tem foto de perfil cadastrada.
///
/// A cor é escolhida de forma determinística a partir do [seed] (ex: o id
/// do psicólogo), garantindo que o mesmo profissional sempre tenha a
/// mesma cor de avatar em todas as telas.
/// -----------------------------------------------------------------------
class AvatarCircle extends StatelessWidget {
  final String iniciais;
  final String seed;
  final double size;

  /// URL da foto de perfil servida pelo backend (GET /api/images/{arquivo}).
  /// Quando nula — ou se o download falhar — caímos nas iniciais.
  final String? fotoUrl;

  const AvatarCircle({
    super.key,
    required this.iniciais,
    required this.seed,
    this.size = 48,
    this.fotoUrl,
  });

  Color get _corDeFundo {
    final indice = seed.codeUnits.fold<int>(0, (soma, c) => soma + c) %
        AppColors.avatarPalette.length;
    return AppColors.avatarPalette[indice];
  }

  @override
  Widget build(BuildContext context) {
    final url = fotoUrl;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _corDeFundo.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: url == null || url.isEmpty
          ? _buildIniciais()
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              // Se a imagem não carregar (offline, arquivo removido), mostra
              // as iniciais em vez de um ícone de erro.
              errorBuilder: (_, _, _) => _buildIniciais(),
            ),
    );
  }

  Widget _buildIniciais() {
    return Center(
      child: Text(
        iniciais,
        style: TextStyle(
          color: _corDeFundo,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
