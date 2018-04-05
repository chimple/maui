import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;

class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;


  Bingo({key, this.onScore, this.onProgress,this.onEnd,this.iteration}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new BingoState();
}
enum Status {Active,Visible}


class BingoState extends State<Bingo> {

  final List<String> _allLetters = [
    '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9'
  ];
  final List<String> question = [
    '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' ,
  ];

  final int _size = 3;
  var _currentIndex = 0;
  var ques = 0;
  var num1 = 0;
  var i = 0;
  List storeBingo = [];

  List _copyQuestion = [];
  List _Maped = [];
  List<String> _shuffledLetters = [];
  List<Status> _statuses;
//  List _letters;
  static int m = 3;
  static int n = 3;
  static double k = 3.0;
  static double l = 3.0;
  var count = 0;
  // stored index check
  var s = 0;


  var sum = 0;
  var _letters = new List.generate(m , (_) => new List(n));
  var _referenceMatrix = new List.generate(k.ceil() , (_) => new List(l.ceil()));

  @override
  void initState() {
    super.initState();

    question.forEach((e) {
      _copyQuestion.add(e);
    });
    ques = _copyQuestion[i];
    print("this is a $question");
    print("this is a $ques");


    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_size * _size).toList(growable: true)
            ..shuffle()
      );
    }
//    for (var i = 0; i < _size; i++) {
//      for (var j = 0; j < _size; j++) {
//        _referenceMatrix[i][j] = _shuffledLetters[count];
//        count++;
//      }
//    }
    print({"reference size referenceMatrix.length": _referenceMatrix});
    _letters = _shuffledLetters.sublist(0 , _size * _size);
    _statuses = _letters.map((a) => Status.Active).toList(growable: false);
  }


  Widget _buildItem(int index , String text , Status status) {
    final TextEditingController t1 = new TextEditingController(text: text);
    return new MyButton(
        key: new ValueKey<int>(index) ,
        text: text ,
        status: status ,
        onPress: () {
          s = index;
          if (_statuses[index] != Status.Visible) {
            setState(() {
              if (int.parse(t1.text) == int.parse(_copyQuestion[i])) {

                _statuses[index] = Status.Visible;
                print({"inside setstate index:": index});
                print(({"this is text":text}));

                int counter = 0;
                for(int i= 0;i<3;i++){
                  for(int j=0;j<3;j++){
                    if(counter == index){
                      _referenceMatrix[i][j] = text;
                    }
                    counter++;
                  }
                }

                int matchRow = bingoHorizontalChecker();
                print({"the bingo checker response row : " : matchRow});
                int matchColumn = bingoVerticalChecker();
                print({"the bingo checker response column: " : matchColumn});

                print({"this is reference":_referenceMatrix});
                print({"this is i value ": i });

                if(i < _size*_size-1){
                  i = i + 1;
                  ques = _copyQuestion[i];
                }else{
                  print({"where is green manu ": " hello index is over"});
                }
              }
            }
            );
          }
        });
  }


  @override
  Widget build(BuildContext context) {
//    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    List<TableRow> rows = new List<TableRow>();
    var j = 0;

    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j , e , _statuses[j++]))
          .toList();
      rows.add(new TableRow(children: cells));

    }

    return new Container(
      child: new Column(
        children: <Widget>[
          new Container
            (color: Colors.orange , height: 60.0 , width: 70.0 ,
              child: new Center(child: new Text("$ques" ,
              key: new Key('question'),
                  style: new TextStyle(
                      color: Colors.black , fontSize: 30.0)))) ,
          new  Table(children: rows) ,
//          new Container
//            (color: Colors.orange,height: 60.0,
//              child:new Center(child:new Text("num3", style: new TextStyle(color: Colors.black, fontSize: 30.0)))),
        ] ,
      ) ,
    );
  }

  int bingoHorizontalChecker() {

    print({"the reference matrix value is : " : _referenceMatrix});
    for(int i= 0 ; i< _referenceMatrix.length ; i++){
      bool bingo = true;
      for(int j = 0 ; j < _referenceMatrix.length; j++){
        if(_referenceMatrix[i][j] == null){
          bingo = false;
          break;
        }
      }
      if(bingo)
        return i;
    }

    return -1;
  }

  int bingoVerticalChecker() {

    print({"the reference matrix value is : " : _referenceMatrix});
    for(int j= 0 ; j< _referenceMatrix.length ; j++){
      bool bingo = true;
      for(int i = 0 ; i < _referenceMatrix.length; i++){
        if(_referenceMatrix[i][j] == null){
          bingo = false;
          break;
        }
      }
      if(bingo)
        return j;
    }

    return -1;
  }


}

class MyButton extends StatefulWidget{
  MyButton({Key key, this.text, this.onPress,this.status}) : super(key: key);

  final String text;
  final VoidCallback onPress;
  Status status;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.completed) {
//        /  print('dismissed');
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
//    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
//    print("_MyButtonState.build");


    return new TableCell(
        child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: const EdgeInsets.all(8.0),
                    color: widget.status == Status.Visible ? Colors.yellow : Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style: new TextStyle(
                            color: Colors.white, fontSize: 24.0))))));
  }
}
