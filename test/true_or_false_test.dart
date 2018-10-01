import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/app.dart';
import 'package:maui/quiz/true_or_false.dart';

void main() {
  testWidgets('true or false', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MauiApp());

    await tester.element(find.byType(TrueOrFalse).first);
    await tester.pump();
  });
}
