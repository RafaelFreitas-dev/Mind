import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

/// -----------------------------------------------------------------------
/// TermsOfUseScreen
/// -----------------------------------------------------------------------
/// Termos de Uso do Mind. O texto vem de `assets/termos_de_uso.json`, que é
/// o MESMO arquivo usado no site (`frontend/src/data/termos_de_uso.json`).
/// Para mudar o texto, edite o JSON e copie a versão nova para os dois
/// lugares.
///
/// Só leitura (ex.: item "Termos de Uso" no perfil):
///   Navigator.pushNamed(context, AppRoutes.terms)
///
/// No cadastro, pedindo o aceite — a tela devolve `true` quando a pessoa
/// toca em "Li e aceito os Termos de Uso":
///   final aceitou = await Navigator.of(context).push<bool>(
///     MaterialPageRoute(builder: (_) => const TermsOfUseScreen(askForAcceptance: true)),
///   );
/// -----------------------------------------------------------------------
class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key, this.askForAcceptance = false});

  /// Mostra o botão "Li e aceito os Termos de Uso" no rodapé da tela.
  final bool askForAcceptance;

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  static const String _caminhoTermos = 'assets/termos_de_uso.json';

  late final Future<_Termos> _termos = _carregarTermos();
  List<GlobalKey> _chavesSecoes = const [];

  Future<_Termos> _carregarTermos() async {
    final conteudo = await rootBundle.loadString(_caminhoTermos);
    final termos = _Termos.fromJson(jsonDecode(conteudo) as Map<String, dynamic>);
    _chavesSecoes = List.generate(termos.secoes.length, (_) => GlobalKey());
    return termos;
  }

  void _irParaSecao(int indice) {
    final contextoSecao = _chavesSecoes[indice].currentContext;
    if (contextoSecao != null) {
      Scrollable.ensureVisible(
        contextoSecao,
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Termos de Uso')),
      body: FutureBuilder<_Termos>(
        future: _termos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _ErroAoCarregar(erro: snapshot.error);
          }
          final termos = snapshot.data;
          if (termos == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _ConteudoTermos(
            termos: termos,
            chavesSecoes: _chavesSecoes,
            onSecaoSelecionada: _irParaSecao,
          );
        },
      ),
      bottomNavigationBar: widget.askForAcceptance
          ? FutureBuilder<_Termos>(
              future: _termos,
              builder: (context, snapshot) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.screenPadding,
                    AppConstants.spaceS,
                    AppConstants.screenPadding,
                    AppConstants.spaceM,
                  ),
                  child: PrimaryButton(
                    label: 'Li e aceito os Termos de Uso',
                    backgroundColor: AppColors.primary,
                    // Só libera o aceite depois que o texto carregou.
                    onPressed: snapshot.hasData ? () => Navigator.of(context).pop(true) : null,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _ConteudoTermos extends StatelessWidget {
  final _Termos termos;
  final List<GlobalKey> chavesSecoes;
  final ValueChanged<int> onSecaoSelecionada;

  const _ConteudoTermos({
    required this.termos,
    required this.chavesSecoes,
    required this.onSecaoSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView (e não ListView) para que todas as seções sejam
    // montadas de uma vez: é isso que permite rolar até qualquer uma delas
    // a partir do sumário.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.screenPadding,
        AppConstants.spaceS,
        AppConstants.screenPadding,
        AppConstants.spaceXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Versão ${termos.versao} · Última atualização: ${termos.atualizadoEm}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppConstants.spaceM),
          for (final paragrafo in termos.introducao) _Paragrafo(termos.comContato(paragrafo)),
          const SizedBox(height: AppConstants.spaceS),
          _AvisoEmergencia(titulo: termos.emergencia.titulo, texto: termos.emergencia.texto),
          const SizedBox(height: AppConstants.spaceL),
          _Sumario(secoes: termos.secoes, onSecaoSelecionada: onSecaoSelecionada),
          const SizedBox(height: AppConstants.spaceL),
          for (var i = 0; i < termos.secoes.length; i++)
            _SecaoTermos(
              key: chavesSecoes[i],
              numero: i + 1,
              secao: termos.secoes[i],
              comContato: termos.comContato,
            ),
        ],
      ),
    );
  }
}

class _Paragrafo extends StatelessWidget {
  final String texto;

  const _Paragrafo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spaceS + 4),
      child: Text(texto, style: AppTextStyles.body.copyWith(height: 1.55)),
    );
  }
}

/// Cartão de destaque com os contatos de emergência (CVV 188 / SAMU 192).
class _AvisoEmergencia extends StatelessWidget {
  final String titulo;
  final String texto;

