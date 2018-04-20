import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'common_function_test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 400);

void main() {
group('login', () 
{
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // await new Future<Duration>.delayed(const Duration(seconds: 2));
      commonSignIn(driver);
      commonGoToGames(driver);
     /// await new Future<Duration>.delayed(const Duration(seconds: 2));
      commonScrolling(driver, 'tap_home');
       await new Future<Duration>.delayed(const Duration(seconds: 3));
});
test('click on single', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder tap = find.text('0-9');
      await driver.tap(tap);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 3)));
    test('playing the game', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 3));
       final Completer<Null> completer = new Completer<Null>();
      //  //await new Future<Duration>.delayed(const Duration(seconds: 3));
      // final SerializableFinder tap = find.byValueKey('question');
      //  await new Future<Duration>.delayed(const Duration(seconds: 3));
      // var text=await driver.getText(tap);
      // print('questiuon is $text');
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder tap1 = find.byValueKey('question');
      var text = await driver.getText(tap1);
      var value=text.toString();
      print(text);
      print(value);
     // await driver.tap(tap1);
      // var text1=await driver.getText(tap1);
      // print('answer is $text1');
  

      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
