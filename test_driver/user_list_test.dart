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

    test('add a user', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder addUser = find.byType('FloatingActionButton');
      driver.waitFor(addUser).then<Null>((Null value) async {
        await driver.tap(addUser);
        completer.complete();
      });
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
