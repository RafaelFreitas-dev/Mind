// Teste de fumaça: garante que o app sobe e mostra a tela de splash
// enquanto a sessão salva está sendo verificada.
//
// Como o app depende de rede e de shared_preferences, aqui não fazemos
// login de verdade — apenas verificamos a primeira renderização.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meu_app/main.dart';

void main() {
  testWidgets('App inicia na tela de carregamento', (WidgetTester tester) async {
    await tester.pumpWidget(const MindApp());

    // O nome do app aparece no splash e o indicador de progresso está visível.
    expect(find.text('Mind'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
