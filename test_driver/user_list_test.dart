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

    // tearDownAll(() async {
    //   if (driver != null)
    //     await driver.close();
    // });

    test('click on Game', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder addUser = find.byValueKey('user-Chimple');
        await driver.tap(addUser);
        final SerializableFinder game = find.text('Game');
        await driver.tap(game);
        completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
