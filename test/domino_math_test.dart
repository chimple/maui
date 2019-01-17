import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/domino_math.dart';

void main() {
  testWidgets('Domino math', (WidgetTester tester) async {
    Key inputKey = new UniqueKey();
    

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new Domino(
          key: inputKey,
        ),
      ),
    ));
  //  await tester.tap(find.byType(RaisedButton).last);
  });

  testWidgets('Shows the toggle button', (WidgetTester tester) async {
    bool called = false;

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new Domino(),
      ),
    ));
    expect(called, isFalse);

    await tester.tap(find.byType(IconButton));

    expect(called, isTrue);
  });
}
