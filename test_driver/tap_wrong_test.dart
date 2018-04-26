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
      commonScrolling(driver, 'tap_wrong');
    });

test('tap wrong', () async{
 await new Future<Duration>.delayed(const Duration(seconds: 3));
      
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder words=find.text('Words');
      await driver.tap(words);
completer.complete();
});









  });


}