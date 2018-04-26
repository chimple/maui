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
    commonScrolling(driver, 'connect_the_dots');
    });
    test('Gameclick',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder abc = find.byValueKey('connect_the_dots'); 
      await driver.tap(abc);
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));

    test('Todo',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder todo = find.text('0-9'); 
      await driver.tap(todo);
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));


      test('choice',() async{
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 5));
      final SerializableFinder pp = find.byValueKey('single');
      await driver.tap(pp);      
      completer.complete();
      await completer.future;
     },timeout: const Timeout(const Duration(minutes: 1)));

      test('script',() async{
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 5));
      final SerializableFinder qq = find.byValueKey('but');
      await driver.tap(qq);      
      completer.complete();
      await completer.future;
     },timeout: const Timeout(const Duration(minutes: 1)));
       






   });
}