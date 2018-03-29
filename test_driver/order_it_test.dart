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

    test('1signin', () async {

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));
      final SerializableFinder user = find.byValueKey('user-Chimple'),  game = find.text('Game');
      await driver.tap(user);
      //wait time to click on game
      await new Future<Null>.delayed(kWaitBetweenActions);
      await driver.tap(game);
      completer.complete();
      //waits till task is completed
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    
    test('2scrolling', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder menuItem = find.byValueKey('orderit');
      //bool scroll = true;
      //scroll and click on game
      // driver.waitFor(menuItem).then<Null>((Null value) async {
      //  // scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 3));
        await driver.tap(menuItem);
        completer.complete();
      // });
      final SerializableFinder gs = find.text('Game_page'); //game page is the page key
      //scroll till game is found
      // while (scroll) {
      //   await driver.scroll(gs, 0.0, -500.0, const Duration(milliseconds: 500));
      //   await new Future<Null>.delayed(kWaitBetweenActions);
      // }
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the game in single mode', () async {
      final Completer<Null> completer = new Completer<Null>();
      bool scroll = true;
      final SerializableFinder tile = find.text('Upper Case Letters'), mode=find.byValueKey('single'), monday=find.text('Monday');
      await driver.tap(tile);
       await new Future<Duration>.delayed(const Duration(seconds: 2));
      await driver.tap(mode);
      final SerializableFinder menuItem1 = find.byValueKey('orderableDataWidget${3}');
      driver.waitFor( menuItem1).then<Null>((Null value) async{
        scroll=false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(monday);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
        });
       while (scroll) {
        await driver.scroll(monday, 0.0, -570.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }     
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
    });

}