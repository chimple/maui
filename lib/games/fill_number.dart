import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import '../components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

class Fillnumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Fillnumber(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new MyFillnumberState();
}


enum Bgstatus { BgActive, BgVisible }
enum Status {Active, Visible, Disappear,Draggable,Dragtarget,First}
enum ShakeCell { Right, InActive, Dance, CurveRow }
class MyFillnumberState extends State<Fillnumber> {
  List<Offset> _points = [];
  var sum = 0,
      Ansum = 0,
      ia = 0,
      center = 0,
      center2 = 0,
      R = 1,
      L = 1,
      val = 0,
      i = 0,
      k = 0,
      ans = 0,
      num1 = 0,
      count = 0,
      Ansr = 0,
      x = 0,
      y,
      z = 3,
      flag=0,
      count1 = 0;
      int tries = 0;
      int totalgame = 7;
List<int> tempindex = [];
  List<String> num3 = [];
  final int _size = 4;
  static int size = 4;
  var T = size;
  var B = size;
  List<List<int>> _allLetters;
  List<int> _shuffledLetters = [];
  List<int> _copyVal = [];
List<int> clicks = [];
  List _Index = [];
  List _num2 = [];
  List _center = [];
  List<int> _letters;
  String ssum = '';
  String nul1='';
   List<int> clickAns=[];
  List<Status> _statuses;
  List<Bgstatus> _Bgstatus;
List<String> Ssum=[];
  bool _isLoading = true;
 List<Offset> _points1 = <Offset>[];
 List<Offset> _pointssend = <Offset>[];
 List<Widget> widgets = new List();
 List<ShakeCell> _ShakeCells = [];
  List _val2 = [];
  List<bool> _visibleflag = [];
  var c = 0;
   int lastclick;
   var code;
   var temp=0;
 double _height;
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allLetters = await fetchFillNumberData(widget.gameCategoryId, _size);

    print("shanthus data is $_allLetters");

    _allLetters.forEach((e) {
      e.forEach((v) {
        _copyVal.add(v);
      });
    });

    for (var i = 0; i < _copyVal.length; i += _size * _size) {
      _shuffledLetters
          .addAll(_copyVal.skip(i).take(_size * _size).toList(growable: true));
    }
   
