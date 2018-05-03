import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'common_function_test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 200);

void main() {
group('login', () 
{
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      commonSignIn(driver);
      commonGoToGames(driver);
      commonScrolling(driver, 'tables');
      await new Future<Duration>.delayed(const Duration(seconds: 2));
});

// tearDownAll(() async 
// {
//      if (driver != null)
//        await driver.close();
// });

test('scrolling in game category list', () async 
{
    await new Future<Duration>.delayed(const Duration(seconds: 3));
    final Completer<Null> completer = new Completer<Null>();
    await new Future<Duration>.delayed(const Duration(seconds: 3));
    bool scroll = true;
    //await new Future<Duration>.delayed(const Duration(seconds: 3));
    final SerializableFinder tile = find.text('1 Tables');
    driver.waitFor(tile).then<Null>((Null value) async 
    {
    scroll = false;
     await new Future<Duration>.delayed(const Duration(seconds: 1));
     await driver.tap(tile);
     //await new Future<Duration>.delayed(const Duration(seconds: 2));
     completer.complete();
    });
    //await new Future<Duration>.delayed(const Duration(seconds: 1));
    final SerializableFinder cg = find.byValueKey('game-category-list');
    await new Future<Duration>.delayed(const Duration(seconds: 2));
    while (scroll) 
    {
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.scroll(cg, 0.0, -300.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
    }
      await completer.future;
     // await new Future<Duration>.delayed(const Duration(seconds: 3));
}, timeout: const Timeout(const Duration(minutes: 1)));


test('click on single', () async 
{
    await new Future<Duration>.delayed(const Duration(seconds: 3));
    final Completer<Null> completer = new Completer<Null>();
    //final SerializableFinder tile = find.text('1 Tables');
    //await driver.tap(tile);
    final SerializableFinder mode = find.byValueKey('single');
    await driver.tap(mode);
    completer.complete();
    await completer.future;
}, timeout: const Timeout(const Duration(minutes: 1)));

test('playing the game', () async 
{
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder question=find.byValueKey('question');
      await new Future<Null>.delayed(kWaitBetweenActions);
      for(int i=0;i<10;i++) {
      var text = await driver.getText(question);
      print(text);
      var array = text.split('*');
      print(array);
      var num1 = int.parse(array[0]);
      var num2 = int.parse(array[1]);
     // var num3= int.parse(array[5]);
      var result = (num1 * num2);
      print(result);
     
      if(result>=10)
      {    //for two digits
          var mul;
          var mul1;
          mul = result % 10;
          print(mul);
          mul1 = (result ~/ 10);
          print(mul1);
          var z=11;
      if(mul1==0)// if zero comes
      {
          final SerializableFinder zero=find.byValueKey((z-1));
          await new Future<Null>.delayed(kWaitBetweenActions);
          await driver.tap(zero);
          print("Zero");
          
      }
      else
      {
          final SerializableFinder twoDigits1=find.byValueKey((mul1-1));
          await new Future<Null>.delayed(kWaitBetweenActions);
          await driver.tap(twoDigits1);
          print('TWO DIGITS');
      }    
      if(mul==0)// if zero comes
      {
        final SerializableFinder zero=find.byValueKey((z-1));
        await new Future<Null>.delayed(kWaitBetweenActions);
        await driver.tap(zero);
        print("Zero");
         
        
      }
      else
      {
        final SerializableFinder twoDigits2=find.byValueKey((mul-1));
        await new Future<Null>.delayed(kWaitBetweenActions);
        await driver.tap(twoDigits2);
        print('TWO DIGITS'); 
      } 
       await new Future<Null>.delayed(kWaitBetweenActions);
      final SerializableFinder tapp1= find.text('✔');
      await driver.tap(tapp1);   
          
      }
      else// single digits
      {
          final SerializableFinder tap =find.byValueKey((result-1));
           await new Future<Null>.delayed(kWaitBetweenActions);
          await driver.tap(tap);
          print('SINGLE DIGITS');
          final SerializableFinder tapp1= find.text('✔');
          await driver.tap(tapp1);
   
       } 
       await new Future<Duration>.delayed(const Duration(milliseconds: 500));

      
    }
    completer.complete();
    await completer.future;
}, timeout: const Timeout(const Duration(minutes: 1)));
});


}