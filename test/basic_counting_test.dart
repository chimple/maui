import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/app.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/basic_counting.dart';

void main() {
  testWidgets('basic running of basic_counting', (WidgetTester tester) async {
    Key inputKey = new UniqueKey();

    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new BasicCounting(
          key: inputKey,
        ),
      ),
    ));

    expect(find.byKey(inputKey),findsOneWidget);
    // await tester.tap(find.byWidget(MyButton(),skipOffstage: true));
    await tester.pumpAndSettle(new Duration(milliseconds: 2000));
  });
}