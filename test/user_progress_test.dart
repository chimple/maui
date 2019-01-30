import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maui/quack/user_progress.dart';

void main() {
  testWidgets('user profile', (WidgetTester tester) async {
    print("just checking working or not ");

    var testKey = UniqueKey();

    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new UserProgress(
          key: testKey,
        ),
      ),
    ));

    expect(find.byKey(testKey), findsOneWidget);
  });
    testWidgets('ListView default control', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: ListView(itemExtent: 100.0),
        ),
      ),
    );
  });

  testWidgets('ListView itemExtent control test', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
          itemExtent: 200.0,
          children: List<Widget>.generate(20, (int i) {
            return Container(
              child: Text('$i'),
            );
          }),
        ),
      ),
    );

    final RenderBox box = tester.renderObject<RenderBox>(find.byType(Container).first);
    expect(box.size.height, equals(200.0));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsNothing);
    expect(find.text('4'), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0.0, -250.0));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsNothing);
    expect(find.text('6'), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0.0, 200.0));
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsNothing);
    expect(find.text('5'), findsNothing);
  });

  testWidgets('ListView large scroll jump', (WidgetTester tester) async {
    final List<int> log = <int>[];

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
          itemExtent: 200.0,
          children: List<Widget>.generate(20, (int i) {
            return Builder(
              builder: (BuildContext context) {
                log.add(i);
                return Container(
                  child: Text('$i'),
                );
              },
            );
          }),
        ),
      ),
    );

    expect(log, equals(<int>[0, 1, 2, 3, 4]));
    log.clear();

    final ScrollableState state = tester.state(find.byType(Scrollable));
    final ScrollPosition position = state.position;
    position.jumpTo(2025.0);

    expect(log, isEmpty);
    await tester.pump();

    expect(log, equals(<int>[8, 9, 10, 11, 12, 13, 14]));
    log.clear();

    position.jumpTo(975.0);

    expect(log, isEmpty);
    await tester.pump();

    expect(log, equals(<int>[7, 6, 5, 4, 3]));
    log.clear();
  });

}
