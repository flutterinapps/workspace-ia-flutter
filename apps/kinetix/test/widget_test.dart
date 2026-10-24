import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetix/main.dart';

void main() {
  testWidgets('Kinetix App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const KinetixApp());
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
