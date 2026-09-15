import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tarefas_domesticas/main.dart';

void main() {
  testWidgets('exibe a tela principal', (WidgetTester tester) async {
    await tester.pumpWidget(const TarefasDomesticasApp());

    expect(find.text('Tarefas Domésticas'), findsOneWidget);
    expect(find.text('Tarefas de hoje'), findsOneWidget);
    expect(find.text('Adicionar tarefa'), findsOneWidget);
  });
}
