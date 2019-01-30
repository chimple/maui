import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:maui/games/basic_addition.dart';
import 'package:maui/games/basic_counting.dart';

void main() {
  testWidgets('basic running of basic_counting', (WidgetTester tester) async {
    var inputKey =  UniqueKey();

    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new BasicCounting(
          key: inputKey,
        ),
      ),
    ));

    expect(find.byKey(inputKey),findsOneWidget);
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byType(MyButton).first);
    await tester.pump(Duration(seconds: 5));    
  });
}