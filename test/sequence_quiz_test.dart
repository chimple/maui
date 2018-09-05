import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/quiz/sequence.dart';

const Map<String, dynamic> testMap = {
  'image': 'assets/stickers/giraffe/giraffe.png',
  'question': 'Match the following according to the habitat of each animal',
  'order': ["abc", "def", "stickers/giraffe/giraffe.png", "lmn"],
  'correct': null,
  'total': null,
  'correctSequenceChoices': null,
  'choicesRightOrWrong': null
};

void main() {

  testWidgets('Allows the buttons to tap - Sequence Quiz', (WidgetTester tester) async {  
    print("Sequence game Quiz test");
    Key inputKey = new UniqueKey();

    await tester.pumpWidget(
        new MaterialApp(
          home: new Material(
            child: new SequenceQuiz(
              // input: testMap,
              key: inputKey,
            ),
          ),
        ));
    expect(find.byKey(inputKey), findsOneWidget);

    await tester.tap(find.byType(RaisedButton).first);
    await tester.pumpAndSettle();

  });
}