import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'package:maui/components/';
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
enum Status {Active,Visible,Wrong}


class BingoState extends State<Bingo> with SingleTickerProviderStateMixin {

   Map<String,String> _Bingodata;
//  final List<String> _question;
   List<String> _all = [];

   int _size = 4;
  var _currentIndex = 0;
  var ques = 0;
  var num1 = 0;
  var i = 0;
  List storeBingo = [];
  Animation animation;
  AnimationController animationController;
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
  }


  void _myAnim() {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
    print('Pushed the Button');
  }

  Widget _buildItem(int index , String text , Status status) {
    final TextEditingController t1 = new TextEditingController(text: text);
    return new MyButton(
        key: new ValueKey<int>(index) ,
        text: text ,
        status: status ,
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
                status==Status.Wrong;
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
  AnimationController controller,controller1;
  Animation<double> animationRight,animationWrong;
  String _displayText;

  initState() {
    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
     animationRight = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animationRight.value}");
        if (state == AnimationStatus.completed) {
//        /  print('dismissed');
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
   controller.forward();
    animationWrong = new Tween(begin: 0.0, end: 20.0).animate(controller1);
//    animationWrong.addStatusListener((state) {
//      if (state == AnimationStatus.completed) {
//        controller.reverse();
//      } else if (state == AnimationStatus.dismissed) {
//
//        controller.forward();
//      }
//    });
//    controller.forward();
//    print('Pushed the Button');

  }



  @override
  void didUpdateWidget(MyButton oldWidget) {
    if (oldWidget.text != widget.text) {
      controller.reverse();
    } else if (oldWidget.text == widget.text) {
      controller1.addStatusListener((state1) {

        if (state1 == AnimationStatus.completed) {
          controller1.reverse();
        } else if (state1 == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
      controller1.forward();
      new Future.delayed(const Duration(milliseconds: 1400), () {
        try {
          controller1.stop();
        }
        catch(exception, exc){}
      });
    }
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
//    print("_MyButtonState.build");


    return new TableCell(

            child: new Container(
                    padding: const EdgeInsets.all(8.0),
            child: new Shake
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
                            color: Colors.white, fontSize: 24.0)))))));
  }
}
