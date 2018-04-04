import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';

//void main() {
//  debugPaintSizeEnabled = false;
//  runApp(new MyApp());
//}

//class Fillnumber extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        title: 'Flutter Demo',
//        home: LayoutBuilder(
//          builder: _build,
//        )
//    );
//  }
//
//  Widget _build(BuildContext context, BoxConstraints constraints) {
//    print([constraints.maxWidth, constraints.maxHeight]);
//    return Scaffold(
//        appBar: AppBar(
//            title: Text("this is my game")
//        ),
//        body: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//
//            new  MyTable(),
//
//
//
//          ],
//        ));
//  }
//}

class Fillnumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;

  Fillnumber({key, this.onScore, this.onProgress, this.onEnd, this.iteration,this.gameCategoryId})
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




  final List<String> _allLetters = [
    '1',
    '2',
    '3',
    '4',


  ];
  static List list = [
    5,
    6,
    7,
    8,
    10,
    null,
  ];

// static int ansval= list[i];
  final int _size = 4;
  static int size=4;
  var T=size;
  var B=size;
  var _currentIndex = 0;


  List<String> _shuffledLetters = [];
  List<String> _copyVal = [];
  List _copyAns = [];
  List _Index = [];
  List _num2 = [];
  List _center= [];
  List<String> _letters;
  List<Status> _statuses;

  @override
  void initState() {
    super.initState();
    list.forEach((e) { _copyAns.add(e);});
    ans=_copyAns[i];

    for (var i = 0; i < _size; i++) {
      _allLetters.forEach((e) { _copyVal.add(e);});

    }
    for (var i = 0; i < _copyVal.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _copyVal.skip(i).take(_size * _size).toList(growable: true)
      );
    }
    _statuses = _copyVal.map((a)=>Status.Active).toList(growable: false);
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _size * _size);
  }

  Widget _buildItem(int index, String text, Status status) {

    final TextEditingController t1= new TextEditingController(text: text);
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
                      i = i + 1;
                      ans = _copyAns[i];
                      for (var i = 0; i < _Index.length; i++) {
                        _letters[_Index[i]] = '';
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
                        if (e == '') {
                          count = count + 1;
                        }
                      });
                      _letters.removeWhere((value) => value == '');
                      for (var i = 0; i < count; i++) {
                        _letters.add('');
                      }
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
    var j = 0;
    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)          .take(_size)
          .map((e) => _buildItem(j, e, _statuses[j++]))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container
            (color: Colors.orange,height: 60.0,width: 70.0,
              child:new Center(child:new Text("$ans", style: new TextStyle(color: Colors.black, fontSize: 30.0)))),
          new Table(children: rows),
          new Container
            (color: Colors.orange,height: 60.0,
              child:new Center(child:new Text("$num3", style: new TextStyle(color: Colors.black, fontSize: 30.0)))),
        ],
      ),
    );

  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status, this.onPress}) : super(key: key);

  final String text;
  Status status;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() =>new  _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

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
          if (!widget.text.isEmpty) {
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
    return new TableCell(
        child:new  Padding(
            padding: new EdgeInsets.all(8.0),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding:new  EdgeInsets.all(8.0),
                    color: widget.status == Status.Visible ? Colors.yellow : Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style:
                       new  TextStyle(color: Colors.white, fontSize: 24.0))))));
  }
}
