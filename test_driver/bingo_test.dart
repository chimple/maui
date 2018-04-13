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

    test('signin', () async {

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));

      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('Game',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('scrolling', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true;
      await new Future<Null>.delayed(kWaitBetweenActions);
      final SerializableFinder menuItem = find.byValueKey('bingo');

      driver.waitFor(menuItem).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(menuItem);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('Game_page');
      await new Future<Null>.delayed(kWaitBetweenActions);
      while (scroll) {
        await driver.scroll(gs, 0.0, -300.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the game', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final Completer<Null> completer = new Completer<Null>();
     final SerializableFinder todo = find.text('Upper Case Letters');
     await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode=find.byValueKey('single'); 

      await driver.tap(todo);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      await driver.tap(mode);

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('Bingo', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder t= find.byValueKey('question');
       String p= await driver.getText(t);
       print(p);
      // while(true){
      for(int i=1;i<=9;i++)
      {
        await driver.tap(find.byValueKey(i-1));
        await new Future<Null>.delayed(kWaitBetweenActions);
        }
       completer.complete();
      await completer.future;
      // }
    }, timeout: const Timeout(const Duration(minutes: 4)));    
  });
}
