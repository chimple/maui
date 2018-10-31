import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/components/topic_button.dart';
import 'package:maui/quiz/sequence.dart';

import '../lib/screens/category_list_view.dart';


void main() {

  testWidgets('category list view', (WidgetTester tester) async {  
    print("Sequence game Quiz test");
    final testKey = Key('Category_page');

    await tester.pumpWidget(
        new MaterialApp(
          home: new Material(
            child: new CategoryListView(
              // input: testMap,
              key: testKey,
            ),
          ),
        ));
    expect(find.byKey(testKey), findsOneWidget);

//    await tester.tap(find.byType(TopicButton).first);
//    await tester.pumpAndSettle();

  });
}