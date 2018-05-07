import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'common_function_test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 1000);

void main() {
  group('login', () {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      commonSignIn(driver);
      commonGoToGames(driver);
      commonScrolling(driver, 'clue_game');
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    test('Scrolling to the multiple Game option', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 3));
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 5));
      bool scroll = true;
      String s = 'Todo Placeholder';
      final SerializableFinder todo = find.byValueKey(s);
      driver.waitFor(todo).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(todo);
        completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('game-category-list');
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      while (scroll) {
        await driver.scroll(gs, 0.0, -500.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the Game', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode1 = find.byValueKey('21');
      var x = await driver.getText(mode1);
      print(x);
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));
      final SerializableFinder mode2 = find.byValueKey('22');
      var x1 = await driver.getText(mode2);
      print(x1);
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));
      final SerializableFinder mode3 = find.byValueKey('23');
      var x2 = await driver.getText(mode3);
      print(x2);
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));
      final SerializableFinder mode4 = find.byValueKey('24');
      var x3 = await driver.getText(mode4);
      print(x3);
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));
      final SerializableFinder mode5 = find.byValueKey('1');
      var x4 = await driver.getText(mode5);
      print(x4);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
