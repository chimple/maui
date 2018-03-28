import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 200);

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
      await new Future<Duration>.delayed(const Duration(milliseconds: 300));

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
      final SerializableFinder menuItem = find.byValueKey('tables');
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
      final SerializableFinder tile = find.text('1 Tables');
      await driver.tap(tile);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

  test('playing the game', () async {
    final Completer<Null> completer = new Completer<Null>();
    final SerializableFinder question=find.byValueKey('question');
    await new Future<Null>.delayed(kWaitBetweenActions);
    for(int i=1;i<=10;i++) {
      var text = await driver.getText(question);
      print(text);
      var array = text.split('X');
      print(array);
      var num1 = int.parse(array[0]);
      var num2 = int.parse(array[1]);
      var result = (num1 * num2);
      print(result);
      var mul;
      var mul1;
       if (result > 10) {
          mul = result % 10;
          print(mul);
         // List list=new List();
          //list[0]=mul;
          mul1 = (result ~/ 10);
          print(mul1);
          //list[1]=mul1;
          await new Future<Null>.delayed(kWaitBetweenActions);
          String result2 = mul1.toString();
          print(result2);
          String result3 = mul.toString();
          print(result3);
          final SerializableFinder tap2 = find.text(result2);
          await new Future<Null>.delayed(kWaitBetweenActions);
          await driver.tap(tap2);
          final SerializableFinder tap1 = find.text(result3);
          await new Future<Null>.delayed(kWaitBetweenActions);
          await driver.tap(tap1);

          final SerializableFinder sub = find.text('submit');
          await new Future<Null>.delayed(kWaitBetweenActions);
          await driver.tap(sub);
        }
      else {
        String result1 = result.toString();
        final SerializableFinder tap = find.text(result1);
        await new Future<Null>.delayed(kWaitBetweenActions);
        var text1 = await driver.getText(tap);
        print(text1);
        await driver.tap(tap);
        final SerializableFinder sub = find.text('submit');
        await new Future<Null>.delayed(kWaitBetweenActions);
        await driver.tap(sub);
      }
    }

    completer.complete();
    await completer.future;
  }, timeout: const Timeout(const Duration(minutes: 1)));
});


}