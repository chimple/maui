import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/quiz/grouping_quiz.dart';

void main() {
  testWidgets('GroupingQuiz UI Test', (WidgetTester tester) async {
    Key inputKey = new UniqueKey();

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: GroupingQuiz(
          key: inputKey,
          onEnd: (Map<String, dynamic> dummydata) {},
        ),
      ),
    ));

    await tester.tap(find.byType(RaisedButton).last);
    await tester.pumpAndSettle(new Duration(milliseconds: 3000));
  });

  testWidgets('GroupingQuiz Dragging Test', (WidgetTester tester) async {
    Key inputKey = new UniqueKey();

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: GroupingQuiz(
          input: testMap,
          key: inputKey,
          onEnd: (Map<String, dynamic> dummydata) {},
        ),
      ),
    ));

    expect(find.byType(RaisedButton).first, findsWidgets);

    await tester.fling(find.byType(RaisedButton).first, Offset(80.0, 0.0), 8.0);
    await tester.pumpAndSettle(new Duration(milliseconds: 3000));
  });
}