    print("data in _shuffledLetters of shanthu $_shuffledLetters");
    _letters = _shuffledLetters.sublist(0, _size * _size);
     _Bgstatus = _letters.map((a) => Bgstatus.BgActive).toList(growable: false);
    // _statuses = _copyVal.map((a) => Status.Active).toList(growable: false);
    _ShakeCells=_copyVal.map((a)=>ShakeCell.InActive).toList(growable: false);
     _statuses = _copyVal.map((a) => Status.Draggable).toList(growable: false);
  _visibleflag = _copyVal.map((a) => false).toList(growable: false);
  var rng = new Random();
 code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    setState(() => _isLoading = false);
    _val2 = _shuffledLetters.sublist(0, 4);
    for (num e in _val2) {
      Ansum += e;
    }
    Ansr = Ansum;
    _val2.removeRange(0, _val2.length);

  }

  @override
  void didUpdateWidget(Fillnumber oldWidget) {
    print(" some dada is not able to get it $oldWidget.iteration");
    print("some of old widget is $widget.iteration");
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      // print("Rajesh-Data-didUpdateWidget${_allLetters}");
    }
  }

  Widget _buildItem(int index,int text, Status status,ShakeCell tile,Offset offset,bool vflag) {
     return new MyButton(
        key:new  ValueKey<int>(index),
        text: text,
         index: index,
        status: status,
          tile: tile,
           offset:offset,
           vflag: vflag,
           code: code,
           onStart: () {
               setState(() {
           print('nikkkkkkkkkkkkkk');
          temp=index;
           clickAns.add(text);
            ssum = '$text';
             _Index.add(index);
           _pointssend.add(offset);
           tempindex.add(index);
           lastclick = index;
           _visibleflag[index]=true;
           sum = sum + text;
            _statuses[index] = Status.First;
            for (var i = 0; i < _letters.length; i++) {
              if (_statuses[i] == Status.Draggable && index != i) {
                _statuses[i] = Status.Dragtarget;
              }
            }
          });
           },
            onwill: (data) {
          print('nikkkkkkkkkkkkkk  999');
          var x;
          var y;

         if(data==code&&_visibleflag[index] == false)
         {  if (lastclick == _size ||
                  lastclick == _size + _size ||
                 lastclick == _size + _size + _size) {
                x = lastclick;
              } else if (lastclick == _size - 1 ||
                  lastclick == _size + _size - 1 ||
                  lastclick == _size + _size + _size - 1) {
                y = lastclick;
                print("hello this iiis yyyy$y");
              }
           
           if((index==lastclick+1  && y!= lastclick)||(index==lastclick-1 && x!= lastclick)
         ||(index==lastclick+_size)||(index==lastclick-_size))
         {
            _statuses[temp] = Status.Dragtarget;
          setState(() {
             ssum = '$ssum' + '+' + '$text';
             sum = sum + text;
              _Index.add(index);
             lastclick = index;
             tempindex.add(index);
              _statuses[tempindex[0]] = Status.Dragtarget;
            clickAns.add(text);
            _pointssend.add(offset);
              _visibleflag[index]=true;      
                  });
            return true;
         }
         else
                return false;
         }
         else if(data == code && _visibleflag[index] == true && tempindex.length>1)
         {
           print("object....tempindex..lenth..::${tempindex.length}");
           
            if (index == tempindex[tempindex.length - 2]) {
              setState(() {
                _visibleflag[tempindex.last] = false;
                tempindex.removeLast();
                sum=sum-clickAns.last;
                clickAns.removeLast();
               
             print("object on undo part when sub doing..$sum....::$text ");
                lastclick = tempindex.last;

                  if(ssum.length>=2){
          ssum=ssum.replaceRange(ssum.length-2, ssum.length,'');
          _pointssend.removeLast();
           _Index.removeLast();
          _method(Ansr,sum);
         
           }
           else{
              ssum=ssum.replaceRange(ssum.length-1, ssum.length,'');
              ssum='';
               sum=sum-clickAns.last;
               clickAns.removeLast();
              _pointssend.removeLast();
               _center.removeRange(0, _center.length);
                _Index.removeRange(0, _Index.length);
           }
              });
              return true;
            }
            return false;
         }
         return false;
         },
            onCancel: (v, g) {
               print("values of sum is ...::..$sum");
               int flag=0;
               setState(() {
                
                    if (sum == Ansr) {
                      flag=1;
                      ssum = '$ssum' + '=$sum';
                       _pointssend.removeRange(0, _pointssend.length);
                      new Future.delayed(const Duration(milliseconds: 250), () {
                       widget.onScore(((40 - tries) ~/ totalgame));
            
                         count1=count1+1;
                        widget.onProgress((count1) /(9));
                       
                        for (var i = 0; i < _Index.length; i++) {
                          _letters[_Index[i]] = null;
                        }

                        sum = 0;
                        center = 0;
                        _center.removeRange(0, _center.length);
                        print(
                            'helo this is sum when resetting in it value $sum');
                        print(
                            'helo this is sum when resetting in it value $_letters');
                        _letters.forEach((e) {
                          if (e == null) {
                            count = count + 1;
                          }
                        });
                        //this is you want to clear the ans value in it after some time it will disappear
                        setState(() {
                          ssum = '';
                        });

                        _letters.removeWhere((value) => value == null);
                        for (var i = 0; i < count; i++) {
                          _letters.add(null);
                          // _letters.insert(0, null);
                        }
                        print("thhhiiiiiiisssss isss shanthuuuu$_val2");

                        _val2.removeRange(0, _val2.length);

                        Ansum = 0;
                        _val2 = _letters.sublist(0, z);
                        z++;
                        print("thhhiiiiiiisssss isss shanthuuuuiiiiiiii$_val2");
                        _val2.forEach((e) {
                          if (e == null) {}
                        });
                        print("my calling onennd value is $k");
                        _val2.removeWhere((value) => value == null);
                        k = _val2.length;

                        print("thid is the vlaue of length is valu$k");
                        for (num e in _val2) {
                          Ansum += e;
                        }
                        print("thhhiiiiiiisssss isss shanthuuuu$_val2");
                        Ansr = Ansum;

                        count = 0;
                        // _statuses = _copyVal
                        //     .map((a) => Status.Active)
                        //     .toList(growable: false);
                        _Bgstatus = _copyVal
                            .map((a) => Bgstatus.BgActive)
                            .toList(growable: false);
                         _statuses = _copyVal
                    .map((a) => Status.Draggable)
                    .toList(growable: false);
                _visibleflag =
                   _copyVal.map((a) => false).toList(growable: false);
                        _Index.removeRange(0, _Index.length);
                        _num2.removeRange(0, _num2.length);
                      });
                      k = _letters[4];
                      print("helllo this letters$k");
                      if (_letters[z] == null) {

                      //here setting every variable data using within the functionality making as initial set 
                        setState(() {
                        // here you want to get  another level of data in widget.onend it will call another set of datra
                          print("its reload time ");
                          k = 0;
                          // count1=count1-z;
                          Ansr = 0;
                           ssum = "";
                          sum = 0;
                          clicks.removeRange(0, clicks.length);
                          _Index.removeRange(0, _Index.length);
                          _letters.removeRange(0, _letters.length);
                          _center.removeRange(0, _center.length);
                        });
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                         
                          widget.onEnd();
                            count1=count1;
                            _pointssend.removeRange(0, _pointssend.length);
                        });
                      }

                      _val2.removeRange(0, _val2.length);
                    }
                    else{
                       setState(() {
                          tries += 5;
               clickAns=[];
               _pointssend=[];
              for (var i = 0; i < _visibleflag.length; i++)
                _visibleflag[i] == true ? _ShakeCells[i] = ShakeCell.Right : i;

                  new Future.delayed(const Duration(milliseconds: 800), () {
              setState(() {
                _ShakeCells = _copyVal
                    .map((a) => ShakeCell.InActive)
                    .toList(growable: false);
                _statuses = _copyVal
                    .map((a) => Status.Draggable)
                    .toList(growable: false);
                _visibleflag =
                    _copyVal.map((a) => false).toList(growable: false);
                      _Index.removeRange(0, _Index.length);
                    ssum='';
                    sum=0;
              });
            });
            });
                    }

                 
                                
                              });          
                                },
     );
