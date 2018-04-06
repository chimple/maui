import 'dart:async';
import 'common_function_test.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 1000);

void main() {
  group('login', () {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      commonSignIn(driver);
      commonGoToGames(driver);
      commonScrolling(driver, 'drawing');
    });

    tearDownAll(() async {
      if (driver != null)
        await driver.close();
    });


//    test('scrolling', () async {
//      final Completer<Null> completer = new Completer<Null>();
//      await new Future<Duration>.delayed(const Duration(seconds: 2));
//      bool scroll = true;
//      final SerializableFinder menuItem = find.byValueKey('drawing');
//      driver.waitFor(menuItem).then<Null>((Null value) async {
//        scroll = false;
//        await new Future<Duration>.delayed(const Duration(seconds: 1));
//        await driver.tap(menuItem);
//        await new Future<Duration>.delayed(const Duration(seconds: 1));
//        completer.complete();
//      });
//      final SerializableFinder gs = find.byValueKey('Game_page');
//      while (scroll) {
//        await new Future<Duration>.delayed(const Duration(seconds: 1));
//        await driver.scroll(gs, 0.0, -200.0, const Duration(milliseconds: 500));
//        await new Future<Null>.delayed(kWaitBetweenActions);
//      }
//      await completer.future;
//    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the game', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 3));
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder tile = find.text('Todo Placeholder');
      await driver.tap(tile);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));


    test('undo', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      String s='Green';
      final SerializableFinder color = find.byValueKey(s);
      await driver.tap(color);
      final SerializableFinder ds = find.byValueKey('draw_screen');
      await driver.tap(ds);
      await driver.scroll(ds, -500.0, 0.0, const Duration(milliseconds: 500));
      final SerializableFinder undo=find.text('Undo');
      await driver.tap(undo);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));


    test('Drwaing', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      List<String> lst=['Green','Yellow','Blue','Red'];
      for(var j=0;j<=lst.length-1;j++) {
        String color = lst[j];
        for (var i = 0; i < 4; i++) {
          if (i == 0) {
            final SerializableFinder color1 = find.byValueKey(color);
            await driver.tap(color1);
            final SerializableFinder width1 = find.byValueKey('s');
            await driver.tap(width1);
          }
          else if (i == 1) {
            final SerializableFinder color1 = find.byValueKey(color);
            await driver.tap(color1);
            final SerializableFinder width1 = find.byValueKey('m');
            await driver.tap(width1);
          }
          else if (i == 2) {
            final SerializableFinder color1 = find.byValueKey(color);
            await driver.tap(color1);
            final SerializableFinder width1 = find.byValueKey('l');
            await driver.tap(width1);
          }
          else {
            final SerializableFinder color1 = find.byValueKey(color);
            await driver.tap(color1);
            final SerializableFinder width1 = find.byValueKey('xl');
            await driver.tap(width1);
          }
          final SerializableFinder ds = find.byValueKey('draw_screen');
          await driver.tap(ds);
          await driver.scroll(ds, -500.0, 0.0, const Duration(milliseconds: 500));
          await driver.scroll(ds, -600.0, -1270.0, const Duration(milliseconds: 500));
          await driver.scroll(ds, 500.0, 0.0, const Duration(milliseconds: 500));
          await driver.scroll(ds, 600.0, -1270.0, const Duration(milliseconds: 500));
          await new Future<Duration>.delayed(const Duration(seconds: 2));
          final SerializableFinder clr = find.text('Clear');
          await driver.tap(clr);
        }
      }
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 3)));




     test('Getimgtext', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));

      final SerializableFinder imagetext = find.byValueKey('imgtext');
      String imagename = await driver.getText(imagetext);
      print(imagename);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

  });

}


