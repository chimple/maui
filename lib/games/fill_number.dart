import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';

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

enum Status { Active, Visible, Disappear }
enum Bgstatus { BgActive, BgVisible }

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
      count1 = 0;

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
  List<Status> _statuses;
  List<Bgstatus> _Bgstatus;
List<String> Ssum=[];
  bool _isLoading = true;

  List _val2 = [];
  var c = 0;

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
    _Bgstatus = _copyVal.map((a) => Bgstatus.BgActive).toList(growable: false);
    // _statuses = _copyVal.map((a) => Status.Active).toList(growable: false);

    print("data in _shuffledLetters of shanthu $_shuffledLetters");
    _letters = _shuffledLetters.sublist(0, _size * _size);
     _statuses = _letters.map((a) => Status.Active).toList(growable: false);

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

  Widget _buildItem(int index, int text, Status status, Bgstatus bgstatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        index: index,
        status: status,
        bgstatus: bgstatus,
        onPress: () {

        //first i'm checking text should not null thats the reason checking here
          if(text!=null) {
            
          if (status == Status.Active) {
            
            if (sum == 0) {
               clicks.add(index);
              setState(() {
                ssum = '$text';
       
                print('qwer shanttttthuuu $ssum');
                _center.add(index);
              });

              val = index;
              setState(() {
                _statuses[index] = Status.Visible;
                _Bgstatus[index] = Bgstatus.BgVisible;
              });
              print('helo this is in status os the values stored n $_statuses');

              print(
                  "hello this repeating one value once level is completed $ssum");
  print("hello this is shanthhu iiiiisss $count1");
 print("this isssssss counted ${_letters.length + _letters.length}");


              _Index.add(index);
              sum = sum + text;
              if (sum == Ansr) {
                ssum = '$ssum' + '=$sum';
               
                new Future.delayed(const Duration(milliseconds: 250), () {
                  widget.onScore(1);
                  
                      setState(() {
                count1=count1+1;
              });
                  // widget.onProgress((count1 ) /z);
                 
                  for (var i = 0; i < _Index.length; i++) {
                    _letters[_Index[i]] = null;
                  }
                         
                  sum = 0;
                  center = 0;
                  _center.removeRange(0, _center.length);
                  print('helo this is sum when resetting in it value $sum');
                  print(
                      'helo this is sum when resetting in it value $_letters');
                  _letters.forEach((e) {
                    if (e == null) {
                      count = count + 1;
                    }
                  });
                  ssum ='';
                  _letters.removeWhere((value) => value == null);
                  for (var i = 0; i < count; i++) {
                    _letters.add(null);
                  }
                  for(var j=0; j<_letters.length;j++)
                  {
                     if(j==null){
                     setState(() {
                _statuses[j] = Status.Disappear;});
                     }
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
                  _statuses = _copyVal
                      .map((a) => Status.Active)
                      .toList(growable: false);
                  _Bgstatus = _copyVal
                      .map((a) => Bgstatus.BgActive)
                      .toList(growable: false);
                  _Index.removeRange(0, _Index.length);
                  _num2.removeRange(0, _num2.length);
                });
                k = _letters[4];
                print("helllo this letters$k");
                if (_letters[4] == null) {
                  setState(() {
                    k = 0;
                    Ansr = 0;
                    ssum = '';
                    _letters.removeRange(0, _letters.length);
                  });
                  new Future.delayed(const Duration(milliseconds: 250), () {
                    print("Rajesh Game-End");
                    widget.onEnd();
                  });
                }

                _val2.removeRange(0, _val2.length);
              }
              print('helo this is num on clicked value of sum $sum');
              print('helo this is num on clicked index value $index');
            }

            //here in my game the flow is adjecent you to go .... for that i did this one 
            _center.forEach((e) {
              center = e;
              //both if and else if condition checking because of..
              //  in some situation if your going left and right should not be go ther.. 
              // that is adjecent to that tile
          
           if (center == _size ||
                  center == _size + _size ||
                  center == _size + _size + _size) {
                x = center;
              } else if (center == _size - 1 ||
                  center == _size + _size - 1 ||
                  center == _size + _size + _size - 1) {
                y = center;
                print("hello this iiis yyyy$y");
              }
          //this if condtion because of you have to top, bottom , left and right for that purpose
              if (((index == center + R && y != center) ||
                  index == center + B ||
                  (index == center - L && x != center) ||
                  index == center - T)) {
                setState(() {
                    clicks.add(index);
                  ssum = '$ssum' + '+' + '$text';
                  _statuses[index] = Status.Visible;
                  _Bgstatus[index] = Bgstatus.BgVisible;
                });

                print('qwer nniiikkkiilll $ssum');
                print(
                    'helo this is in status os the values stored n $_statuses');
                print(
                    'helo this is num on clicked value of sum in if condiyion $sum');

                _center.add(index);
                _Index.add(index);

                print('helo this is num on clicked value $text');
                sum = sum + text;
                print('helo this is sum value $sum');

                if (sum != 0) {
                  print('helo this is ur value $text');
                  setState(() {
                    print('helo this is sum value $sum');
                    if (sum == Ansr) {
                      ssum = '$ssum' + '=$sum';

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
                        _statuses = _copyVal
                            .map((a) => Status.Active)
                            .toList(growable: false);
                        _Bgstatus = _copyVal
                            .map((a) => Bgstatus.BgActive)
                            .toList(growable: false);
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
                        });
                      }

                      _val2.removeRange(0, _val2.length);
                    }
                  });
                }
              }
            });
          } else {
            if(clicks.last == index)
            {
             clicks.add(index);
            setState(() {
                clicks.removeLast();
                 if (clicks.last == index) {
                print('kkk  ${clicks.last}  index $index');
                // if (cdletters[cdindex - 1] == index) {
                  setState(() {
                    widget.onScore(-1);
          
                  });
                // }
                setState(() {
            sum=sum-text;

           // List Sum =[];
          // Ssum=ssum.split('');
          // for(var k=0; k<Ssum.length-2;k++){
          //      Sum.add(Ssum[k]);
              
          // }
          //   print(" hello this is to cahracter is $Sum");
          
     
          
           if(ssum.length>=2){
          ssum=ssum.replaceRange(ssum.length-2, ssum.length,'');
          _center.removeLast();
           }
           else{
              ssum=ssum.replaceRange(ssum.length-1, ssum.length,'');
              ssum='';
               _center.removeRange(0, _center.length);
                _Index.removeRange(0, _Index.length);
           }
                // print(" hello this is to cahracter is $Ssum");
                              _statuses[index] = Status.Active;
                });
                clicks.removeLast();
              }
               print(" hello this is to cahracter is $sum");
               print("hellooo thsssss is deleting string last $ssum");
              // sum = 0;
              // _statuses =
              //     _copyVal.map((a) => Status.Active).toList(growable: false);
              // _Bgstatus = _copyVal
              //     .map((a) => Bgstatus.BgActive)
              //     .toList(growable: false);
              // _Index.removeRange(0, _Index.length);
              // _num2.removeRange(0, _num2.length);
              // _center.removeRange(0, _center.length);

              // center = 0;
            });
          }
          }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new LayoutBuilder(builder: (context, constraints) {
      var j = 0; 
     
    

    final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 2);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      return new Container(
        child: new Column(
     
          children: <Widget>[
         
       new Container(
        
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
              ],
            ),
       ),


            new Expanded(
                  child: new Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                child: new ResponsiveGridView(
          
              rows: _size,
              cols: _size,
              maxAspectRatio: 1.0,
              children: _letters
                   .map((e) =>new  Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(j, e, _statuses[j], _Bgstatus[j++])
                  ))
                  .toList(growable: false),
            )
            ),
            ),
          ],
        ),
      );
    });
 
}
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.index,
      this.status,
      this.bgstatus,
      this.onPress})
      : super(key: key);

  final int text;
  int index;
  Status status;
  Bgstatus bgstatus;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  int _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (!widget.text.isNaN) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");

    return new Container(
       
        child: new ScaleTransition(
          scale: animation,
          child: new GestureDetector(
                       child: new Container(
               
               child: new UnitButton(
                 
                  onPress:() => widget.onPress(),
                  text:_displayText.toString(),
                  highlighted: widget.status == Status.Visible? true :false,
                  unitMode: UnitMode.text,
                          ) 
                          )      ),
        ));

  }
}
