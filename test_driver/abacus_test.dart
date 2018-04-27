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
      if (driver != null) await driver.close();
    });

    test('abacus without carry', () async {
      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);

      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      final SerializableFinder abacus = find.byValueKey('abacus');
      await driver.tap(abacus);

      final SerializableFinder type =
          find.text('Single digit addition without carry');
      await driver.tap(type);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      var numb1 = await driver.getText(find.byValueKey("100but"));
      var num1 = int.parse(numb1);
      print(num1);

      var op = await driver.getText(find.byValueKey("101but"));
      print(op);

      var numb2 = await driver.getText(find.byValueKey("102but"));
      var num2 = int.parse(numb2);
      print(num2);

      var sum;

      if (op == '+') {
        sum = num1 + num2;
      }

      print(sum);

      await new Future<Null>.delayed(const Duration(milliseconds: 10));

      for (int i = 3; i <= 3 + sum; i++) {
        await driver.tap(find.byValueKey(i));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }

      await new Future<Null>.delayed(const Duration(seconds: 3));
      await driver.scroll(find.byValueKey("102but"), 50.0, 0.0,
          const Duration(milliseconds: 250));
    });

    test('abacus with carry', () async {
      final SerializableFinder type =
          find.text('Single digit addition with carry');
      await driver.tap(type);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      var numb1 = await driver.getText(find.byValueKey("100but"));
      var num1 = int.parse(numb1);
      print("num1=$num1");

      var op = await driver.getText(find.byValueKey("101but"));
      print(op);

      var numb2 = await driver.getText(find.byValueKey("102but"));
      var num2 = int.parse(numb2);
      print("num2=$num2");

      var sum;

      if (op == '+') {
        sum = num1 + num2;
      } else if (op == '-') {
        sum = num1 - num2;
      }

      print("sum=$sum");

      var singles;
      var doubles;

      if (sum == 10) {
        singles = 0;
        doubles = 10;
      }

      if (sum > 10) {
        singles = sum % 10;
        doubles = (sum - singles);
      }

      print("singles=$singles");
      print("doubles=$doubles");

      await new Future<Null>.delayed(const Duration(milliseconds: 10));

      for (int i = 9; i < 18 + doubles; i = i + 2) {
        await driver.tap(find.byValueKey(i));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }

      await new Future<Null>.delayed(const Duration(seconds: 1));

      for (int j = 9, i = 1; i <= singles; i++, j = j + 2) {
        await driver.tap(find.byValueKey(j));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }
      await new Future<Null>.delayed(const Duration(seconds: 3));
      await driver.scroll(find.byValueKey("102but"), 50.0, 0.0, const Duration(milliseconds: 250));
    });

    test('Double digit addition without carry', () async{
            final SerializableFinder type =
          find.text('Double digit addition without carry');
      await driver.tap(type);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      var numb1 = await driver.getText(find.byValueKey("100but"));
      var num1 = int.parse(numb1);
      print("num1=$num1");

      var op = await driver.getText(find.byValueKey("101but"));
      print(op);

      var numb2 = await driver.getText(find.byValueKey("102but"));
      var num2 = int.parse(numb2);
      print("num2=$num2");

      var num1singles;
      var num1doubles;

      if (num1 > 10) {
        num1singles = num1 % 10;
        var num1doubless = (num1 - num1singles) / 10;
        num1doubles = num1doubless.round();
      } else if (num1 == 10) {
        num1singles = 0;
        num1doubles = 10;
      } else if (num1 < 10) {
        num1doubles = 0;
        num1singles = num1;
      }
      print("num1singles=$num1singles and num1doubles=$num1doubles");

      var num2singles;
      var num2doubles;

      if (num2 > 10) {
        num2singles = num2 % 10;
        var num2doubless = (num2 - num2singles) / 10;
        num2doubles = num2doubless.round();
      } else if (num2 == 10) {
        num2singles = 0;
        num2doubles = 1;
      } else if (num2 < 10) {
        num2doubles = 0;
        num2singles = num2;
      }
      print("num2singles=$num2singles and num2doubles=$num2doubles");

      for (int i = 8; i < (2 * num1doubles) + 8; i = i + 2) {
        await driver.tap(find.byValueKey(i));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }

      for (int j = 9, k = 1; k <= num1singles; k++, j = j + 2) {
        await driver.tap(find.byValueKey(j));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }

      for (int l = (2 * num1doubles) + 8;
          l < (2 * num2doubles) + (2 * num1doubles) + 8;
          l = l + 2) {
        await driver.tap(find.byValueKey(l));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }

      var sum1 = num1singles + num2singles;
      print("sum1=$sum1");

      var sum1part1;
      var sum1part2;
      var result1;
      var result2;

      if (sum1 > 10) {
        sum1part1 = sum1 % 10;
        var sum1part2s = (sum1 - sum1part1);
        sum1part2 = sum1part2s.round();
        result1 = sum1part2 - num1singles;
        result2 = num2singles - result1;

        for (int m = (num1singles * 2) + 9, n = 1;n <= result1;n++, m = m + 2) {
          await driver.tap(find.byValueKey(m));
          await new Future<Null>.delayed(const Duration(milliseconds: 250));
        }

        await new Future<Null>.delayed(const Duration(milliseconds: 250));

        for (int n = 9, p = 1; p <= result2;p++, n = n + 2) {
          await driver.tap(find.byValueKey(n));
          await new Future<Null>.delayed(const Duration(milliseconds: 250));
        }

      }
      else
      {  
        for (int m = (num1singles*2)+9, n = 1; n <= num2singles; n++, m = m + 2) {
          await driver.tap(find.byValueKey(m));
          await new Future<Null>.delayed(const Duration(milliseconds: 250));
        }
      }

      await new Future<Null>.delayed(const Duration(seconds: 2));
      await driver.scroll(find.byValueKey("102but"), 50.0, 0.0,const Duration(milliseconds: 250));      
    
    });

    test('Single digit subtraction without carry', () async {
      final Completer<Null> completer = new Completer<Null>();
  
      final SerializableFinder type =find.text('Single digit subtraction without borrow');

      bool scroll = true;
      driver.waitFor(type).then<Null>((Null value) async {
        scroll = false;
        await driver.tap(type);
        await new Future<Null>.delayed(kWaitBetweenActions);
        completer.complete();
      });
      while (scroll) {
        await driver.scroll(find.text('Double digit addition without carry'),0.0, -500.0, const Duration(milliseconds: 250));
        await new Future<Null>.delayed(kWaitBetweenActions);
      }

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);

      var numb1 = await driver.getText(find.byValueKey("100but"));
      var num1 = int.parse(numb1);
      print("num1=$num1");

      var op = await driver.getText(find.byValueKey("101but"));
      print(op);

      var numb2 = await driver.getText(find.byValueKey("102but"));
      var num2 = int.parse(numb2);
      print("num2=$num2");

      var sum;
      sum = num1 - num2;
      print("sum=$sum");

      for (int i = 3; i <=3 + num1; i++) {
        await driver.tap(find.byValueKey(i));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }
      
      await new Future<Null>.delayed(const Duration(milliseconds: 250));

      for(int j=(3+num1)-1;j>=sum+1;j--){
      await driver.tap(find.byValueKey(j));
        await new Future<Null>.delayed(const Duration(milliseconds: 250));
      }
    });

  });
}
