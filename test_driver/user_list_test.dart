import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 1000);

void main() {
  group('login', () {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null)
        await driver.close();
    });

    test('signin', () async {

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));

      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('Game',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('scrolling', () async {
      final Completer<Null> completer = new Completer<Null>();
      bool scroll = true;
      final SerializableFinder menuItem = find.byValueKey('true_or_false');

      driver.waitFor(menuItem).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(menuItem);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('Game_page');
      while (scroll) {
        await driver.scroll(gs, 0.0, -300.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the game', () async {
      final Completer<Null> completer = new Completer<Null>();
      //final SerializableFinder tile = find.text('Todo ');

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}