//     return new MyButton(
//         key: new ValueKey<int>(index),
//         text: text,
//         index: index,
//         status: status,
//         bgstatus: bgstatus,
//         offset:offset,
//         onPress: () {
// print("object offsets is.....:...$offset");
// // _pointssend.add(offset);
// // if(_pointssend.length==2){
// // _points1=_pointssend;

// // print("widgets is ....$widgets");
// // }
//         //first i'm checking text should not null thats the reason checking here
//           if(text!=null) {
            
//           if (status == Status.Active) {
            
//             if (sum == 0) {
//               flag=1;
//                clicks.add(index);
//               setState(() {
//                 ssum = '$text';
//                 _pointssend.add(offset);
//                 print('qwer shanttttthuuu $ssum');
//                 _center.add(index);
//               });
//         if(_pointssend.length==2){  
//                     _points1=_pointssend;

//                 print("widgets is ....$widgets");
//                 }
//               val = index;
//               setState(() {
//                 _statuses[index] = Status.Visible;
//                 _Bgstatus[index] = Bgstatus.BgVisible;
//               });
//               print('helo this is in status os the values stored n $_statuses');

//               print(
//                   "hello this repeating one value once level is completed $ssum");
//   print("hello this is shanthhu iiiiisss $count1");
//  print("this isssssss counted ${_letters.length + _letters.length}");


//               _Index.add(index);
//               sum = sum + text;
//               if (sum == Ansr) {
//                 ssum = '$ssum' + '=$sum';
               
//                 new Future.delayed(const Duration(milliseconds: 250), () {
//                   widget.onScore(1);
                  
//                       setState(() {
//                 count1=count1+1;
//               });
//                   // widget.onProgress((count1 ) /z);
                 
//                   for (var i = 0; i < _Index.length; i++) {
//                     _letters[_Index[i]] = null;
//                   }
                         
//                   sum = 0;
//                   center = 0;
//                   _center.removeRange(0, _center.length);
//                   print('helo this is sum when resetting in it value $sum');
//                   print(
//                       'helo this is sum when resetting in it value $_letters');
//                   _letters.forEach((e) {
//                     if (e == null) {
//                       count = count + 1;
//                     }
//                   });
//                   ssum ='';
//                   _letters.removeWhere((value) => value == null);
//                   for (var i = 0; i < count; i++) {
//                     _letters.add(null);
//                   }
//                   for(var j=0; j<_letters.length;j++)
//                   {
//                      if(j==null){
//                      setState(() {
//                 _statuses[j] = Status.Disappear;});
//                      }
//                   }

                
//                   print("thhhiiiiiiisssss isss shanthuuuu$_val2");

