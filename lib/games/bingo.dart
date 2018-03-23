import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;

class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  final String question;
  final String answer;

  Bingo({key, this.onScore, this.onProgress,this.onEnd,this.iteration,this.question,this.answer}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new BingoState();
}

class BingoState extends State<Bingo> {

//  List<Bingo> bingos = [
//    Bingo(
//        key:1, question: "1 + 2",answer: '3', ),
//    Bingo(
//      key:2, question: "1 + 3",answer: '4', ),
//    Bingo(
//      key:3, question: "1 + 4",answer: '5', ),
//    Bingo(
//      key:4, question: "1 + 6",answer: '7', ),
//    Bingo(
//      key:5, question: "1 + 7",answer: '8', ),
//    Bingo(
//      key:6, question: "1 + 8",answer: '9', ),
//    Bingo(
//      key:7, question: "1 + 10",answer: '11', ),
//    Bingo(
//      key:8, question: "1 + 11",answer: '12', ),
//    Bingo(
//      key:9, question: "1 + 12",answer: '13', ),
//  ];

  final List<String> _allLetters = [
//    'A',
//    'B',
//    'C',
//    'D',
//    'E',
//    'F',
//    'G',
//    'H',
//    'I',
//    'J',
//    'K',
//    'L',
//    'M',
//    'N',
//    'O',
//    'P',
//    'Q',
//    'R',
//    'S',
//    'T',
//    'U',
//    'V',
//    'W',
//    'X',
//    'Y',
//    'Z'
    '1','2','3','4','5','6','7','8','9' ,'1','2','3','4','5','6','7','8','9'
  ];
  final List<String> question = [ "2","2 + 3","1 + 5", ];

  final int _size = 3;
  var _currentIndex = 0;
  String  ques = "";
  var num1= 0;
  var i = 0;
  List _copyQuestion = [];
  List<String> _shuffledLetters = [];
  List<String> _letters;

  List<String>_copyVal= [];

  var sum = 0;
  bool _active = false;
  @override
  void initState() {
    super.initState();
    ques= question[i];
    print("this is a " + question[i]);
    print("this is a $ques");

    for (var i = 0; i < _size; i++) {
      _allLetters.forEach((e) { _copyVal.add(e);});

    }
    for (var i = 0; i < _copyVal.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _copyVal.skip(i).take(_size * _size).toList(growable: true)..shuffle()
      );
    }
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _size * _size);
  }



  Widget _buildItem(int index, String text) {
    final TextEditingController t1 = new TextEditingController(text: text);
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          setState(() {
            print("this is a sum $sum");
            num1 = int.parse(t1.text);
            sum =  num1;
            if(num1 == int.parse( question[i])){
              print("after touch $_copyQuestion[i]");
              i = i+1;
              ques = question[i];
            }
            
          });
          widget.onScore(1);
          widget.onProgress(_currentIndex/_allLetters.length);
//          }

        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    List<TableRow> rows = new List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }
//    return new Table(children: rows);
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container
            (color: Colors.orange,height: 60.0,width: 70.0,
              child:new Center(child:new Text("$ques", style: new TextStyle(color: Colors.black, fontSize: 30.0)))),
          new Table(children: rows),
//          new Container
//            (color: Colors.orange,height: 60.0,
//              child:new Center(child:new Text("num3", style: new TextStyle(color: Colors.black, fontSize: 30.0)))),
        ],
      ),
    );
  }

}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress()}) : super(key: key);

  final String text;
  final VoidCallback onPress;


  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;


  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.linear,)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.completed) {
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
        child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.red,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style: new TextStyle(
                            color: Colors.white, fontSize: 24.0))))));
  }
}

