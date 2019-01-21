import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/matching.dart';
import 'package:maui/games/single_game.dart';

void main() {
  Key inputKey = new UniqueKey();
  testWidgets("Testing Matching Quiz", (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new Matching(
        key: inputKey,
        gameConfig: GameConfig(gameCategoryId: 1),
      ),
    ));
    expect(find.byKey(inputKey), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
