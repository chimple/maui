import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 250);


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

    test('task', () async {
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      final SerializableFinder abacus = find.byValueKey('abacus');
      await driver.tap(abacus);

      final SerializableFinder type= find.text('Single digit addition without carry');
      await driver.tap(type);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      void moving(int beadnum) async {
        SerializableFinder bead1=find.byValueKey(beadnum);
        driver.scroll(bead1, 0.0, 300.0, const Duration(milliseconds: 80));
        await new Future<Duration>.delayed(const Duration(seconds: 2));
      }

      var firstnumbertext =await driver.getText(find.byValueKey(100));
      var firstnumber=int.parse(firstnumbertext);
      print(firstnumber);

      var secnumbertext =await driver.getText(find.byValueKey(101));
      var sectnumber=int.parse(secnumbertext);
      print(sectnumber);

      var thirdnumbertext =await driver.getText(find.byValueKey(102));
      var thirdnumber=int.parse(thirdnumbertext);
      print(thirdnumber);

      var sum;

      if(secnumbertext=='+')
      {
        sum=firstnumber+thirdnumber;
        print(sum);
      }

      for(int i=3;i<13;i++)
      {
        moving(i);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
      }

    });

  });
}
