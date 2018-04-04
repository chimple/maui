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

    // // tearDownAll(() async {
    // //   if (driver != null)
    // //     await driver.close();
    // // });
    test('scrolling', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true;
      final SerializableFinder menuItem = find.byValueKey('fill_in_the_blanks');
      driver.waitFor(menuItem);
      driver.tap(menuItem);
      driver.waitFor(menuItem).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(menuItem);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('Game_page');
      while (scroll) {
        await driver.scroll(gs, 0.0, -500.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the game', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder tap = find.text('Fruits');
      await driver.tap(tap);
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      // final SerializableFinder tap1=find.byValueKey('hhh');
      // await driver.getText(tap1);
      // print(tap1);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
 
  test('scroll', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true;
      final SerializableFinder menuItem = find.text('M');
      driver.waitFor(menuItem).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
      });
      while (scroll) {
        await driver.scroll(menuItem, -60.0, -200.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future; 
    }, timeout: const Timeout(const Duration(minutes: 1)));
    
 
  // test('scroll', () async {
  //     final Completer<Null> completer = new Completer<Null>();
  //     await new Future<Duration>.delayed(const Duration(seconds: 2));
  //     bool scroll = true;
  //     final SerializableFinder menuItem1 = find.text('o');
  //     driver.waitFor(menuItem1).then<Null>((Null value) async {
  //       scroll = false;
  //       await new Future<Duration>.delayed(const Duration(seconds: 1));
        
  //       //driver.tap(bk);
  //       completer.complete();
  //     });
  //     while (scroll) {
  //       await driver.scroll(menuItem1, -0.0, -200.0, const Duration(milliseconds: 500));
  //       await new Future<Null>.delayed(kWaitBetweenActions);
  //     }
  //     await completer.future; 
  //   }, timeout: const Timeout(const Duration(minutes: 1)));
    test('drag', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true;
      final SerializableFinder menuItem1 = find.text('r');
      driver.waitFor(menuItem1).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
      });
      while (scroll) {
        await driver.scroll(menuItem1, -0.0, -200.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future; 
    }, timeout: const Timeout(const Duration(minutes: 1)));
    test('drag', () async {
     
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true;
      final SerializableFinder menuItem1 = find.text('a');
      driver.waitFor(menuItem1).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
          completer.complete();
      });
      while (scroll) {
        await driver.scroll(menuItem1, -0.0, -200.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future; 
    }, timeout: const Timeout(const Duration(minutes: 1)));
    
    
  });


}