  const _AvisoEmergencia({required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.phone_in_talk_rounded, color: AppColors.accentDark, size: 22),
          const SizedBox(width: AppConstants.spaceS + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTextStyles.heading3),
                const SizedBox(height: AppConstants.spaceXS),
                Text(texto, style: AppTextStyles.body.copyWith(height: 1.55)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista das seções; tocar em uma rola a tela até ela.
class _Sumario extends StatelessWidget {
  final List<_Secao> secoes;
  final ValueChanged<int> onSecaoSelecionada;

  const _Sumario({required this.secoes, required this.onSecaoSelecionada});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceS),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.spaceM,
              AppConstants.spaceS,
              AppConstants.spaceM,
              AppConstants.spaceXS,
            ),
            child: Text('SUMÁRIO', style: AppTextStyles.inputLabel),
          ),
          for (var i = 0; i < secoes.length; i++)
            InkWell(
              onTap: () => onSecaoSelecionada(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spaceM,
                  vertical: AppConstants.spaceS + 2,
                ),
                child: Text('${i + 1}. ${secoes[i].titulo}', style: AppTextStyles.body),
              ),
            ),
        ],
      ),
    );
  }
}

class _SecaoTermos extends StatelessWidget {
  final int numero;
  final _Secao secao;
  final String Function(String texto) comContato;

  const _SecaoTermos({
    super.key,
    required this.numero,
    required this.secao,
    required this.comContato,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$numero. ',
                  style: AppTextStyles.heading2.copyWith(color: AppColors.accent),
                ),
                TextSpan(
                  text: secao.titulo,
                  style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const Divider(height: AppConstants.spaceL),
          for (final bloco in secao.blocos) _BlocoTermos(bloco: bloco, comContato: comContato),
        ],
      ),
    );
  }
}

class _BlocoTermos extends StatelessWidget {
  final _Bloco bloco;
  final String Function(String texto) comContato;

  const _BlocoTermos({required this.bloco, required this.comContato});

  @override
  Widget build(BuildContext context) {
    final estiloTexto = AppTextStyles.body.copyWith(height: 1.55);

    switch (bloco.tipo) {
      case 'paragrafo':
        return _Paragrafo(comContato(bloco.texto));
      case 'subtitulo':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceS),
          child: Text(comContato(bloco.texto), style: AppTextStyles.heading3),
        );
      case 'lista':
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spaceS + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in bloco.itens)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: estiloTexto.copyWith(color: AppColors.accent)),
                      Expanded(child: Text(comContato(item), style: estiloTexto)),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 'aviso':
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppConstants.spaceS + 4),
          padding: const EdgeInsets.all(AppConstants.spaceS + 4),
          decoration: BoxDecoration(
            color: AppColors.backgroundMint,
            borderRadius: BorderRadius.circular(AppConstants.radiusS),
          ),
          child: Text(comContato(bloco.texto), style: estiloTexto),
        );
      default:
        return const SizedBox.shrink(); // tipos de bloco desconhecidos são ignorados
    }
  }
}

class _ErroAoCarregar extends StatelessWidget {
  final Object? erro;

  const _ErroAoCarregar({required this.erro});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Não foi possível carregar os Termos de Uso.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppConstants.spaceS),
            // Detalhe para quem está desenvolvendo: o motivo mais comum é o
            // JSON não estar declarado em `flutter: assets:` no pubspec.yaml.
            Text('$erro', textAlign: TextAlign.center, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// Modelos do JSON (mesma estrutura lida pela página do site)
// -------------------------------------------------------------------------

class _Termos {
  final String versao;
  final String atualizadoEm;
  final String contatoEmail;
  final List<String> introducao;
  final _Emergencia emergencia;
  final List<_Secao> secoes;

  _Termos({
    required this.versao,
    required this.atualizadoEm,
    required this.contatoEmail,
    required this.introducao,
    required this.emergencia,
    required this.secoes,
  });

  factory _Termos.fromJson(Map<String, dynamic> json) => _Termos(
        versao: json['versao'] as String,
        atualizadoEm: json['atualizadoEm'] as String,
        contatoEmail: json['contatoEmail'] as String,
        introducao: (json['introducao'] as List).cast<String>(),
        emergencia: _Emergencia.fromJson(json['emergencia'] as Map<String, dynamic>),
        secoes: (json['secoes'] as List)
            .map((secao) => _Secao.fromJson(secao as Map<String, dynamic>))
            .toList(),
      );

  /// Troca o marcador {contato} do JSON pelo e-mail de contato.
  String comContato(String texto) => texto.replaceAll('{contato}', contatoEmail);
}

class _Emergencia {
  final String titulo;
  final String texto;

  _Emergencia({required this.titulo, required this.texto});

  factory _Emergencia.fromJson(Map<String, dynamic> json) =>
      _Emergencia(titulo: json['titulo'] as String, texto: json['texto'] as String);
}

class _Secao {
  final String titulo;
  final List<_Bloco> blocos;

  _Secao({required this.titulo, required this.blocos});

  factory _Secao.fromJson(Map<String, dynamic> json) => _Secao(
        titulo: json['titulo'] as String,
        blocos: (json['blocos'] as List)
            .map((bloco) => _Bloco.fromJson(bloco as Map<String, dynamic>))
            .toList(),
      );
}

class _Bloco {
  final String tipo;
  final String texto;
  final List<String> itens;

  _Bloco({required this.tipo, this.texto = '', this.itens = const []});

  factory _Bloco.fromJson(Map<String, dynamic> json) => _Bloco(
        tipo: json['tipo'] as String? ?? '',
        texto: json['texto'] as String? ?? '',
        itens: (json['itens'] as List?)?.cast<String>() ?? const [],
      );
}