//                   _val2.removeRange(0, _val2.length);

//                   Ansum = 0;
//                   _val2 = _letters.sublist(0, z);
//                   z++;
//                   print("thhhiiiiiiisssss isss shanthuuuuiiiiiiii$_val2");
//                   _val2.forEach((e) {
//                     if (e == null) {}
//                   });
//                   print("my calling onennd value is $k");
//                   _val2.removeWhere((value) => value == null);
//                   k = _val2.length;

//                   print("thid is the vlaue of length is valu$k");
//                   for (num e in _val2) {
//                     Ansum += e;
//                   }
//                   print("thhhiiiiiiisssss isss shanthuuuu$_val2");
//                   Ansr = Ansum;

//                   count = 0;
//                   _statuses = _copyVal
//                       .map((a) => Status.Active)
//                       .toList(growable: false);
//                   _Bgstatus = _copyVal
//                       .map((a) => Bgstatus.BgActive)
//                       .toList(growable: false);
//                   _Index.removeRange(0, _Index.length);
//                   _num2.removeRange(0, _num2.length);
//                 });
//                 k = _letters[4];
//                 print("helllo this letters$k");
//                 if (_letters[4] == null) {
//                   setState(() {
//                     k = 0;
//                     Ansr = 0;
//                     ssum = '';
//                     _letters.removeRange(0, _letters.length);
//                   });
//                   new Future.delayed(const Duration(milliseconds: 250), () {
//                     print("Rajesh Game-End");
//                     widget.onEnd();
//                   });
//                 }

//                 _val2.removeRange(0, _val2.length);
//               }
//               print('helo this is num on clicked value of sum $sum');
//               print('helo this is num on clicked index value $index');
//             }

//             //here in my game the flow is adjecent you to go .... for that i did this one 
//             _center.forEach((e) {
//               center = e;
//               //both if and else if condition checking because of..
//               //  in some situation if your going left and right should not be go ther.. 
//               // that is adjecent to that tile
          
//            if (center == _size ||
//                   center == _size + _size ||
//                   center == _size + _size + _size) {
//                 x = center;
//               } else if (center == _size - 1 ||
//                   center == _size + _size - 1 ||
//                   center == _size + _size + _size - 1) {
//                 y = center;
//                 print("hello this iiis yyyy$y");
//               }
//           //this if condtion because of you have to top, bottom , left and right for that purpose
//               if (((index == center + R && y != center) ||
//                   index == center + B ||
//                   (index == center - L && x != center) ||
//                   index == center - T)) {
//                 setState(() {
//                     clicks.add(index);
//                   ssum = '$ssum' + '+' + '$text';
//                   _statuses[index] = Status.Visible;
//                   _Bgstatus[index] = Bgstatus.BgVisible;
//                 });

//                 print('qwer nniiikkkiilll $ssum');
//                 print(
//                     'helo this is in status os the values stored n $_statuses');
//                 print(
//                     'helo this is num on clicked value of sum in if condiyion $sum');

//                 _center.add(index);
//                 _Index.add(index);
//               _pointssend.add(offset);
//               _points1=_pointssend;
// // if(_pointssend.length==2){
// // _points1=_pointssend;

// // print("widgets is ....$widgets");
// // }
//                 print('helo this is num on clicked value $text');
//                 sum = sum + text;
//                 print('helo this is sum value $sum');

//                 if (sum != 0) {
//                   print('helo this is ur value $text');
//                   setState(() {
//                     print('helo this is sum value $sum');
//                     if (sum == Ansr) {
//                       ssum = '$ssum' + '=$sum';
//                        _pointssend.removeRange(0, _pointssend.length);
//                       new Future.delayed(const Duration(milliseconds: 250), () {
//                         widget.onScore(1);
//                          count1=count1+1;
//                         widget.onProgress((count1) /(7));
                       
//                         for (var i = 0; i < _Index.length; i++) {
//                           _letters[_Index[i]] = null;
//                         }

//                         sum = 0;
//                         center = 0;
//                         _center.removeRange(0, _center.length);
//                         print(
//                             'helo this is sum when resetting in it value $sum');
//                         print(
//                             'helo this is sum when resetting in it value $_letters');
//                         _letters.forEach((e) {
//                           if (e == null) {
//                             count = count + 1;
//                           }
//                         });
//                         //this is you want to clear the ans value in it after some time it will disappear
//                         setState(() {
//                           ssum = '';
//                         });

