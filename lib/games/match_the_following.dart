import 'dart:async';
//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
//import 'package:maui/components/shaker.dart';

class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  bool isRotated;
  MatchTheFollowing(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.function,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

enum Status { Disable, Enable, ShakeLeft, Stopped0,Shake,Stopped }
enum Status { Disable, Enable, Dump, Shake, Stopped,Color }
enum StatusShake { Stopped, ShakeRight, Shake, }

//enum color {0xFFaa0e42}
class _MatchTheFollowingState extends State<MatchTheFollowing>
    with SingleTickerProviderStateMixin {
  int c = 0;
  int start = 0, increament = 0;
  List<String> _leftSideletters = [];
  List<String> _rightSideLetters = [];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  List<Status> _statusColorChange=[];
  List<Status> _statusShake=[];
  Map<String, String> _allLetters;
  String _leftSideText, _rightSideText;
  final int score = 2;
  int indexText1, indexText2, indexLeftButton;
  int correct = 0,
      i = 0,
      _oldIndexforLeftButton = 0,
      _oldIndexforRightButton = 0,
      _nextTask = 5,
      flag2 = 0,
      leftSideTextIndex = 0,
      _gameEnd = 0;
  bool _isLoading = true;
  int indexL, flag = 0, flag1 = 0, _wrongAttem = 0;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 10.0,
        height: 10.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new Material(
     child:new Container(
        color: new Color(0xFF28c9c9),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: _buildLeftSide(context),
            ), 
            new Expanded(child: _buildRightSide(context)), 
          ],
        ))
        );
  }

  void initState() {
    super.initState();
    //if (!widget.isRotated)
    _initBoard();
  }

  @override
  void didUpdateWidget(MatchTheFollowing oldWidget) {
     super.didUpdateWidget(oldWidget);
    // print(oldWidget.iteration);
    // print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }
  void _initBoard() async {
    _leftSideletters.clear();
    _rightSideLetters.clear();
    _shuffledLetters.clear();
    _shuffledLetters1.clear();
    setState(() => _isLoading = true);
    _allLetters = await fetchPairData(widget.gameCategoryId, 5);
    _allLetters.forEach((k, v) {
      _leftSideletters.add(k);
      _rightSideLetters.add(v);
    });
    for (int i = start; i < _nextTask; i++) {
      _shuffledLetters.addAll(
          _leftSideletters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());

      _shuffledLetters1.addAll(
          _rightSideLetters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
    }
    _lettersLeft = _shuffledLetters.sublist(start, _nextTask);
    _lettersRight = _shuffledLetters1.sublist(start, _nextTask);
     print("Shuffle data:: $_lettersLeft ,$_lettersRight");
    _statusColorChange =
        _shuffledLetters.map((a) => Status.Disable).toList(growable: false);
    _statusShake =
        _shuffledLetters1.map((e) => Status.Stopped).toList(growable: false);
    setState(() => _isLoading = false);
  }

  Widget _buildLeftSide(BuildContext context) {
    int j = 0;
    return new ResponsiveGridView(
      rows: 5,
      cols: 1,
      padding: const EdgeInsets.all(10.0),
      children: _lettersLeft
          .map((e) => _buildItemsLeft(j, e, _statusColorChange[j++]))
          .toList(growable: false),
    );
  }
  Widget _buildItemsLeft(int index, String text, Status colorstatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: colorstatus,
        onPress: () {
          indexText1 = _lettersLeft.indexOf(text);
          _leftSideText = text;
          if (_statusColorChange[index] != Status.Enable) {
            setState(() {
              _statusColorChange[index] = Status.Enable;
            });
            flag = 1;
          }
          if (_oldIndexforLeftButton != index && flag == 1) {
            _statusColorChange[_oldIndexforLeftButton] = Status.Disable;
            flag = 0;
          }
          //_statusColorChange[index]=Status.Enable;
          _oldIndexforLeftButton = index;
          indexLeftButton = index;
          flag2 = 1;
          leftSideTextIndex = _leftSideletters.indexOf(_leftSideText);
        });
  }

  Widget _buildRightSide(BuildContext context) {
    int j = 5;
    return new ResponsiveGridView(
      rows: 5,
      cols: 1,
      padding: const EdgeInsets.all(10.0),
      children: _lettersRight
          .map((e) => _buildItemsRight(j, e, _statusShake[j++]))
          .toList(growable: false),
    );
  }

  Widget _buildItemsRight(int index, String text, Status shakestatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: shakestatus,
        onPress: () {
          indexText2 = _lettersRight.indexOf(text);
          _rightSideText = text;
          match(index);
        });
  }

  void match(int indexRightbutton) {
    if (flag2 == 1) if (leftSideTextIndex ==
        _rightSideLetters.indexOf(_rightSideText)) {
          try{
      setState(() {
        //  _lettersLeft[indexText1] = null;
         // _lettersRight[indexText2] = null;
        _statusShake[indexRightbutton] = Status.Dump;
        _statusColorChange[indexLeftButton] = Status.Disable;
      });}
      catch(exception,e){}
      correct++;
      widget.onScore(1);
      widget.onProgress(correct / 5);
      flag2 = 0;
      try {
      new Future.delayed(const Duration(milliseconds: 500,),(){
        setState((){
          _statusShake[indexRightbutton] = Status.Color;
        });
      });
      }
      catch(exception,e){}
    } else {
      leftSideTextIndex = -1;
      if (flag2 == 1) {
        setState(() {
          _statusShake[indexRightbutton] = Status.Shake;
          _statusColorChange[indexLeftButton] = Status.Shake;
          flag1 = 1;
        });
        try {
          new Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _statusShake[indexRightbutton] = Status.Stopped;
              _statusColorChange[indexLeftButton] = Status.Disable;
            });
          });
        } catch (exception, e) {}
        flag2 = 0;
        _wrongAttem++;
      }
    }
    if (_wrongAttem > correct && _wrongAttem == 4) {
      _wrongAttem = 0;
      widget.onScore(-correct);
      correct = 0;
      widget.onEnd();
      _initBoard();
    }
    if (correct == 5) {
      correct = 0;
      widget.onScore(-_wrongAttem);      
      _wrongAttem = 0;
      new Future.delayed(const Duration(milliseconds: 1000),(){
       widget.onEnd();
       _initBoard();
       _gameEnd++;
      });
    }
    if (_gameEnd==2){
      _gameEnd=0;
    }
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text,
    this.onPress,
    this.active: true,
    this.status,
    this.shake,
    this.color,
  }) : super(key: key);
  final String text;
  final VoidCallback onPress;
  bool active;
  Status status;
  Animation shake;
  List<int> color;
  int flag = 0;
  @override
  createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller, controllerShake,dumpController;
  Animation animationInvisible, animationShake, noAimation,dumpAnimation;
  initState() {
    super.initState();
    initStateData();
  }

  initStateData() {
    super.initState();
    _displayText = widget.text;
    //print("button key :: ${widget.key}");
    controller = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    controllerShake = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
        dumpController = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    animationInvisible =
        new CurvedAnimation(parent: controller, curve: new Interval(0.0, 1.0,curve: Curves.ease));
        dumpAnimation = new CurvedAnimation(parent: dumpController,curve: new Interval(0.60, 1.0,curve: Curves.easeIn));
    animationShake = new Tween(
      begin: -3.10,
      end: 2.10,
    ).animate(controllerShake);
    noAimation = new Tween(
      begin: 0.0,
      end: 0.0,
    ).animate(controllerShake);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        if (widget.text == null) {
          setState(() => _displayText = widget.text);
        }
      }
    });
    controller.forward();
    shake();
    dumping();
  }
  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.text != widget.text) {
    //   controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });  
    // }
   // controller.forward();
  }
