import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/responsive_grid_view.dart';

import 'package:maui/components/Shaker.dart';



class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;

  Bingo({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new BingoState();
}
enum Status {Active,Visible}
enum ShakeCell{Right,Wrong}

class BingoState extends State<Bingo> with SingleTickerProviderStateMixin {

   Map<String,String> _Bingodata;
   List<String> _all = [];

   int _size = 3;
  var ques = 0;
  var num1 = 0;
  var i = 0;
  Animation animation;
  AnimationController animationController;
  List _copyQuestion = [];
   List<String> _shuffledLetters = [];
  List<Status> _statuses;
  List<ShakeCell>_ShakeCells;
//  List _letters;
  static int m = 3;
  static int n = 3;
  static double k = 3.0;
  static double l = 3.0;
  var count = 0;
  // stored index check
  var s = 0;
/// datattaaaa

  bool _isLoading = true;
  var sum = 0;
  var _letters = new List.generate(m , (_) => new List(n));
  var _referenceMatrix = new List.generate(k.ceil() , (_) => new List(l.ceil()));

  @override
  void initState() {
    super.initState();
    _initBoard();
  }
  void _initBoard() async {
     animationController =new AnimationController(duration: new Duration(milliseconds: 100), vsync: this);
     animation = new Tween(begin: 0.0, end: 20.0).animate(animationController);
    setState(()=>_isLoading=true);
    _Bingodata = await fetchPairData(widget.gameCategoryId , _size*_size);
print({"kiran data":_Bingodata});

    _Bingodata.forEach((e,v) {
      _copyQuestion.add(e);
      _all.add(v);
    });
    _copyQuestion.add(null);
    ques = _copyQuestion[i];
    print({"this questions :":_copyQuestion});
    print({"this questions :":_all[i]});
//    print("this is a $question");
    print("this is a $ques");


    for (var i = 0; i < _all.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _all.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
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
    _ShakeCells = _letters.map((a) => ShakeCell.Wrong).toList(growable: false);
    print({"reference size _ShakeCells.length": _ShakeCells});

  }


  Widget _buildItem(int index , String text , Status status,ShakeCell tile) {
    return new MyButton(
        key: new ValueKey<int>(index) ,
        text: text ,
        status: status ,
        tile: tile,
        onPress: () {
          print("index $index");
          print("text $text");
          if (status==Status.Active) {
            print("index kirrrrran $index");
            setState(() {
              if ( text  == _copyQuestion[i]) {

                _statuses[index] = Status.Visible;

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
             ///horizontall  data showing part
                if( -1 != matchRow){
                  print("this is BINGORow");

                }
                int matchColumn = bingoVerticalChecker();
                print({"the bingo checker response column: " : matchColumn});
                if( -1 != matchColumn){
                  print("this is BINGOColumn");

                }

                print({"this is reference":_referenceMatrix});
                print({"this is i value ": i });

                if(i <= _size*_size-1){
                  i++;
                  ques = _copyQuestion[i];
                }else{
                  print({"where is green manu ": " hello index is over"});
                }
              }
              else{
                _ShakeCells[index] = ShakeCell.Right;
                print("this is wrongg");
                new Future.delayed(const Duration(milliseconds: 4000), (){
                    setState((){
                      _ShakeCells[index] = ShakeCell.Wrong;
                    });
              });
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
//    List<TableRow> rows = new List<TableRow>();
    var j = 0;

//    for (var i = 0; i < _size; ++i) {
//      List<Widget> cells = _letters
//          .skip(i * _size)
//          .take(_size)
//          .map((e) => _buildItem(j , e , _statuses[j],_ShakeCells[j++]))
//          .toList();
//      rows.add(new TableRow(children: cells));
//
//    }

//    return new ResponsiveGridView(
//      rows: _size,
//      cols: _size,
//      children: _letters.map((e) =>_buildItem(j , e , _statuses[j],_ShakeCells[j++])).toList(growable: false),
//    );

      return new Column(
        children: <Widget>[
          new Expanded(child:
          new Container
            (color: Colors.orange , height: 45.0 , width: 46.0 ,
              child: new Center(child: new Text("$ques" ,
              key: new Key('question'),
                  style: new TextStyle(
                      color: Colors.black , fontSize: 30.0))))),
          new Expanded(child: new ResponsiveGridView(
          rows: _size,
          cols: _size,
    children: _letters.map((e) =>_buildItem(j , e , _statuses[j],_ShakeCells[j++])).toList(growable: false),
          ))
        ]
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
  MyButton({Key key, this.text, this.onPress,this.status,this.tile}) : super(key: key);

  final String text;
  final VoidCallback onPress;
  Status status;
  ShakeCell tile;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller,controller1;
  Animation<double> animationRight,animationWrong;
  String _displayText;

  initState() {
    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    controller1 =  new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
     animationRight = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.addStatusListener((state) {
        print("$state:${animationRight.value}");
//        if (state == AnimationStatus.completed) {
////        /  print('dismissed');
////          if (!widget.text.isEmpty) {
////            setState(() => _displayText = widget.text);
////            controller.stop();
////          }
//        }
      });
   controller.forward();
    animationWrong = new Tween(begin: 0.0, end: 20.0).animate(controller1);
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

//    new Future.delayed(const Duration(milliseconds: 9000),(){
//      controller1.stop();
//    });
  }

//  @override
//  void didUpdateWidget(MyButton oldWidget) {
//    print({"oldwidget data ": oldWidget.text});
//    if (oldWidget.text != widget.text) {
//      controller.reverse();
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    print("_MyButtonState.build");
return new Container(

            child: new Shake(
              animation:widget.tile == ShakeCell.Right ? animationWrong : animationRight,
            child: new ScaleTransition(
                scale: animationRight,
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