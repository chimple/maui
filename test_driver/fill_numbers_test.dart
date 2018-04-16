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
    
    test('signin', () async {

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));

      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));

    test('Game',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));

    test('scrolling', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true;   
      final SerializableFinder menuItem = find.byValueKey('fill_number');
      driver.waitFor(menuItem).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(menuItem);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('Game_page');
       while (scroll) {
        await driver.scroll(gs, 0.0, -500.0, const Duration(seconds: 1));
        await new Future<Null>.delayed(kWaitBetweenActions);
       }
        await completer.future;
       },timeout: const Timeout(const Duration(minutes: 1)));

   test('Gameclick',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder abc = find.byValueKey('fill_number'); 
      await driver.tap(abc);
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));
     
    test('Opengame',() async{

      final Completer<Null> completer = new Completer<Null>();
      // await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder todo = find.text('2'); 
      await driver.tap(todo);
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder pp = find.byValueKey('single');
      await driver.tap(pp);
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 3)));

     test('PlayingGame', () async{
       final Completer<Null> completer = new Completer<Null>();
       for(int i=0;i<=15;i++){
         for(int j=1;j<=10;j++){
           for(int k=2;k<=20;k++){
             for(int l=3;l<=30;l++){
       final SerializableFinder firstnum = find.byValueKey(i);
       await driver.tap(firstnum);
       await new Future<Duration>.delayed(const Duration(seconds: 2));
       final SerializableFinder secondnum = find.byValueKey(j);
       await driver.tap(secondnum);
       await new Future<Duration>.delayed(const Duration(seconds: 2));
       final SerializableFinder thirdnum = find.byValueKey(k);
       await driver.tap(thirdnum);
       await new Future<Duration>.delayed(const Duration(seconds: 2));
       final SerializableFinder fourthnum = find.byValueKey(l);
       await driver.tap(fourthnum);
       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //  k++;
      //  j++;
         }
         }
         }
       }
       completer.complete();
       await completer.future;
     },timeout: const Timeout(const Duration(minutes: 3)));
});
}