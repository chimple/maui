import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/quiz/card_list.dart';
import 'package:maui/db/entity/quiz.dart';

const Map<String, dynamic> testMap = {
  'question': 'Select the animals from small to big',
  'image': 'assets/topic/jungle-animals-colorful-art.jpg',
  'answer': ['tiger cub', 'pig', 'deer', 'buffalo'],
  'choices': null,
  'correct': null
};

void main() {
  testWidgets('Allows the buttons to tap - Quiz', (WidgetTester tester) async {
    print("Quiz test");
    Key inputKey = new UniqueKey();

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new CardList(
          input: testMap,
          key: inputKey,
          optionsType: QuizType.many,
        ),
      ),
    ));
    expect(find.byKey(inputKey), findsOneWidget);

    await tester.tap(find.byType(RaisedButton).first);
    await tester.pumpAndSettle();
  });
}
