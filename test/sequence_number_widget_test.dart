import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/sequence_the_number.dart';

void main() {
  testWidgets('Widget testing for Matching', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: SequenceTheNumber(),
    ));
  });
}
