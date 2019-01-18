import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/basic_addition.dart';

void main() {
  testWidgets('basic addtion', (WidgetTester tester) async {
    print("just checking working or not ");

    var testKey = UniqueKey();

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new BasicAddition(
          // input: testMap,
          key: testKey,
        ),
      ),
    ));
//    await tester.pump();
    expect(find.byKey(testKey), findsOneWidget);
    await tester.pump(Duration(seconds: 5));
//     await tester.fling(find.byType(FlatButton).first, Offset(100.0, 40.0), 8.0);
    final Offset firstLocation = tester.getCenter(find.byType(MyButton).first);
    await tester.tap(find.byType(MyButton).first);
    await tester.pump(Duration(seconds: 5));
    // await tester.tap(find.byType(MyButton).first);
    // expect(find.byType(MyButton).first, findsOneWidget);
    // await tester.pumpAndSettle(Duration(seconds: 5));
    await tester.fling(find.byType(MyButton).last, firstLocation, 8.0);
    await tester.pump(Duration(seconds: 5));
  });
}
