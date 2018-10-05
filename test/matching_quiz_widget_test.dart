import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/quiz/match_the_following.dart';

void main() {
  testWidgets("Testing Matching Quiz", (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new MatchingGame(
        onEnd: (Map<String, dynamic> resultData) {
          print("widget testing success");
        },
        gameData: {
          "image":
              "https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg",
          "question": "what is this game about?",
          "pairs": {
            "1": "string1",
            "2": "string2",
            "3": "string3",
            "4": "string4",
            "5": "string5",
          },
          "correct": null,
          "total": null,
          "leftSelectedItems": null,
          "rightSelectedItems": null,
        },
      ),
    ));
    expect(find.byKey(new Key("question")), findsOneWidget);
    await tester.tap(find.byKey(new Key("1")));
    await tester.tap(find.byKey(new Key("string1")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(new Key("2")));
    await tester.tap(find.byKey(new Key("string2")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(new Key("3")));
    await tester.tap(find.byKey(new Key("string3")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(new Key("4")));
    await tester.tap(find.byKey(new Key("string4")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(new Key("5")));
    await tester.tap(find.byKey(new Key("string5")));
    await tester.pumpAndSettle();
  });
}
