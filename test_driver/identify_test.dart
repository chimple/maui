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
      commonScrolling(driver, 'identify');
      await new Future<Duration>.delayed(const Duration(seconds: 4));
    });

    test('playingGame', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder option = find.text("Todo Placeholder");
      await driver.tap(option);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      final SerializableFinder element1 = find.text('square');
      await driver.scroll(
          element1, 0.0, -500.0, const Duration(milliseconds: 400));
      final SerializableFinder element2 = find.text('circle');
      await driver.scroll(
          element2, 100.0, -450.0, const Duration(milliseconds: 400));
      final SerializableFinder element3 = find.text('triangle');
      await driver.scroll(
          element3, 0.0, -350.0, const Duration(milliseconds: 400));
      final SerializableFinder element4 = find.text('hexagon');
      await driver.scroll(
          element4, 0.0, -350.0, const Duration(milliseconds: 400));

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
