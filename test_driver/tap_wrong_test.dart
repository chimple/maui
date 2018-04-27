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
       //await new Future<Duration>.delayed(const Duration(seconds: 2));
      commonScrolling(driver, 'tap_wrong');
    });

test('tap wrong', () async{
 await new Future<Duration>.delayed(const Duration(seconds: 5));
print('tap wrong click');
      
      final Completer<Null> completer = new Completer<Null>();

      final SerializableFinder words=find.text('Words'), mode = find.byValueKey('single');
      await driver.tap(words);
      await new Future<Duration>.delayed(const Duration(seconds: 2));
       await driver.tap(mode);
      await new Future<Duration>.delayed(const Duration(seconds: 6));
      
completer.complete();
});

test('tap wrong', () async{
 await new Future<Duration>.delayed(const Duration(seconds: 5));
print('tap on blocks');      
      final Completer<Null> completer = new Completer<Null>();

      final SerializableFinder block=find.byValueKey(1);
      await driver.tap(block);

      
completer.complete();
});







  });


}