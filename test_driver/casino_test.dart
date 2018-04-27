import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 250);

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

    test('task', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      final SerializableFinder casino = find.byValueKey('casino');
      bool scroll = true;
      driver.waitFor(casino).then<Null>((Null value) async {
        scroll = false;
        await driver.tap(casino);
        await new Future<Null>.delayed(kWaitBetweenActions);
        completer.complete();
      });
      while (scroll) {
        await driver.scroll(find.byValueKey('Game_page'), 0.0, -500.0,
            const Duration(milliseconds: 80));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;

      final SerializableFinder next = find.text('Fruits');
      await driver.tap(next);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      final SerializableFinder cent = find.byValueKey('fruit');
      var sd = await driver.getText(cent);
      print("fruit=$sd");

      var chars = [];

      sd.runes.forEach((int rune) {
        var character = new String.fromCharCode(rune);
        chars.add(character);
      });

      chars.removeAt(0);

      print(chars);

      scrolling(int tileNo, int noOfTimes) async {
        for (int i = 0; i < noOfTimes; i++) {
          SerializableFinder tile = find.byValueKey(tileNo);
          await driver.scroll(
              tile, 0.0, -45.0, const Duration(milliseconds: 80));
          await new Future<Null>.delayed(const Duration(milliseconds: 10));
        }
      }

      for (int j = 0; j <= chars.length - 1; j++) {
        scrolling(j, 3);
        await new Future<Null>.delayed(const Duration(seconds: 2));
      }
    });
  });
}
