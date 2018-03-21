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

      final SerializableFinder memory = find.byValueKey('memory');
      await driver.scroll(memory, 0.0, -600.0, const Duration(milliseconds: 300));
      final SerializableFinder true_or_false = find.byValueKey('true_or_false');
      await driver.tap(true_or_false);
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
