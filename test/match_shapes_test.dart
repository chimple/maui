import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/match_the_shapes.dart';

void main() {
  testWidgets('find multiple button and drag', (WidgetTester tester) async {
    print('Im in the game');
    var gamekey = UniqueKey();

    await tester.pumpWidget(
      new MaterialApp(
        home: Material(
          child: MatchTheShapes(
            key: gamekey,
          ),
        ),
      ),
    );
    final titleFinder = find.text('1');
    expect(find.byKey(gamekey), findsOneWidget);
    expect(titleFinder, findsWidgets); //checks multiple elements of same data

    final Offset position = tester.getCenter(find.byType(MyButton).first);
    print('the $position of the button');
    await tester.pump(Duration(seconds: 4));
    await tester.drag(find.byType(MyButton).last, position);
    await tester.pump(Duration(seconds: 5));
  });
}