//                         _letters.removeWhere((value) => value == null);
//                         for (var i = 0; i < count; i++) {
//                           _letters.add(null);
//                         }
//                         print("thhhiiiiiiisssss isss shanthuuuu$_val2");

//                         _val2.removeRange(0, _val2.length);

//                         Ansum = 0;
//                         _val2 = _letters.sublist(0, z);
//                         z++;
//                         print("thhhiiiiiiisssss isss shanthuuuuiiiiiiii$_val2");
//                         _val2.forEach((e) {
//                           if (e == null) {}
//                         });
//                         print("my calling onennd value is $k");
//                         _val2.removeWhere((value) => value == null);
//                         k = _val2.length;

//                         print("thid is the vlaue of length is valu$k");
//                         for (num e in _val2) {
//                           Ansum += e;
//                         }
//                         print("thhhiiiiiiisssss isss shanthuuuu$_val2");
//                         Ansr = Ansum;

//                         count = 0;
//                         _statuses = _copyVal
//                             .map((a) => Status.Active)
//                             .toList(growable: false);
//                         _Bgstatus = _copyVal
//                             .map((a) => Bgstatus.BgActive)
//                             .toList(growable: false);
//                         _Index.removeRange(0, _Index.length);
//                         _num2.removeRange(0, _num2.length);
//                       });
//                       k = _letters[4];
//                       print("helllo this letters$k");
//                       if (_letters[z] == null) {

//                       //here setting every variable data using within the functionality making as initial set 
//                         setState(() {
//                         // here you want to get  another level of data in widget.onend it will call another set of datra
//                           print("its reload time ");
//                           k = 0;
//                           // count1=count1-z;
//                           Ansr = 0;
//                            ssum = "";
//                           sum = 0;
//                           clicks.removeRange(0, clicks.length);
//                           _Index.removeRange(0, _Index.length);
//                           _letters.removeRange(0, _letters.length);
//                           _center.removeRange(0, _center.length);
//                         });
//                         new Future.delayed(const Duration(milliseconds: 250),
//                             () {
                         
//                           widget.onEnd();
//                             count1=count1;
//                             _pointssend.removeRange(0, _pointssend.length);
//                         });
//                       }

//                       _val2.removeRange(0, _val2.length);
//                     }
//                   });
//                 }
//               }
//             });
//           } else {
//             if(clicks.last == index)
//             {
//              clicks.add(index);
//             setState(() {
//                 clicks.removeLast();
//                  if (clicks.last == index) {
//                 print('kkk  ${clicks.last}  index $index');
//                 // if (cdletters[cdindex - 1] == index) {
//                   setState(() {
//                     widget.onScore(-1);
          
//                   });
//                 // }
//                 setState(() {
//             sum=sum-text;

//            // List Sum =[];
//           // Ssum=ssum.split('');
//           // for(var k=0; k<Ssum.length-2;k++){
//           //      Sum.add(Ssum[k]);
              
//           // }
//           //   print(" hello this is to cahracter is $Sum");
          
     
          
//            if(ssum.length>=2){
//           ssum=ssum.replaceRange(ssum.length-2, ssum.length,'');
//           _center.removeLast();
//            }
//            else{
//               ssum=ssum.replaceRange(ssum.length-1, ssum.length,'');
//               ssum='';
//                _center.removeRange(0, _center.length);
//                 _Index.removeRange(0, _Index.length);
//            }
//                 // print(" hello this is to cahracter is $Ssum");
//                               _statuses[index] = Status.Active;
//                 });
//                 clicks.removeLast();
//               }
//                print(" hello this is to cahracter is $sum");
//                print("hellooo thsssss is deleting string last $ssum");
//               // sum = 0;
//               // _statuses =
//               //     _copyVal.map((a) => Status.Active).toList(growable: false);
//               // _Bgstatus = _copyVal
//               //     .map((a) => Bgstatus.BgActive)
//               //     .toList(growable: false);
//               // _Index.removeRange(0, _Index.length);
//               // _num2.removeRange(0, _num2.length);
//               // _center.removeRange(0, _center.length);

//               // center = 0;
//             });
//           }
//           }
//           }
//         }
        
