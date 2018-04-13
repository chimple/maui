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
      commonScrolling(driver, 'fill_in_the_blanks');
    });

    // // tearDownAll(() async {
    // //   if (driver != null)
    // //     await driver.close();
    // // });

    test('playing the game', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder tap = find.text('Fruits');
      await driver.tap(tap);
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      // final SerializableFinder tap1=find.byValueKey('hhh');
      // await driver.getText(tap1);
      // print(tap1);
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 2)));

    // test('scroll', () async {
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     final Completer<Null> completer = new Completer<Null>();
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     bool scroll = true;
    //     final SerializableFinder menuItem = find.byValueKey(100);
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     driver.waitFor(menuItem).then<Null>((Null value) async {
    //       scroll = false;
    //       await new Future<Duration>.delayed(const Duration(seconds: 1));
    //       completer.complete();
    //     });
    //     while (scroll) {
    //       await new Future<Duration>.delayed(const Duration(seconds: 2));
    //       await driver.scroll(menuItem, -00.0, -294.7, const Duration(milliseconds: 500));
    //       await new Future<Null>.delayed(kWaitBetweenActions);
    //     }
    //     await completer.future;
    //   }, timeout: const Timeout(const Duration(minutes: 1)));
    //    test('scroll', () async {
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     final Completer<Null> completer = new Completer<Null>();
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     bool scroll = true;
    //     final SerializableFinder menuItem = find.byValueKey(101);
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     driver.waitFor(menuItem).then<Null>((Null value) async {
    //       scroll = false;
    //       await new Future<Duration>.delayed(const Duration(seconds: 1));
    //       completer.complete();
    //     });
    //     while (scroll) {
    //       await new Future<Duration>.delayed(const Duration(seconds: 2));
    //       await driver.scroll(menuItem, -00.0, -294.7, const Duration(milliseconds: 500));
    //       await new Future<Null>.delayed(kWaitBetweenActions);
    //     }
    //     await completer.future;
    //   }, timeout: const Timeout(const Duration(minutes: 1)));
    //    test('scroll', () async {
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     final Completer<Null> completer = new Completer<Null>();
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     bool scroll = true;
    //     final SerializableFinder menuItem = find.byValueKey(102);
    //     //var value=await driver.getText(menuItem);
    //    // print(value);
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     driver.waitFor(menuItem).then<Null>((Null value) async {
    //       scroll = false;
    //       await new Future<Duration>.delayed(const Duration(seconds: 1));
    //       completer.complete();
    //     });
    //     while (scroll) {
    //       await new Future<Duration>.delayed(const Duration(seconds: 2));
    //       await driver.scroll(menuItem, -00.0, -294.7, const Duration(milliseconds: 500));
    //       await new Future<Null>.delayed(kWaitBetweenActions);
    //     }
    //     await completer.future;
    //   }, timeout: const Timeout(const Duration(minutes: 1)));
    //  test('text', () async {
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //    final Completer<Null> completer = new Completer<Null>();
    //   // final SerializableFinder tap = find.text('Fruits');
    //   // await driver.tap(tap);
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //   final SerializableFinder text1 = find.byValueKey('A7');
    //   var value1=await driver.getText(text1);
    //   print('=====text: $value1 ========');
    //   final SerializableFinder text2 = find.byValueKey('A8');
    //   var value2=await driver.getText(text2);
    //   print('=====text: $value2 ========');
    //   final SerializableFinder text3 = find.byValueKey('A9');
    //   var value3=await driver.getText(text3);
    //   print('=====text: $value3 ========');
    //   final SerializableFinder text4 = find.byValueKey('A10');
    //   var value4=await driver.getText(text4);
    //   print('=====text: $value4 ========');
    //   final SerializableFinder text5 = find.byValueKey('A11');
    //   var value5=await driver.getText(text5);
    //   print('=====text: $value5 ========');
    //   final SerializableFinder text6 = find.byValueKey('A12');
    //   var value6=await driver.getText(text6);
    //   print('=====text: $value6 ========');
    //   // final SerializableFinder tap1=find.byValueKey('hhh');
    //   // await driver.getText(tap1);
    //   // print(tap1);
    //   completer.complete();
    //   await completer.future;
    // }, timeout: const Timeout(const Duration(minutes: 1)));
    test('question', () async {
      

      await new Future.delayed(const Duration(milliseconds: 2000),(){});
       var index=100;
      double cordy=-297.0,cordx=0.0;
    int c=0;
bool scroll=true;
try{
      while(true){
        SerializableFinder i=find.byValueKey(index);
        await driver.tap(i);
          index++;
          c++;
      }
}
catch(exception,e){
  print(" No of buttons:: $c");
}
List<int> cord=[] ;
int space=0;

for(int j=1;j<=c;j++)
{
await new Future<Duration>.delayed(const Duration(seconds: 2));
String valuekey=j.toString();
final SerializableFinder blank=find.byValueKey(valuekey);
var blanktext= await driver.getText(blank);
if (blanktext=='')
{
cord.add(j);
space++;
}
print('value is $blanktext');
}
for (int i=0;i<space;i++)
{
  for(int j=100;j<c+100;j++)
  {
    while(true)
    {
      await driver.scroll(find.byValueKey(j), cordx*cord[i].toDouble(), cordy,const Duration(seconds: 1),);
      cordx=cordx-65.9;
    }
  }
}
      // for (int i = 1; i <= 6; i++) {
      //   await new Future<Duration>.delayed(const Duration(seconds: 2));
      //   final Completer<Null> completer = new Completer<Null>();
      //   // final SerializableFinder tap = find.text('Fruits');
      //   // await driver.tap(tap);
      //   String valuekey = i.toString();
      //   print('value key is: $valuekey');
      //   await new Future<Duration>.delayed(const Duration(seconds: 2));
      //   final SerializableFinder text1 = find.byValueKey(valuekey);
      //   var value1 = await driver.getText(text1);
      //   print('=====text: $value1 ========');
      //   if (i== 1)
      //    {
      //     if (value1 == '') {
      //       // for(int j=0;j<=5;j++)
      //       // {
      //       final Completer<Null> completer = new Completer<Null>();
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       bool scroll = true;
      //       final SerializableFinder menuItem1 = find.byValueKey(100);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));

      //         //driver.tap(bk);
      //         //completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem1, -0.0, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       // await completer.future;
      //       // final Completer<Null> completer = new Completer<Null>();
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem2 = find.byValueKey(101);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));

      //         //driver.tap(bk);
      //         //completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem2, -65.9, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem3 = find.byValueKey(102);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));

      //         //driver.tap(bk);
      //         // completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem3, -131.8, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem4 = find.byValueKey(103);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));

      //         //driver.tap(bk);
      //         //completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem4, -220.7, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem5 = find.byValueKey(104);
      //       driver.waitFor(menuItem5).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //        // completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem5, -266.7, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem6 = find.byValueKey(105);
      //       driver.waitFor(menuItem6).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //         completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem6, -332.6, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       await completer.future;
      //     }
      //   }
      
      //   else
      //   {
      //     print('move to value 2');

      //   }
      //   if(i==2)
      //   {
      //     if(value1=='')
      //     {
      //       final Completer<Null> completer = new Completer<Null>();
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       bool scroll = true;
      //       final SerializableFinder menuItem1 = find.byValueKey(100);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem1, 65.9, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //     /// 1st scroll
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem2 = find.byValueKey(101);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //         });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem2, 0.0, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //     //2nd scroll
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem3 = find.byValueKey(102);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //         });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem3, -65.9, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       //3rd scroll
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem4 = find.byValueKey(103);
      //       driver.waitFor(menuItem1).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));           
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem4, -131.9, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       //4th scroll
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem5 = find.byValueKey(104);
      //       driver.waitFor(menuItem5).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //         completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem5, -200.7, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       //5th scroll
      //       await new Future<Duration>.delayed(const Duration(seconds: 2));
      //       scroll = true;
      //       final SerializableFinder menuItem6 = find.byValueKey(105);
      //       driver.waitFor(menuItem6).then<Null>((Null value) async {
      //         scroll = false;
      //         await new Future<Duration>.delayed(const Duration(seconds: 1));
      //         completer.complete();
      //       });
      //       while (scroll) {
      //         await driver.scroll(
      //             menuItem6, 266.7, -294.7, const Duration(milliseconds: 500));
      //         await new Future<Null>.delayed(kWaitBetweenActions);
      //       }
      //       await completer.future;
      //     }
             
      //   }
      //   //}
      //   else 
      //   {
      //     print("next trail");
      //     // final SerializableFinder text2 = find.byValueKey('2');
      //     // var value2=await driver.getText(text2);
      //     // print('=====text: $value2 ========');
      //     // final SerializableFinder text3 = find.byValueKey('3');
      //     // var value3=await driver.getText(text3);
      //     // print('=====text: $value3 ========');
      //     // final SerializableFinder text4 = find.byValueKey('4');
      //     // var value4=await driver.getText(text4);
      //     // print('=====text: $value4 ========');
      //     // final SerializableFinder text5 = find.byValueKey('5');
      //     // var value5=await driver.getText(text5);
      //     // print('=====text: $value5 ========');
      //     // final SerializableFinder text6 = find.byValueKey('6');
      //     // var value6=await driver.getText(text6);
      //     // print('=====text: $value6 ========');
      //     // final SerializableFinder tap1=find.byValueKey('hhh');
      //     // await driver.getText(tap1);
      //     // print(tap1);
      //     completer.complete();
      //   }
      //   await completer.future;
      // }
    }, timeout: const Timeout(const Duration(minutes: 1)));

    // test('scroll', () async {
    //     final Completer<Null> completer = new Completer<Null>();
    //     await new Future<Duration>.delayed(const Duration(seconds: 2));
    //     bool scroll = true;
    //     final SerializableFinder menuItem1 = find.text('o');
    //     driver.waitFor(menuItem1).then<Null>((Null value) async {
    //       scroll = false;
    //       await new Future<Duration>.delayed(const Duration(seconds: 1));

    //       //driver.tap(bk);
    //       completer.complete();
    //     });
    //     while (scroll) {
    //       await driver.scroll(menuItem1, -0.0, -200.0, const Duration(milliseconds: 500));
    //       await new Future<Null>.delayed(kWaitBetweenActions);
    //     }
    //     await completer.future;
    //   }, timeout: const Timeout(const Duration(minutes: 1)));
    //   // test('drag', () async {
    //   final Completer<Null> completer = new Completer<Null>();
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //   bool scroll = true;
    //   final SerializableFinder menuItem1 = find.text('r');
    //   driver.waitFor(menuItem1).then<Null>((Null value) async {
    //     scroll = false;
    //     await new Future<Duration>.delayed(const Duration(seconds: 1));
    //     completer.complete();
    //   });
    //   while (scroll) {
    //     await driver.scroll(menuItem1, -0.0, -200.0, const Duration(milliseconds: 500));
    //     await new Future<Null>.delayed(kWaitBetweenActions);
    //   }
    //   await completer.future;
    // }, timeout: const Timeout(const Duration(minutes: 1)));
    // test('drag', () async {

    //   final Completer<Null> completer = new Completer<Null>();
    //   await new Future<Duration>.delayed(const Duration(seconds: 2));
    //   bool scroll = true;
    //   final SerializableFinder menuItem1 = find.text('l');
    //   driver.waitFor(menuItem1).then<Null>((Null value) async {
    //     scroll = false;
    //     await new Future<Duration>.delayed(const Duration(seconds: 1));
    //       completer.complete();
    //   });
    //   while (scroll) {
    //     await driver.scroll(menuItem1, -0.0, -200.0, const Duration(milliseconds: 500));
    //     await new Future<Null>.delayed(kWaitBetweenActions);
    //   }
    //   await completer.future;
    // }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
