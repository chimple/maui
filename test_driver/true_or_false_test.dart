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
      commonScrolling(driver, 'true_or_false');



    });
    void playingGame() async {
      final Completer<Null> completer = new Completer<Null>();
      String s = 'Upper Case Letter to Lower Case Letter';
      final SerializableFinder option = find.text(s);
      await driver.tap(option);
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      final SerializableFinder back = find.byTooltip('Back');
      await driver.tap(back);
      completer.complete();
      await completer.future;
    }

  });
}
