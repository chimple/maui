import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';

class Fillnumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Fillnumber({key, 
  this.onScore,
   this.onProgress, this.onEnd, this.iteration,this.gameCategoryId, this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>new MyFillnumberState();
}
enum Status {Active, Visible, Disappear}

class MyFillnumberState extends State<Fillnumber> {
  var sum=0;
  var ia=0;
  var center=0;
  var center2=0;
  var R=1;
  var L=1;
  var val=0;
  var  i=0;
  var ans=0;
  var num1=0;

  var count=0;
  List<String> num3=[];




  // final List<String> _allLetters = [
  //   '1',
  //   '2',
  //   '3',
  //   '4',


  // ];
  static List list = [
    2,
    3,
    5,
    6,
    null
  ];

// static int ansval= list[i];
  final int _size = 4;
  static int size=4;
  var T=size;
  var B=size;
  var _currentIndex = 0;
  List<List<int>> _allLetters;


  List<int> _shuffledLetters = [];
  List<int> _copyVal = [];
  List _copyAns = [];
  List _Index = [];
  List _num2 = [];
  List _center= [];
  List<int> _letters;
  List<Status> _statuses;
 bool _isLoading = true;
 List<int> _val1 =[];
 List _val2=[];
 var c=0;

  @override
  void initState() {
    super.initState();
     _initBoard();
  }
   void _initBoard() async {
    // list.forEach((e) { _copyAns.add(e);});
    // ans=_copyAns[i];
    setState(()=>_isLoading=true);
    _allLetters = await fetchFillNumberData(widget.gameCategoryId, _size);
   
   print("shanthus data is $_allLetters");
   
      _allLetters.forEach((e) { e.forEach((v) {_copyVal.add(v); });});

    
    for (var i = 0; i < _copyVal.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _copyVal.skip(i).take(_size * _size).toList(growable: true)
      );
    }
    _statuses = _copyVal.map((a)=>Status.Active).toList(growable: false);
    print("data in _shuffledLetters of shanthu $_shuffledLetters");
    _letters = _shuffledLetters.sublist(0, _size * _size);
    for(var i=2;i<8; i++)
    { var sum=0;
    var end=0;
    print("value of start of is $c");
    end=i+c;
    print("value of end is in shanthu is $end");
    if(c<14)
    {
        _val2=_shuffledLetters.sublist(c, end);
      
      c=end;

      for (num e in _val2) {
  sum += e;
  
  
}
    }
    else if(c==14){
      _val2=_shuffledLetters.sublist(c, c+2);
      c=c+2;
        for (num e in _val2) {
  sum += e;
  
  
}

    }
  print(" the value of sum of shanthhhu data is$sum");
 _val1.add(sum);
  print("value of shanthu when sublist of letters is $_val1");
 _val2.removeRange(0, _val2.length);
    }
     _val1.forEach((e) { _copyAns.add(e);});
    ans=_copyAns[i];
    print("value of shanthu when sublist of letters is $_val1");

  }

  Widget _buildItem(int index, int text, Status status) {

    final TextEditingController t1= new TextEditingController(text: text.toString());
    return new MyButton(
        key: new  ValueKey<int>(index),
        text: text,
        status: status,
        onPress: () {
          num1 = int.parse(t1.text);
          if(status==Status.Active) {

            if (sum == 0) {
              setState(() {
                num1 = int.parse(t1.text);
                num3.add('$num1 +');
              });
              num1 = int.parse(t1.text);
//            center = index;
              val = index;
              setState(() {
                _statuses[index] = Status.Visible;
              });
              print('helo this is in status os the values stored n $_statuses');

              _center.add(val);
              _Index.add(val);
              sum = sum + num1;

              print('helo this is num on clicked value of sum $sum');
              print('helo this is num on clicked index value $index');
            }
            _center.forEach((e) {
              center = e;
              if ((index == center + R || index == center + B ||
                  index == center - L || index == center - T)) {

                setState(() {
                  _statuses[index] = Status.Visible;
                });
                print('helo this is in status os the values stored n $_statuses');
                print('helo this is num on clicked value of sum in if condiyion $sum');
                var val = index;
                _center.add(val);
                _Index.add(val);
                var num1 = int.parse(t1.text);
                setState(() {

                  num3.add('$num1 +');
                });
                print('helo this is num on clicked value $num1');
                sum = sum + num1;
                print('helo this is sum value $sum');


                if (sum <= _copyAns[i]) {
                  print('helo this is ur value $num1');
                  setState(() {
                    num1 = int.parse(t1.text);

                    print('helo this is sum value $sum');

                    _currentIndex++;
                    if (sum == _copyAns[i]) {
                        widget.onScore(1);
              widget.onProgress((count + 2) / 6.5);
                      i = i + 1;
                      ans = _copyAns[i];
                      for (var i = 0; i < _Index.length; i++) {
                        _letters[_Index[i]] = null;
                      }

                      sum = 0;
                      center = 0;

                      _center.removeRange(0, _center.length);
                      print('helo this is sum when resetting in it value $sum');
                      print(
                          'helo this is sum when resetting in it value $_letters');
//                _letters.removeWhere((value) if(value==''){
//
//                }
//                        );
                      _letters.forEach((e) {
                        if (e == null) {
                          count = count + 1;
                        }
                      });
                      _letters.removeWhere((value) => value == null);
                      for (var i = 0; i < count; i++) {
                        _letters.add(null);
                      }
                      count=0;
                      _statuses = _copyVal.map((a) => Status.Active).toList(
                          growable: false);
                      _Index.removeRange(0, _Index.length);
                      _num2.removeRange(0, _num2.length);
                      num3.removeRange(0, num3.length);
                    }
                  });
                }
                else if (sum >= _copyAns[i]) {
                  sum = 0;
                  print(
                      'helo this is sum when resetting in else if it value $sum');
                  _Index.removeRange(0, _Index.length);
                  _center.removeRange(0, _center.length);
                  center = 0;
                }
              }
//        else{
//            sum=0;
//            _Index.removeRange(0, _Index.length );
//            _center.removeRange(0, _center.length );
//            center=0;
//            print('helo this is sum when resetting in else if it value $sum');
//          }
            });
          }
          else {

            setState(() {
              sum=0;
              _statuses = _copyVal.map((a) => Status.Active).toList(
                  growable: false);
              _Index.removeRange(0, _Index.length);
              _num2.removeRange(0, _num2.length);
              _center.removeRange(0, _center.length);
              num3.removeRange(0, num3.length);
              center = 0;



            });
          }
        });


  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");



    List<TableRow> rows =new  List<TableRow>();
   
    // for (var i = 0; i < _size; ++i) {
    //   List<Widget> cells = _letters
    //       .skip(i * _size)          .take(_size)
    //       .map((e) => _buildItem(j, e, _statuses[j++]))
    //       .toList();
    //   rows.add(new TableRow(children: cells));
    // }
    // new ResponsiveGridView(
    //   rows: _size,
    //   cols: _size,
    //   children: _letters.map((e) => _buildItem(j, e, _statuses[j++])).toList(growable: false),
    // );
    return new LayoutBuilder(builder: (context, constraints) {
         var j = 0;
     
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container
            (color: Colors.orange,height: 40.0,width: 40.0,
              child:new Center(child:new Text("$ans", style: new TextStyle(color: Colors.black, fontSize: 25.0)))),
       new Expanded( child:   new ResponsiveGridView(
      rows: _size,
      cols: _size,
      children: _letters.map((e) => _buildItem(j, e, _statuses[j++])).toList(growable: false),
    )),
          new Container
            (color: Colors.orange,height: 40.0,
              child:new Center(child:new Text("$num3", style: new TextStyle(color: Colors.black, fontSize: 30.0)))),
        ],
      ),
    );
    });

  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status, this.onPress}) : super(key: key);

  final int text;
  Status status;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() =>new  _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  int _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller =
        new AnimationController(duration:new  Duration(milliseconds: 250), vsync: this);
    animation =new  CurvedAnimation(parent: controller, curve: Curves.easeIn)
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

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return  new ScaleTransition(
                scale: animation,
                child: new GestureDetector(
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding:new  EdgeInsets.all(8.0),
                    color: widget.status == Status.Visible ? Colors.yellow : Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                    child: new Text("$_displayText",
                        style:
                       new  TextStyle(color: Colors.white, fontSize: 24.0)))));
  }
}
