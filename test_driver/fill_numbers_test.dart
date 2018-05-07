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
      // commonScrolling(driver, 'fill_number');
      await new Future<Duration>.delayed(const Duration(seconds: 4));
    });

    // tearDownAll(() async {
    //   if (driver != null)
    //     await driver.close();
    // });

  
    // test('signin', () async {

    //   final Completer<Null> completer = new Completer<Null>();
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));

    //   final SerializableFinder user = find.byValueKey('user-Chimple');
    //   await driver.tap(user);

    //   completer.complete();
    //   await completer.future;
    // },timeout: const Timeout(const Duration(minutes: 1)));

    // test('Game',() async{

    //   final Completer<Null> completer = new Completer<Null>();
    //   await new Future<Duration>.delayed(const Duration(seconds: 1));

    //   final SerializableFinder game = find.text('Game');
    //   await driver.tap(game);

    //   completer.complete();
    //   await completer.future;
    // },timeout: const Timeout(const Duration(minutes: 1)));

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
        await driver.scroll(gs, 0.0, -300.0, const Duration(seconds: 1));
        await new Future<Null>.delayed(kWaitBetweenActions);
       }
        await completer.future;
       },timeout: const Timeout(const Duration(minutes: 2)));


  // test('Scrolling',() async{
  // final Completer<Null> completer = new Completer<Null>();
  //     await new Future<Duration>.delayed(const Duration(seconds: 3));
  //     bool scroll = true;
  //     final SerializableFinder gs = find.byValueKey('Game_page');
  //     await new Future<Duration>.delayed(const Duration(seconds: 2));
  //     while (scroll) {
  //     await driver.scroll(gs, 0.0, -320.0, const Duration(milliseconds: 500));
  //     await new Future<Null>.delayed(kWaitBetweenActions);
  //     }
  //     final SerializableFinder menuItem = find.byValueKey('fill_number');
  //     driver.waitFor(menuItem).then<Null>((Null value) async {
  //     scroll = false;
  //     await new Future<Duration>.delayed(const Duration(seconds: 1));
  //     await driver.tap(menuItem);
  //     completer.complete();
  //     });
  //     await completer.future;

  // },timeout: const Timeout(const Duration(minutes: 1)));

    test('Gameclick',() async{

     await new Future<Duration>.delayed(const Duration(seconds: 3));

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder abc = find.byValueKey('fill_number'); 
      await driver.tap(abc);
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));
     
    test('Opengame',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder todo = find.text('1'); 
      await driver.tap(todo);
      await new Future<Duration>.delayed(const Duration(seconds: 4));
      final SerializableFinder pp = find.byValueKey('single');
      await driver.tap(pp);
      await new Future<Duration>.delayed(const Duration(seconds: 4));
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 4)));

     test('PlayingGame', () async{
       await new Future<Duration>.delayed(const Duration(seconds: 3));
       final Completer<Null> completer = new Completer<Null>();
      //  for(int i=0;i<=15;i++){
      //    for(int j=1;j<=10;j++){
      //      for(int k=2;k<=20;k++){
      //        for(int l=3;l<=30;l++){
      //          for(int m=40;m>=4;m++){
      //  final SerializableFinder firstnum = find.byValueKey(i);
      //  await driver.tap(firstnum);
      //  await new Future<Duration>.delayed(const Duration(seconds: 2));
      //  final SerializableFinder secondnum = find.byValueKey(j);
      //  await driver.tap(secondnum);
      //  await new Future<Duration>.delayed(const Duration(seconds: 2));
      //  final SerializableFinder thirdnum = find.byValueKey(k);
      //  await driver.tap(thirdnum);
      //  await new Future<Duration>.delayed(const Duration(seconds: 2));
      //  final SerializableFinder fourthnum = find.byValueKey(l);
      //  await driver.tap(fourthnum);
      //  await new Future<Duration>.delayed(const Duration(seconds: 2));
      // //  final SerializableFinder fifthnum = find.byValueKey(m);
      // //  await driver.tap(fifthnum);
      //  await new Future<Duration>.delayed(const Duration(seconds: 2));
      // //  k++;
      // //  j++;
      //          }
      //    }
      //    }
      //    }
      //  }
        // int i;
        int index;
        // while (index==0){
      for(index = 0;index<=7;index++){
        // for(int j=20;j>=0;j--){
        //   for(int k=20;k>=0;k--){

      // await new Future<Duration>.delayed(const Duration(seconds: 2));
      // final SerializableFinder ite = find.byValueKey(k);
      
      // await driver.tap(ite);
      //   }
      //               await new Future<Duration>.delayed(const Duration(seconds: 2));
      //   final SerializableFinder it = find.byValueKey(j);

      //   await driver.tap(it);
      // }
              await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder item = find.byValueKey(index.toString()+"but");
      await driver.tap(item);
      // final SerializableFinder it = find.byValueKey(i);
      // await driver.tap(it);
      // index = 0;
      }
      index=0;
      for(int k =0;k<4;k++){
        for(int j = 0;j<=7;j++)
{
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder it = find.byValueKey(index.toString()+"but");
      index++;
      await driver.tap(it);
}      
      }
      for(int i=0;i<=7;i++){
        await new Future<Duration>.delayed(const Duration(seconds: 2));
        final SerializableFinder ite = find.byValueKey(index.toString()+"but");
        index++;
        await driver.tap(ite);
      }
      // index++;
      // i=0;
      
      // final SerializableFinder it = find.byValueKey('index');
      // await driver.tap(it);
      
       completer.complete();
       await completer.future;
     },timeout: const Timeout(const Duration(minutes: 6)));
});
}