//         );
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");
MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
print("height of emulator is......::...${media.size.height}");
    return new LayoutBuilder(builder: (context, constraints) {
      var j = 0; 
     
    

    final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 2);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
 _height=4*maxHeight+(2*vPadding)+(2*buttonPadding);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;


       double fullwidth=(_size*state.buttonWidth)+(_size*buttonPadding);
      double removeallpaddingh=constraints.maxWidth-fullwidth;
      double startpointx=removeallpaddingh/2;
      double removeallpaddingv=constraints.maxHeight-fullwidth;
 double startpointy=removeallpaddingv/2;


double yaxis=startpointy+(state.buttonHeight)+(state.buttonHeight/2);
double y0= yaxis;
double xaxis=startpointx+(state.buttonWidth/2);
double x0=xaxis;
print(".....maxheight of button...:$maxHeight........max height is :...$vPadding");
print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
        Offset startpoint = new Offset(xaxis , yaxis);

       List<Offset> offsets1 = calculateOffsets(buttonPadding, startpoint, _size,state.buttonWidth);
 yaxis=yaxis+state.buttonWidth+buttonPadding;
 double y1= yaxis;
 double ystart=y1-y0;
 xaxis=xaxis;
 double x1=xaxis;
 double xstart=(xaxis+xaxis+(maxWidth/1.4))-(hPadding+buttonPadding);
print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
         startpoint = new Offset(xaxis, yaxis );
List<Offset> offsets2 = calculateOffsets(buttonPadding, startpoint, _size,state.buttonWidth);

 yaxis=yaxis+state.buttonWidth+buttonPadding;
 
 xaxis=xaxis;
print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
         startpoint = new Offset(xaxis, yaxis );
List<Offset> offsets3 = calculateOffsets(buttonPadding, startpoint, _size,state.buttonWidth);
 yaxis=yaxis+state.buttonWidth+buttonPadding;
 xaxis=xaxis;
print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
         startpoint = new Offset(xaxis, yaxis );
List<Offset> offsets4 = calculateOffsets(buttonPadding, startpoint, _size,state.buttonWidth);

 List<Offset> offsets=offsets1+offsets2+offsets3+offsets4;
      // AppState state = AppStateContainer.of(context).state;

      var coloris=Theme.of(context).primaryColor;
      return new Stack(
      // overflow: Overflow.visible,
        children: [
           new Container(
            child: _buildpoint(_pointssend,coloris,xstart,ystart),
          ),
          new Container(
             constraints: new BoxConstraints.expand(),
            height: media.size.height,
            child: new Column(
     
              children: <Widget>[
             
             new LimitedBox(
               maxHeight: maxHeight,
               child: new Material(
              color:Theme.of(context).accentColor,
              elevation: 4.0,
              textStyle: new TextStyle(
                  color: Colors.white, fontSize: state.buttonFontSize,letterSpacing: 8.0),
              child: new Container(
              padding: EdgeInsets.all(buttonPadding),
              child: new Center(
                child: new UnitButton(
                  text: "$Ansr",
                  primary: true,
                )
              ),
                 ))),
             
               new LimitedBox(
               maxHeight: maxHeight,
               child: new Material(
               color:Theme.of(context).accentColor,
              elevation: 4.0,
              textStyle: new TextStyle(
                color: Theme.of(context).primaryColor, fontSize: state.buttonFontSize,letterSpacing: 8.0),
              child: new Container(
              padding: EdgeInsets.all(buttonPadding),
              child: new Center(
                child: new Text("$ssum", style: new TextStyle(fontSize: 35.0)),
              ),
                 ))),


                new Padding(
                padding: EdgeInsets.symmetric(
                    vertical: vPadding, horizontal: hPadding),
                    child: new ResponsiveGridView(
              
                    rows: _size,
                    cols: _size,
                    maxAspectRatio: 1.0,
                    children: _letters
                       .map((e) =>new  Padding(
                                padding: EdgeInsets.all(buttonPadding),
                                child: _buildItem(j, e, _statuses[j],_ShakeCells[j],offsets[j],_visibleflag[j++])
                      ))
                      .toList(growable: false),
                )
                ),
              
                //  new CustomPaint(
                //         painter: new SignaturePainter(_points1),
                //             ),
              ],
            ),
          ),
          //  new CustomPaint(
                   
          //             painter: new SignaturePainter(_points1),
                      
          //                 ),
          //                 new Myapp(npoints1:_points1)
          // new Container(
          //   child: _buildpoint(_pointssend,coloris,xstart,ystart),
          // )
        ],
      );
    });
 
}

  List<Offset> calculateOffsets(double d, Offset startpoint, int size, double maxWidth) {
    // double angle = 2 * pi / amount;
    // double alpha = 0.0; 
   double centeraxis=maxWidth/4;
    double x0 = startpoint.dx;
    double y0 = startpoint.dy;
    List<Offset> offsets = new List(size);
    d=0.0;
    double y;
    double x;
    for (int i = 0; i < size; i++) {
      if(i==0){
 x=x0;
 y = y0;
              }
              else{
       x = x0+d+maxWidth;
      x0=x;
       y = y0;
              }
      offsets[i] = new Offset(x, y);
      print("object ..x..$x .....y...$y");
      // print("i:$i  alpha=${(alpha*180/pi).toStringAsFixed(1)}° ${offsets[i]}");
      // alpha += angle;

    }
    return offsets;
  }

  _buildpoint(List<Offset> points1, Color coloris, double xstart, double ystart) {
   return MyApp(
      npoints1: points1,
      coloris:coloris,
      xstart:xstart,
      ystart:ystart,
    );
  }

   _method(int ansr, int sum) {
     print("object.....sum and ans is .....$sum......::..$ansr");
if (sum == ansr) {
                      flag=1;
                      ssum = '$ssum' + '=$sum';
                       _pointssend.removeRange(0, _pointssend.length);
                      new Future.delayed(const Duration(milliseconds: 250), () {
                        widget.onScore(1);
                         count1=count1+1;
                        widget.onProgress((count1) /(7));
                       
                        for (var i = 0; i < _Index.length; i++) {
                          _letters[_Index[i]] = null;
                        }

                        sum = 0;
                        center = 0;
                        _center.removeRange(0, _center.length);
                        print(
                            'helo this is sum when resetting in it value $sum');
                        print(
                            'helo this is sum when resetting in it value $_letters');
                        _letters.forEach((e) {
                          if (e == null) {
                            count = count + 1;
                          }
                        });
                        //this is you want to clear the ans value in it after some time it will disappear
                        setState(() {
                          ssum = '';
                        });

                        _letters.removeWhere((value) => value == null);
                        for (var i = 0; i < count; i++) {
                          _letters.add(null);
                        }
                        print("thhhiiiiiiisssss isss shanthuuuu$_val2");

                        _val2.removeRange(0, _val2.length);

                        Ansum = 0;
                        _val2 = _letters.sublist(0, z);
                        z++;
                        print("thhhiiiiiiisssss isss shanthuuuuiiiiiiii$_val2");
                        _val2.forEach((e) {
                          if (e == null) {}
                        });
                        print("my calling onennd value is $k");
                        _val2.removeWhere((value) => value == null);
                        k = _val2.length;

                        print("thid is the vlaue of length is valu$k");
                        for (num e in _val2) {
                          Ansum += e;
                        }
                        print("thhhiiiiiiisssss isss shanthuuuu$_val2");
                        Ansr = Ansum;

                        count = 0;
                        // _statuses = _copyVal
                        //     .map((a) => Status.Active)
                        //     .toList(growable: false);
                        _Bgstatus = _copyVal
                            .map((a) => Bgstatus.BgActive)
                            .toList(growable: false);
                         _statuses = _copyVal
                    .map((a) => Status.Draggable)
                    .toList(growable: false);
                _visibleflag =
                   _copyVal.map((a) => false).toList(growable: false);
                        _Index.removeRange(0, _Index.length);
                        _num2.removeRange(0, _num2.length);
                      });
                      k = _letters[4];
                      print("helllo this letters$k");
                      if (_letters[z] == null) {

                      //here setting every variable data using within the functionality making as initial set 
                        setState(() {
                        // here you want to get  another level of data in widget.onend it will call another set of datra
                          print("its reload time ");
                          k = 0;
                          // count1=count1-z;
                          Ansr = 0;
                           ssum = "";
                          sum = 0;
                          clicks.removeRange(0, clicks.length);
                          _Index.removeRange(0, _Index.length);
                          _letters.removeRange(0, _letters.length);
                          _center.removeRange(0, _center.length);
                        });
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                         
                          widget.onEnd();
                            count1=count1;
                            _pointssend.removeRange(0, _pointssend.length);
                        });
                      }

                      _val2.removeRange(0, _val2.length);
                    }
  }

 
}


