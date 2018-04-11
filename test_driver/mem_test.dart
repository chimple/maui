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

    test('task', () async {
      // final Completer<Null> completer = new Completer<Null>();
      final SerializableFinder user = find.byValueKey('user-Chimple');
      await driver.tap(user);
      final SerializableFinder game = find.text('Game');
      await driver.tap(game);

      final SerializableFinder memory = find.byValueKey('memory');
      await driver.tap(memory);

      final SerializableFinder upc = find.text('Upper Case Letters');
      await driver.tap(upc);

      final SerializableFinder mode = find.byValueKey('single');
      await driver.tap(mode);
      
      // for(int i=0;i<17;i++)
      // {
        SerializableFinder index=find.byValueKey(0);
        for(int j=0;j<17;j++)
        {
          SerializableFinder index1=find.byValueKey(j);
          // try
          // {
            await new Future<Duration>.delayed(const Duration(seconds: 1));
            await driver.tap(index);
            await new Future<Duration>.delayed(const Duration(seconds: 1));
            await driver.tap(index1); 
          // }
          // catch(exception, stackTrace) 
          // {

          //   break;
          //   print("Matched");
          // }
        }
  });
});
}
