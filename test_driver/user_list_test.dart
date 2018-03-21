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

//    tearDownAll(() async {
//      if (driver != null)
//        await driver.close();
//    });

    test('task', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);
      final SerializableFinder game = find.text('Game');
      await driver.tap(game);
      final SerializableFinder story = find.text('Story');
      await driver.tap(story);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
