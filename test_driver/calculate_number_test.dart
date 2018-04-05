import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
 
const Duration kWaitBetweenActions = const Duration(milliseconds: 1000);

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

test('scrolling', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true;
      final SerializableFinder menuItem = find.byValueKey('calculate_numbers');
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

test('playing the Single digit addition without carry', () async {
      final Completer<Null> completer = new Completer<Null>();
      String s='Triple digit addition without carry';
      final SerializableFinder todo=find.text(s);
      driver.tap(todo);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
for(var j=0;j<2;j++)
{     
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder number=find.byValueKey('num1');
      var item=await driver.getText(number);
      print(item);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder number2=find.byValueKey('num2');
      var item1=await driver.getText(number2);
      print(item1);
      var x = int.parse(item);
      var x1 = int.parse(item1);
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder op1=find.byValueKey('_operator');
      var item3=await driver.getText(op1);
      print(item3);
    if(item3 == '+')
      {
      var add = x+x1;
      print(add);
      var list;
      var lst;
    while(add>1)
      {
         list=add%10;
         lst = new List(list);
         lst[0]=list;
         add=(add~/10);
    if(add>1)
        { 
         var list1;
         list1=add%10;
         lst[1]=list1;
         add=(add~/10);
         if(add==0)
         {
         final SerializableFinder item4 =find.text(lst[1]);
         await driver.tap(item4);
         await new Future<Duration>.delayed(const Duration(seconds: 1));
         final SerializableFinder item5 =find.text(lst[0]);
         await driver.tap(item5);
         break;
         }
         lst[2]=add;
         print(lst[2]);
         print(lst[1]);
         print(lst[0]);
         final SerializableFinder items =find.text(lst[2]);
         await driver.tap(items);
         final SerializableFinder item4 =find.text(lst[1]);
         await driver.tap(item4);
         await new Future<Duration>.delayed(const Duration(seconds: 1));
         final SerializableFinder item5 =find.text(lst[0]);
         await driver.tap(item5);
         }
    else if(add<10)
         {

           final SerializableFinder itemss=find.text(lst[0]);
           await driver.tap(itemss);
         }
    else{
           lst[1]=add;
           print(lst[1]);
           print(lst[0]);
          final SerializableFinder item4 =find.text(lst[1]);
          await driver.tap(item4);
          await new Future<Duration>.delayed(const Duration(seconds: 1));
          final SerializableFinder item5 =find.text(lst[0]);
          await driver.tap(item5);      
         }
      }
      }
    else if(item3 == '*')
      {
        var mul=x*x1;
        print(mul);
        var list;
        var lst;
    while(mul>1)
      {
        list=mul%10;
        lst = new List(list);
        lst[0]=list;
        mul=(mul~/10);
    if(mul>1)
        { 
        var list1;
        list1=mul%10;
        lst[1]=list1;
        mul=(mul~/10);
        lst[2]=mul;
        print(lst[2]);
        print(lst[1]);
        print(lst[0]);
        final SerializableFinder items =find.text(lst[2]);
        await driver.tap(items);
        final SerializableFinder item4 =find.text(lst[1]);
        await driver.tap(item4);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder item5 =find.text(lst[0]);
        await driver.tap(item5);
         }
    else if(mul<10)
        {

        final SerializableFinder itemss=find.text(lst[0]);
        await driver.tap(itemss);
        }
    else
      {
        lst[1]=mul;
        print(lst[1]);
        print(lst[0]);
        final SerializableFinder item4 =find.text(lst[1]);
        await driver.tap(item4);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder item5 =find.text(lst[0]);
        await driver.tap(item5);      
         }
      }
      }
    else
      {
        var sub=x-x1;
        print(sub);
        var list;
        var lst;
    while(sub>1)
      {
        list=sub%10;
        lst = new List(list);
        lst[0]=list;
        sub=(sub~/10);
    if(sub>1)
      { 
        var list1;
        list1=sub%10;
        lst[1]=list1;
        sub=(sub~/10);
        lst[2]=sub;
        print(lst[2]);
        print(lst[1]);
        print(lst[0]);
        final SerializableFinder items =find.text(lst[2]);
        await driver.tap(items);
        final SerializableFinder item4 =find.text(lst[1]);
        await driver.tap(item4);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder item5 =find.text(lst[0]);
        await driver.tap(item5);
        }
    else if(sub<10)
        {

        final SerializableFinder itemss=find.text(lst[0]);
        await driver.tap(itemss);
        }
    else{
        lst[1]=sub;
        print(lst[1]);
        print(lst[0]);
        final SerializableFinder item4 =find.text(lst[1]);
        await driver.tap(item4);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder item5 =find.text(lst[0]);
        await driver.tap(item5);      
         }
      }
      }
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder item10 = find.text('✔');
        await driver.tap(item10);
}        
        // final SerializableFinder tool=find.byTooltip('Back');
        // await driver.tap(tool);
        completer.complete();
        await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}