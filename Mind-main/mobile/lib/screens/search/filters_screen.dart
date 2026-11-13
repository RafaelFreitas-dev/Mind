import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/psychologist_model.dart';
import '../../widgets/primary_button.dart';

/// Faixas de preço disponíveis no filtro (imagem 11 do design).
enum FaixaDePreco { todos, ate120, de120a180, de180a250, acima250 }

/// Opções de disponibilidade de horário.
enum Disponibilidade { todos, hoje, estaSemana, fimDeSemana }

/// -----------------------------------------------------------------------
/// FiltersScreen
/// -----------------------------------------------------------------------
/// Tela de filtros avançados (imagem 11 do design): abordagem
/// terapêutica, faixa de preço, modalidade e disponibilidade.
///
/// Ao aplicar, retorna um [FiltrosSelecionados] via `Navigator.pop`,
/// para que a tela de busca (SearchScreen) possa usar o resultado.
/// -----------------------------------------------------------------------
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final Set<Abordagem> _abordagensSelecionadas = {};
  FaixaDePreco _faixaDePreco = FaixaDePreco.todos;
  Modalidade? _modalidade; // null = Todos
  Disponibilidade _disponibilidade = Disponibilidade.todos;

  void _limparFiltros() {
    setState(() {
      _abordagensSelecionadas.clear();
      _faixaDePreco = FaixaDePreco.todos;
      _modalidade = null;
      _disponibilidade = Disponibilidade.todos;
    });
  }

  void _aplicarFiltros() {
    // Nota: os filtros avançados ainda não são repassados à busca (sem suporte na API).
    // ou gerenciamento de estado global (Provider/Riverpod/Bloc).
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Filtros', style: AppTextStyles.heading3),
        actions: [
          TextButton(
            onPressed: _limparFiltros,
            child: Text('Limpar', style: AppTextStyles.link.copyWith(color: AppColors.textPrimary)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTituloSecao('Abordagem terapêutica'),
              const SizedBox(height: AppConstants.spaceS),
              _buildChipsAbordagem(),

              _buildTituloSecao('Faixa de preço'),
              const SizedBox(height: AppConstants.spaceS),
              _buildOpcaoRadio<FaixaDePreco>(
                valor: FaixaDePreco.todos,
                label: 'Todos',
                grupo: _faixaDePreco,
                onChanged: (v) => setState(() => _faixaDePreco = v),
              ),
              _buildOpcaoRadio<FaixaDePreco>(
                valor: FaixaDePreco.ate120,
                label: 'Até R\$ 120',
                grupo: _faixaDePreco,
                onChanged: (v) => setState(() => _faixaDePreco = v),
              ),
              _buildOpcaoRadio<FaixaDePreco>(
                valor: FaixaDePreco.de120a180,
                label: 'R\$ 120 - 180',
                grupo: _faixaDePreco,
                onChanged: (v) => setState(() => _faixaDePreco = v),
              ),
              _buildOpcaoRadio<FaixaDePreco>(
                valor: FaixaDePreco.de180a250,
                label: 'R\$ 180 - 250',
                grupo: _faixaDePreco,
                onChanged: (v) => setState(() => _faixaDePreco = v),
              ),
              _buildOpcaoRadio<FaixaDePreco>(
                valor: FaixaDePreco.acima250,
                label: 'Acima de R\$ 250',
                grupo: _faixaDePreco,
                onChanged: (v) => setState(() => _faixaDePreco = v),
              ),

              _buildTituloSecao('Modalidade'),
              const SizedBox(height: AppConstants.spaceS),
              _buildSegmentedModalidade(),

              _buildTituloSecao('Disponibilidade'),
              const SizedBox(height: AppConstants.spaceS),
              _buildOpcaoRadio<Disponibilidade>(
                valor: Disponibilidade.todos,
                label: 'Todos',
                grupo: _disponibilidade,
                onChanged: (v) => setState(() => _disponibilidade = v),
              ),
              _buildOpcaoRadio<Disponibilidade>(
                valor: Disponibilidade.hoje,
                label: 'Hoje',
                grupo: _disponibilidade,
                onChanged: (v) => setState(() => _disponibilidade = v),
              ),
              _buildOpcaoRadio<Disponibilidade>(
                valor: Disponibilidade.estaSemana,
                label: 'Esta semana',
                grupo: _disponibilidade,
                onChanged: (v) => setState(() => _disponibilidade = v),
              ),
              _buildOpcaoRadio<Disponibilidade>(
                valor: Disponibilidade.fimDeSemana,
                label: 'Fim de semana',
                grupo: _disponibilidade,
                onChanged: (v) => setState(() => _disponibilidade = v),
              ),

              const SizedBox(height: AppConstants.spaceL),
              PrimaryButton(label: 'Aplicar filtros', onPressed: _aplicarFiltros),
              const SizedBox(height: AppConstants.spaceL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTituloSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.spaceM, bottom: 4),
      child: Text(
        titulo.toUpperCase(),
        style: AppTextStyles.inputLabel.copyWith(color: AppColors.accentDark),
      ),
    );
  }

  Widget _buildChipsAbordagem() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Abordagem.values.map((abordagem) {
        final selecionado = _abordagensSelecionadas.contains(abordagem);
        return FilterChip(
          label: Text(abordagem.label),
          selected: selecionado,
          onSelected: (marcado) {
            setState(() {
              marcado
                  ? _abordagensSelecionadas.add(abordagem)
                  : _abordagensSelecionadas.remove(abordagem);
            });
          },
          selectedColor: AppColors.accent.withValues(alpha: 0.15),
          checkmarkColor: AppColors.accent,
          labelStyle: TextStyle(
            color: selecionado ? AppColors.accent : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.surface,
          side: BorderSide(color: selecionado ? AppColors.accent : AppColors.border),
        );
      }).toList(),
    );
  }

  /// Item de seleção única estilo "cartão com check", usado nas seções
  /// de Faixa de preço e Disponibilidade (ver imagem 11 do design).
  Widget _buildOpcaoRadio<T>({
    required T valor,
    required String label,
    required T grupo,
    required ValueChanged<T> onChanged,
  }) {
    final selecionado = valor == grupo;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => onChanged(valor),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selecionado ? AppColors.backgroundMint : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(color: selecionado ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.body),
              if (selecionado) const Icon(Icons.check_rounded, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedModalidade() {
    return Row(
      children: [
        Expanded(child: _buildOpcaoModalidade(null, 'Todos')),
        const SizedBox(width: 8),
        Expanded(child: _buildOpcaoModalidade(Modalidade.online, 'Online')),
        const SizedBox(width: 8),
        Expanded(child: _buildOpcaoModalidade(Modalidade.presencial, 'Presencial')),
      ],
    );
  }

  Widget _buildOpcaoModalidade(Modalidade? valor, String label) {
    final selecionado = _modalidade == valor;
    return GestureDetector(
      onTap: () => setState(() => _modalidade = valor),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: selecionado ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selecionado ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
