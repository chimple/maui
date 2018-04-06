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

 });
 }

void commonSignIn(FlutterDriver driver) async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(milliseconds: 200));

      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      completer.complete();
      await completer.future;

}

void commonGoToGames(FlutterDriver driver) async {
        final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      completer.complete();
      await completer.future;
}
void commonScrolling(FlutterDriver driver,String gameName) async{
  final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 3));
      bool scroll = true;
       final SerializableFinder menuItem = find.byValueKey(gameName);
      driver.waitFor(menuItem).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      await driver.tap(menuItem);
      completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('Game_page');
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      while (scroll) {
      await driver.scroll(gs, 0.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;

}