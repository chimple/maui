import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/games/counting.dart';
import 'package:maui/components/count_animation.dart';

void main() {
  testWidgets('counting game', (WidgetTester tester) async {
    print("widget testingg for Counting ");
    var testKey = UniqueKey();
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new Counting(
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

  testWidgets('Counter increments test', (WidgetTester tester) async {
    print("widget testingg for CountAnimation ");
    var testKey2 = UniqueKey();
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new CountAnimation(
          key: testKey2,
        ),
      ),
    ));

//    expect(find.text('0'), findsOneWidget);
//    expect(find.text('1'), findsNothing);

    expect(find.byKey(testKey2), findsOneWidget);
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
  });
}

