import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'common_function_test.dart';

const Duration kWaitBetweenActions = const Duration(milliseconds: 500);

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
      completer.complete();
      await completer.future;
    }, timeout: const Timeout(const Duration(minutes: 2)));

   var blanktext ;
    test('question', () async {
      for(int i=0;i<=1;i++)
      {
      await new Future.delayed(const Duration(milliseconds: 200), () {});
      var index = 100;
      double cordy = -297.0, cordx;
      int buttons = 0;
      bool scroll = true;
      try {
        while (true) {
          SerializableFinder i = find.byValueKey(index);
          await driver.tap(i);
          index++;
          buttons++;
        }
      } catch (exception, e) {
        print(" No of buttons:: $buttons");
      }
      List<int> cord = [];
      int space = 0;

      for (int j = 1; j <= buttons; j++) {
        await new Future<Duration>.delayed(const Duration(seconds: 1));
        String valuekey = j.toString();
        final SerializableFinder blank = find.byValueKey(valuekey);
     
        blanktext= await driver.getText(blank);
        if (blanktext == '') {
          cord.add(j);
          space++;
        }
        print('Text are:: $blanktext');
      }
      print('spaces are:: $space');
      print('Number of cordinate:: $cord');
      await new Future<Duration>.delayed(const Duration(milliseconds: 300));

      double val;
      if (buttons == 5) {
        val = 80.7;
       
        for (int i = 0; i < space; i++){
        //    for (int j = 0; j < space; j++)
        // {
             if(cord[i]==1)
           {
            for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j),-(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;
                   
             }
             //break;
           }
            if (cord[i]==2)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble()*val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;

             }//break;
           }
          if (cord[i]==3)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;

             }//break;
           }
           if (cord[i]==4)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;

             }//break;
           }
           if (cord[i]==5)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), ((j-(100+cord[i]-1))).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;     
                 
            }//break;
           }
          
        }
         await new Future<Duration>.delayed(const Duration(milliseconds: 500));   
           final SerializableFinder check=find.byValueKey('check');
            await driver.tap(check);
        // //   }
        }
      //}
      else{
          val = 67.2;
       
        for (int i = 0; i < space; i++)
        //    for (int j = 0; j < space; j++)
         {
             if(cord[i]==1)
           {
            for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble()* val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;
            
          }
          
                   
             }
             //break;
           
            if (cord[i]==2)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble()* val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;

             }//break;
           }
          if (cord[i]==3)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;

             }//break;
           }
           if (cord[i]==4)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;


             }//break;
           }
           if (cord[i]==5)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
             await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            print('text is $blanktext');
            if(blanktext!='')
             break;

             }//break;
           }
            if (cord[i]==6)
           {
               for (int j = 100; j < buttons + 100; j++)
            
            
             {
               if (j - 100+1 == cord[i]) {
                await driver.scroll( find.byValueKey(j), 0.0, cordy, const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else if (j - 100 < cord[i]) 
              {
                await driver.scroll(find.byValueKey(j), ((100+cord[i]-1)-j).toDouble() * val,cordy,const Duration(milliseconds: 300));
               await new Future<Duration>.delayed(const Duration(milliseconds: 500));
              } 
              else {
              await driver.scroll(find.byValueKey(j), -(j-(100+cord[i]-1)).toDouble() * val,  cordy, const Duration(milliseconds: 300));
                await new Future<Duration>.delayed(const Duration(milliseconds: 500));
                  }
                  var value=cord[i];
            String str=(value).toString();
            print(str);
            final SerializableFinder blank = find.byValueKey(str);
            blanktext= await driver.getText(blank);
            
            print('text is $blanktext');
            if(blanktext!='')
             break;
            //  final SerializableFinder check=find.byValueKey('check');
            // await driver.tap(check);
            

             }//break;
           }
        }
         await new Future<Duration>.delayed(const Duration(milliseconds: 500));   
           final SerializableFinder check=find.byValueKey('check');
            await driver.tap(check);
    
      
    
            //  var value=cord[i];
            //    String str=(value).toString();
            //    print(str);
            //   final SerializableFinder blank = find.byValueKey(str);
            //   blanktext= await driver.getText(blank);
            //   print('text is $blanktext');
            //  if(blanktext!='')
            //  break;
        //   }
      }
      }
    // }
    }, timeout: const Timeout(const Duration(minutes: 3)));
  });
}