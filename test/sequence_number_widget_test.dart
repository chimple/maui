import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/sequence_the_number.dart';

void main() {
  testWidgets('Sequence the number', (WidgetTester tester) async {
    print('Sequence the Numbr Game Test');
    var testKey = UniqueKey();
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new SequenceTheNumber(
          // input: testMap,
          key: testKey,
        ),
      ),
    ));
    expect(find.byKey(testKey), findsOneWidget);
    await tester.pump(Duration(seconds: 5));
    final Offset firstLocation = tester.getCenter(find.byType(MyButton).first);
    await tester.tap(find.byType(MyButton).first);
    await tester.pump(Duration(seconds: 5));
    await tester.fling(find.byType(MyButton).last, firstLocation, 8.0);
    await tester.pump(Duration(seconds: 5));
  });
}
