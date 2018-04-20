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
      commonScrolling(driver, 'orderit');
    });

    // tearDownAll(() async {
    //   if (driver != null)
    //     await driver.close();
    // });

    test('playing the game in single mode', () async {
      
      await new Future<Duration>.delayed(const Duration(seconds: 3));
      
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder tile = find.text('Upper Case Letters'), mode = find.byValueKey('single');

      //final SerializableFinder monday=find.text('Monday');
      await driver.tap(tile);
      await new Future<Duration>.delayed(const Duration(seconds: 3));
      await driver.tap(mode);
      List<int> list = [0,1,2,3,4,5,6];
      var i, j;
      for (i = 0; i <=list.length-1; i++) {
        bool scroll=true;
        final SerializableFinder menuItem1 =
        find.byValueKey('orderableDataWidget${list[i]}');
        await driver.waitFor(menuItem1).then<Null>((Null value) async {
          scroll=false;
        // await driver.tap(menuItem1);
        await new Future<Duration>.delayed(const Duration(seconds: 2));
       
      });
      while (scroll) {
        await driver.scroll(
            menuItem1, 0.0, -200.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(const Duration(seconds: 2));
    }
      
      }
    //    var swap;

    //   if (list[i] > list[i + 1])
    //   {
         
    //   }
    //     
    //   bool scroll = true;

    //   
    //   await new Future<Duration>.delayed(const Duration(seconds: 3));
    //   //  for(int i=0;i<=6;i++){

    //   // int j=10;
    //   print('click on monday');
    //   final SerializableFinder menuItem1 =
    //       find.byValueKey('orderableDataWidget${0}');
    //   await driver.waitFor(menuItem1).then<Null>((Null value) async {
    //     scroll = false;
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     // await driver.tap(menuItem1);
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     completer.complete();
    //   });
    //   while (scroll) {
    //     await driver.scroll(
    //         menuItem1, 0.0, -200.0, const Duration(milliseconds: 500));
    //     await new Future<Null>.delayed(const Duration(seconds: 2));
    //   }
    //   // } j=j+10;
    //   // }
    //   await completer.future;
    // }, timeout: const Timeout(const Duration(minutes: 1)));

    // test(' single mode', () async {
    //   final Completer<Null> completer = new Completer<Null>();
    //   final SerializableFinder tuesday = find.text('Tuesday');
    //   bool scroll = true;
    //   //  final SerializableFinder  weeks=find.;
    //   //  var lst= await driver.getText(weeks);

    //   await new Future<Duration>.delayed(const Duration(seconds: 3));
    //   //  for(int i=0;i<7;i++){
    //   print('for loop');
    //   final SerializableFinder menuItem1 =
    //       find.byValueKey('orderableDataWidget${1}');
    //   driver.waitFor(menuItem1).then<Null>((Null value) async {
    //     scroll = false;
    //     await new Future<Duration>.delayed(const Duration(seconds: 1));
    //     await driver.tap(tuesday);
    //     await new Future<Duration>.delayed(const Duration(seconds: 1));
    //     completer.complete();
    //   });
    //   while (scroll) {
    //     await driver.scroll(
    //         menuItem1, 0.0, -200.0, const Duration(milliseconds: 500));
    //     await new Future<Null>.delayed(kWaitBetweenActions);
    //   }
    //   //  }
     completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