class MyApp extends StatefulWidget {
  final List npoints1;
  final Color coloris;
  final double xstart;
   final double ystart;
  MyApp({Key key,this.npoints1,this.coloris,this.xstart,this.ystart}):super(key:key);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  @override
  Widget build(BuildContext context) {
  MediaQueryData media = MediaQuery.of(context);
  return new LayoutBuilder(builder: (context, constraints) {
  print("emulator size in canvas .....::...${media.size.height}");
    return 
      new Container(
       
 
        child: new CustomPaint(
          // size: new Size(0.0, 0.0),
                    painter: new SignaturePainter(widget.npoints1,widget.coloris,widget.xstart,widget.ystart),
                    
                        ),
      );
      });
  }
  
}



class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points,this.coloris,this.xstart,this.ystart);
  final List<Offset> points;
  final Color coloris;
  final double xstart;
  final double ystart;
  //  var size1 =Size(683.0,345.0);
 

    void paint(Canvas canvas,Size size) {
      var flag=0;
      print("hello canvas is ....${size.height}");
    var paint = new Paint()
      ..color =  coloris
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
      // canvas.drawLine(Offset(100.0,183.0),Offset(100.0,183.0), paint);
     
      
   for (int i = 0; i < points.length-1; i++) {
     print("object....i values varying from 0th position......$i");
     print("object......points offsets is......$points");
      print("object.....points.....::${points[points.length-1]}");
   
        canvas.drawLine(points[i], points[i + 1], paint);
        

        // else{
        //   canvas.drawLine(points[i], points[i + 1], paint);
        // }

   
        print("object.. canvas x axis is...::${points[i]}");
        print("object.....points based on i...is....:${points[i+1]}");
         
    }
    }
  
 bool shouldRepaint(SignaturePainter other) => other.points != points;

  _difference(double dx, double dx2) {
    if(dx>dx2){
      return dx-dx2;
    }
    else{
      return dx2-dx;
    }
  }

}