void dumping(){
    dumpController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        dumpController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        dumpController.forward();
      }
    });
    dumpController.forward();
}
  void shake() {
    controllerShake.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerShake.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerShake.forward();
      }
    });
    controllerShake.forward();
  }
  @override
  void dispose() {
    controllerShake.dispose();
    controller.dispose();
    dumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radius=8.0;
    Size media = MediaQuery.of(context).size;
    double _w = media.width;
    _w = _w / 18;
    int _color=0xFFA9A9A9;
    if (widget.status==Status.Shake){
      _color=0xFFff0000; // red
    }
    
    return new Shaker(
        key: widget.key,
        animation:
            widget.status == Status.Shake ? animationShake : noAimation,
        child: new ScaleTransition(
            scale: animationInvisible,
            key: widget.key,
            child: new Container(
            child: new RaisedButton(
                disabledColor:widget.status==Status.Color ? Colors.green : new  Color(_color),
                elevation: (widget.status == Status.Enable ||
                        widget.status == Status.Shake)
                    ? 0.0
                    : 8.0,
                splashColor: Colors.red,
                onPressed: widget.status == Status.Disable ||
                        widget.status == Status.Stopped
                    ? () => widget.onPress()
                    : null,
                color: widget.status== Status.Enable ? new Color(0xFF808080): new Color(0xFFed4a79),
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(radius))),
                child: new Text(_displayText,
                    style: new TextStyle(
                        color: widget.status==Status.Enable? new Color(0xFF13A1A9) :new Color(0xFFffffff),
                        fontSize: _w,
                        fontStyle: FontStyle.italic))
                        ))
                        ));
  }
}

class Shaker extends AnimatedWidget {
  const Shaker({
    Key key,
    Animation<double> animation,
    this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable;

  double get translateX {
    const double shakeDelta = 4.0;
    final double t = animation.value;
    if (t <= 0.25)
      return -t * shakeDelta;
    else if (t < 0.75)
      return (t - 0.5) * shakeDelta;
    else
      return (1.0 - t) * 4.0 * shakeDelta;
  }

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: child,
    );
  }
}