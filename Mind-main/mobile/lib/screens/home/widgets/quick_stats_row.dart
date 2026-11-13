import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// -----------------------------------------------------------------------
/// QuickStatsRow
/// -----------------------------------------------------------------------
/// Linha com 3 cartões pequenos mostrando estatísticas rápidas do
/// usuário (sessões realizadas, meses de jornada, % de presença/psicólogos).
/// Reaproveitado na Home e no Perfil.
/// -----------------------------------------------------------------------
class QuickStatsRow extends StatelessWidget {
  final List<StatItem> itens;

  const QuickStatsRow({super.key, required this.itens});

  /// Fábrica de conveniência para os valores usados na Home
  /// (sessões, meses, presença).
  factory QuickStatsRow.home({
    required int sessoes,
    required int meses,
    required int percentualPresenca,
  }) {
    return QuickStatsRow(itens: [
      StatItem(valor: '$sessoes', label: 'Sessões'),
      StatItem(valor: '$meses', label: 'Meses'),
      StatItem(valor: '$percentualPresenca%', label: 'Presença'),
    ]);
  }

  /// Fábrica usada no Perfil (sessões, meses de jornada, psicólogos).
  factory QuickStatsRow.perfil({
    required int sessoes,
    required int meses,
    required int psicologos,
  }) {
    return QuickStatsRow(itens: [
      StatItem(valor: '$sessoes', label: 'Sessões'),
      StatItem(valor: '$meses', label: 'Meses'),
      StatItem(valor: '$psicologos', label: 'Psicólogos'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: itens
          .map((item) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(item.valor, style: AppTextStyles.heading2),
                      const SizedBox(height: 2),
                      Text(item.label, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}

/// Um cartão da linha de estatísticas (valor + rótulo).
class StatItem {
  final String valor;
  final String label;
  const StatItem({required this.valor, required this.label});
}
