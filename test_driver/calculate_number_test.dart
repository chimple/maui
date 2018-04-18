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
      commonScrolling(driver, 'calculate_numbers');
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    test('Scrolling to the multiple Game option', () async {
      await new Future<Duration>.delayed(const Duration(seconds: 3));
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 5));
      bool scroll = true;
      String s = 'Single digit addition without carry';
      final SerializableFinder todo = find.byValueKey(s);
      driver.waitFor(todo).then<Null>((Null value) async {
        scroll = false;
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        await driver.tap(todo);
        completer.complete();
      });
      final SerializableFinder gs = find.byValueKey('game-category-list');
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      while (scroll) {
        await driver.scroll(gs, 0.0, -500.0, const Duration(milliseconds: 500));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));

    test('playing the Game', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      for (var j = 0; j < 2; j++) {
        await new Future<Duration>.delayed(const Duration(seconds: 2));
        final SerializableFinder number = find.byValueKey('num1');
        var item = await driver.getText(number);
        print(item);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder number2 = find.byValueKey('num2');
        var item1 = await driver.getText(number2);
        print(item1);
        var x = int.parse(item);
        var x1 = int.parse(item1);
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder op1 = find.byValueKey('_operator');
        var item3 = await driver.getText(op1);
        print(item3);
        if (item3 == '+') {
          var add = x + x1;
          print(add);
          var list;
          while (add > 1) {
            list = add % 10;
            add = (add ~/ 10);
            if (add >= 1) {
              var list1;
              list1 = add % 10;
              add = (add ~/ 10);
              if (add == 0) {
                print(list1);
                print(list);
                if (list == 0) {
                  list = 11;
                  final SerializableFinder item4 = find.byValueKey(list1 - 1);
                  await driver.tap(item4);
                  await new Future<Duration>.delayed(
                      const Duration(seconds: 1));
                  final SerializableFinder item5 = find.byValueKey(list - 1);
                  await driver.tap(item5);
                  break;
                }
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
                break;
              }
              if (list1 == 0) {
                list1 = 11;
                print(add);
                print(list1);
                print(list);
                final SerializableFinder items = find.byValueKey(add - 1);
                await driver.tap(items);
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
              }
              print(add);
              print(list1);
              print(list);
              final SerializableFinder items = find.byValueKey(add - 1);
              await driver.tap(items);
              final SerializableFinder item4 = find.byValueKey(list1 - 1);
              await driver.tap(item4);
              await new Future<Duration>.delayed(const Duration(seconds: 1));
              final SerializableFinder item5 = find.byValueKey(list - 1);
              await driver.tap(item5);
            } else if (add < 10) {
              final SerializableFinder itemss = find.byValueKey(list - 1);
              await driver.tap(itemss);
            } else {
              print(add);
              print(list);
              final SerializableFinder item4 = find.byValueKey(add - 1);
              await driver.tap(item4);
              await new Future<Duration>.delayed(const Duration(seconds: 1));
              final SerializableFinder item5 = find.byValueKey(list - 1);
              await driver.tap(item5);
            }
          }
        } else if (item3 == '*') {
          var mul = x * x1;
          print(mul);
          var list;
          while (mul > 1) {
            list = mul % 10;
            mul = (mul ~/ 10);
            if (mul >= 1) {
              var list1;
              list1 = mul % 10;
              mul = (mul ~/ 10);
              if (mul == 0) {
                print(list1);
                print(list);
                if (list == 0) {
                  list = 11;
                  final SerializableFinder item4 = find.byValueKey(list1 - 1);
                  await driver.tap(item4);
                  await new Future<Duration>.delayed(
                      const Duration(seconds: 1));
                  final SerializableFinder item5 = find.byValueKey(list - 1);
                  await driver.tap(item5);
                  break;
                }
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
                break;
              }
              if (list1 == 0) {
                list1 = 11;
                print(mul);
                print(list1);
                print(list);
                final SerializableFinder items = find.byValueKey(mul - 1);
                await driver.tap(items);
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
              }
              if (mul >= 1 && list == 0) {
                list = 11;
                print(mul);
                print(list1);
                print(list);
                final SerializableFinder items = find.byValueKey(mul - 1);
                await driver.tap(items);
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
                break;
              }
              print(mul);
              print(list1);
              print(list);
              final SerializableFinder items = find.byValueKey(mul - 1);
              await driver.tap(items);
              final SerializableFinder item4 = find.byValueKey(list1 - 1);
              await driver.tap(item4);
              await new Future<Duration>.delayed(const Duration(seconds: 1));
              final SerializableFinder item5 = find.byValueKey(list - 1);
              await driver.tap(item5);
            } else if (mul < 10) {
              final SerializableFinder itemss = find.byValueKey(list - 1);
              await driver.tap(itemss);
            } else {
              print(mul);
              print(list);
              final SerializableFinder item4 = find.byValueKey(mul - 1);
              await driver.tap(item4);
              await new Future<Duration>.delayed(const Duration(seconds: 1));
              final SerializableFinder item5 = find.byValueKey(list - 1);
              await driver.tap(item5);
            }
          }
        } else if (item3 == '-') {
          var sub = x - x1;
          print(sub);
          var list;
          while (sub >= 1) {
            list = sub % 10;
            sub = (sub ~/ 10);
            if (sub >= 1) {
              var list1;
              list1 = sub % 10;
              sub = (sub ~/ 10);
              if (sub == 0) {
                print(list1);
                print(list);
                if (list == 0) {
                  list = 11;
                  final SerializableFinder item4 = find.byValueKey(list1 - 1);
                  await driver.tap(item4);
                  await new Future<Duration>.delayed(
                      const Duration(seconds: 1));
                  final SerializableFinder item5 = find.byValueKey(list - 1);
                  await driver.tap(item5);
                  break;
                }
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
                break;
              }
              if (list1 == 0) {
                list1 = 11;
                print(sub);
                print(list1);
                print(list);
                final SerializableFinder items = find.byValueKey(sub - 1);
                await driver.tap(items);
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
              }
              if (sub == 1 && list == 0) {
                list = 11;
                print(sub);
                print(list1);
                print(list);
                final SerializableFinder items = find.byValueKey(sub - 1);
                await driver.tap(items);
                final SerializableFinder item4 = find.byValueKey(list1 - 1);
                await driver.tap(item4);
                await new Future<Duration>.delayed(const Duration(seconds: 1));
                final SerializableFinder item5 = find.byValueKey(list - 1);
                await driver.tap(item5);
                break;
              }
              print(sub);
              print(list1);
              print(list);
              final SerializableFinder items = find.byValueKey(sub - 1);
              await driver.tap(items);
              final SerializableFinder item4 = find.byValueKey(list1 - 1);
              await driver.tap(item4);
              await new Future<Duration>.delayed(const Duration(seconds: 1));
              final SerializableFinder item5 = find.byValueKey(list - 1);
              await driver.tap(item5);
            } else if (sub < 10) {
              final SerializableFinder itemss = find.byValueKey(list - 1);
              await driver.tap(itemss);
            } else {
              print(sub);
              print(list);
              final SerializableFinder item4 = find.byValueKey(sub - 1);
              await driver.tap(item4);
              await new Future<Duration>.delayed(const Duration(seconds: 1));
              final SerializableFinder item5 = find.byValueKey(list - 1);
              await driver.tap(item5);
            }
          }
        }
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        final SerializableFinder item10 = find.text('✔');
        await driver.tap(item10);
      }
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 1)));
  });
}
