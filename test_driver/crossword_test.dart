
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
    commonScrolling(driver, 'crossword');
    });

  
   test('Gameclick',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder abc = find.byValueKey('crossword'); 
      await driver.tap(abc);
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));

    test('Todo',() async{

      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder todo = find.text('Todo Placeholder'); 
      await driver.tap(todo);
      completer.complete();
      await completer.future;
    },timeout: const Timeout(const Duration(minutes: 1)));


      test('choice',() async{
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      final SerializableFinder pp = find.byValueKey('single');
      await driver.tap(pp);      
      completer.complete();
      await completer.future;
     },timeout: const Timeout(const Duration(minutes: 1)));
     
 
     
 test('TC fo block 1 A2', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem1 = find.byValueKey('B10');
      await driver.tap(menuItem1);
      driver.waitFor(menuItem1).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds:1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem1, 00.0, -395.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds: 1));       
      await new Future<Null>.delayed(kWaitBetweenActions);      
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));


 
    test('TC fo block 2 A2', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem2 = find.byValueKey('B11');
      await driver.tap(menuItem2);
      driver.waitFor(menuItem2).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });   
      while (scroll) {    
      await driver.scroll(menuItem2, -60.0, -395.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds:1));
      await new Future<Null>.delayed(kWaitBetweenActions); 
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));  

      
    test('TC fo block 3 A2', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem3 = find.byValueKey('B12');
      await driver.tap(menuItem3);
      driver.waitFor(menuItem3).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem3, -172.0, -395.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));
       

    test('TC fo block 4 A2', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem4 = find.byValueKey('B13');
      await driver.tap(menuItem4);
      driver.waitFor(menuItem4).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));   
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem4, -246.0, -395.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds:1));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));
       

       
    test('TC fo block 5 A2', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B14');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, -300.0, -395.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 
 
   test('TC fo block 1 A4', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem1 = find.byValueKey('B10');
      await driver.tap(menuItem1);
      driver.waitFor(menuItem1).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds:1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem1, 64.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds: 1));       
      await new Future<Null>.delayed(kWaitBetweenActions);      
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));


 
    test('TC fo block 2 A4', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem2 = find.byValueKey('B11');
      await driver.tap(menuItem2);
      driver.waitFor(menuItem2).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });   
      while (scroll) {    
      await driver.scroll(menuItem2, 0.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds:1));
      await new Future<Null>.delayed(kWaitBetweenActions); 
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));  

      
    test('TC fo block 3 A4', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem3 = find.byValueKey('B12');
      await driver.tap(menuItem3);
      driver.waitFor(menuItem3).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem3, -60.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));
       

    test('TC fo block 4 A4', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 2));
      bool scroll = true; 
      final SerializableFinder menuItem4 = find.byValueKey('B13');
      await driver.tap(menuItem4);
      driver.waitFor(menuItem4).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));   
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem4, -150.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Duration>.delayed(const Duration(seconds:1));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));
       

       
    test('TC fo block 5 A4', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B14');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, -230.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 
 
    test('TC fo block 1 A5', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B10');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 150.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

    test('TC fo block 2 A5', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B11');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 55.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

     test('TC fo block 3 A5', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B12');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 0.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

     test('TC fo block 4 A5', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B13');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, -55.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));  

    test('TC fo block 5 A5', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B14');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, -150.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 


  test('TC fo block 1 A6', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B10');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 250.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

    test('TC fo block 2 A6', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B11');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 180.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

     test('TC fo block 3 A6', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B12');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 100.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

     test('TC fo block 4 A6', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B13');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 0.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));  

    test('TC fo block 5 A6', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B14');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, -55.0, -300.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));  
    


    test('TC fo block 1 A8', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B10');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 360.0, -250.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

    test('TC fo block 2 A8', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B11');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 260.0, -250.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

     test('TC fo block 3 A8', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B12');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 160.0, -250.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1))); 

     test('TC fo block 4 A8', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B13');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 60.0, -250.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));  

    test('TC fo block 5 A8', () async {
      final Completer<Null> completer = new Completer<Null>();
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      bool scroll = true; 
      final SerializableFinder menuItem5 = find.byValueKey('B14');
      await driver.tap(menuItem5);
      driver.waitFor(menuItem5).then<Null>((Null value) async {
      scroll = false;
      await new Future<Duration>.delayed(const Duration(seconds: 1));
      completer.complete();
      });
      while (scroll) {    
      await driver.scroll(menuItem5, 0.0, -250.0, const Duration(milliseconds: 500));
      await new Future<Null>.delayed(kWaitBetweenActions);
      }
      await completer.future;
      },timeout: const Timeout(const Duration(minutes: 1)));    
      });
}