class MyButton extends StatefulWidget {
  MyButton({Key key, 
  this.text,
   this.index,
   this.status,
   this.tile,this.offset,
    this.code,
      this.vflag,
      this.onStart,
      this.onCancel,
      this.onwill}) : super(key: key);

  final int text;
  int index;
  Status status;
   ShakeCell tile;
    final Offset offset;
 final DraggableCanceledCallback onCancel;
  final DragTargetWillAccept onwill;
  final VoidCallback onStart;
  final int code;
  final bool vflag;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  int _displayText;
  Velocity v;
  Offset o;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (!widget.text.isNaN) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -2.0, end: 2.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('99999999999999   ${widget.status}');
    return new Shake(
        animation:
            widget.tile == ShakeCell.Right ? animationWrong : animationRight,
        child: new ScaleTransition(
            scale: animationRight,
            child: widget.status == Status.Dragtarget
                ? new DragTarget(
                    onAccept: (int d) => (widget.tile == ShakeCell.Right ||
                            widget.status == Status.First)
                        ? {}
                        : widget.onCancel(v, o),
                    onWillAccept: (int data) =>
                        (widget.tile == ShakeCell.Right ||
                                widget.status == Status.First)
                            ? {}
                            : 
                            widget.onwill(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new Material(
                          elevation: widget.vflag == true ? 10.0 : 0.0,
                          color: Colors.transparent,
                          child: new UnitButton(
                            highlighted: widget.vflag == true ? true : false,
                            text: _displayText.toString(),
                            onPress: () => {},
                            unitMode: UnitMode.text,
                            showHelp: false,
                          ));
                    })
                : new Draggable(
                    onDragStarted: () =>
                        widget.tile == ShakeCell.Right ? {} : widget.onStart(),
                    onDraggableCanceled: (v, g) =>
                        widget.tile == ShakeCell.Right
                            ? {}
                            : widget.onCancel(v, g),
                    data: widget.code,
                   maxSimultaneousDrags: 1,
                    feedback: new Container(),
                    child: new UnitButton(
                      highlighted: widget.vflag == true ? true : false,
                      text: _displayText.toString(),
                      onPress: () => {},
                      unitMode: UnitMode.text,
                      showHelp: false,
                    ))));
  }
}
