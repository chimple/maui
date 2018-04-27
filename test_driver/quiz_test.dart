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
      commonScrolling(driver, 'quiz');
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
      for (var i = 0; i <= 1; i++) {
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder modee = find.byValueKey('question');
        var x = await driver.getText(modee);
        print(x);
        await new Future<Duration>.delayed(const Duration(milliseconds: 200));
        final SerializableFinder modeee = find.byValueKey('1');
        var x1 = await driver.getText(modeee);
        print(x1);
        await new Future<Duration>.delayed(const Duration(milliseconds: 200));
        final SerializableFinder modeeee = find.byValueKey('2');
        var x2 = await driver.getText(modeeee);
        print(x2);
        await new Future<Duration>.delayed(const Duration(milliseconds: 200));
        final SerializableFinder modeeeee = find.byValueKey('3');
        var x3 = await driver.getText(modeeeee);
        print(x3);
        await new Future<Duration>.delayed(const Duration(milliseconds: 200));
        final SerializableFinder modeeeeee = find.byValueKey('4');
        var x4 = await driver.getText(modeeeeee);
        print(x4);
        if (x == x1) {
          await driver.tap(modeee);
        } else if (x == x2) {
          await driver.tap(modeeee);
        } else if (x == x3) {
          await driver.tap(modeeeee);
        } else {
          await driver.tap(modeeeeee);
        }
        await new Future<Duration>.delayed(const Duration(seconds: 3));
      }
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
































