import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

class Connectdots extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Connectdots(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new ConnectdotsState();
}
enum Status {Active, Visible, Disappear}
enum ShakeCell { Right, InActive, Dance, CurveRow }

class ConnectdotsState extends State<Connectdots> {

  var  i=0;
  var n=0;
  var count=0;
 final List<int> _numserial = [
   3,4,5,6,7,8
];
final List<int> _numothers =[11,10,1];

  final int _size = 3;
  static int size=3;
 
 List<int> numbers=[];

  List<int>_shuffledLetters = [];
 
  List _copyAns = [];
 
  List<int> _letters;
  List<int> _letters1;
  List<int> _number0;
  List<int> _number1;
  List<int> _number2;
  List<int> _number3;
  List<Status> _statuses;
List<int> _letterex;

  List<ShakeCell> _ShakeCells = [];

  @override
  void initState() {
    super.initState();
   _numserial.forEach((e) { _copyAns.add(e);});
   
 
          _numserial.forEach((e){ numbers.add(e);});
          _numothers.forEach((v){numbers.add(v);});

      numbers.shuffle();
      print("suffle data is in my numbers is $numbers");
      numbers.sort();
      print("sorted numbers are $numbers ");
    
    for (var i = 0; i < numbers.length; i += _size * _size) {
      _shuffledLetters.addAll(
          numbers.skip(i).take(_size * _size).toList(growable: true)
      );
    }
    _statuses = numbers.map((a)=>Status.Active).toList(growable: false);
_ShakeCells=numbers.map((a)=>ShakeCell.InActive).toList(growable: false);

    print(_shuffledLetters);
   _number0 = _shuffledLetters.sublist(0, _size);
    
     _number1= _shuffledLetters.sublist(_size,_size+_size);
     _number3=_shuffledLetters.sublist(_size+_size,_size*3);

      print("number sublist is  $_number1");
    Iterable _number2 = _number1.reversed;
    var fruitsInReverse = _number2.toList();
     print("number sublist reverse is is  $fruitsInReverse");

  var rng = new Random();
  for (var i = 0; i <1; i++) {
      n= rng.nextInt(2);
  }
  if(n==1)
{
              _letterex=_shuffledLetters.sublist(0, _size);
               fruitsInReverse.forEach((e){_letterex.add(e);});
           
            _number3.forEach((v){_letterex.add(v);});
            Iterable _number4 = _letterex.reversed;
            var fruitsInReverset = _number4.toList();
            _letters=fruitsInReverset;

     print("hello all data here $_letters");
  }
  else{
              _letters=_shuffledLetters.sublist(0, _size);
               fruitsInReverse.forEach((e){_letters.add(e);});
           
            _number3.forEach((v){_letters.add(v);});

  }
  }

  Widget _buildItem(int index,int  text, Status status,ShakeCell tile) {

   
    return new MyButton(
        key:new  ValueKey<int>(index),
        text: text,
        status: status,
          tile: tile,
        onPress: () {
      
          if (status == Status.Active) {
            if(text==_copyAns[i])
            {
              setState(() {
                _statuses[index] = Status.Visible;

              });
            i++;
            }
            else{
                setState(() {
               _ShakeCells[index] = ShakeCell.Right;
               print("hello shake cell list$_ShakeCells");
                 new Future.delayed(const Duration(milliseconds: 400), () {
                  setState(() {
                    _ShakeCells[index] = ShakeCell.InActive;
                  });
                });

              });
            }
          }
       
        });


  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");



    List<TableRow> rows = new List<TableRow>();
    var j = 0;
   
      return new ResponsiveGridView(
      rows: _size,
      cols: _size,
      children: _letters.map((e) => _buildItem(j, e, _statuses[j],_ShakeCells[j++])).toList(growable: false),
    );
  

  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status,this.tile, this.onPress}) : super(key: key);

  final int text;
  Status status;
   ShakeCell tile;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animationRight,animation, animationWrong, animationDance;
  int _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller =
       new  AnimationController(duration: new Duration(milliseconds: 250), vsync: this);
        animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
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
    animationWrong = new Tween(begin: -8.0, end: 8.0).animate(controller1);
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
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
      return new ScaleTransition(
          scale: animation,
          child: new Shake(
   animation: widget.tile == ShakeCell.Right
                ? animationWrong
                : animationRight,
          

              child: new ScaleTransition(
                scale: animationRight,
             child: new RaisedButton(
                  onPressed: () => widget.onPress(),
       
                  color: widget.status == Status.Visible
                      ? Colors.yellow
                      : Colors.teal,
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0))),
                  child: new Text("$_displayText",
                      style:
                          new TextStyle(color: Colors.black, fontSize: 24.0)))      ),
       ) );
  }
}
