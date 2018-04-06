import 'dart:async';
import 'dart:math';
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
  MatchTheFollowing({
    key,
    this.onScore,
    this.onProgress,
    this.onEnd,
    this.iteration,
    this.function,
    this.gameCategoryId,
  })
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

enum Status { Disable, Enable, ShakeLeft, Stopped0,Shake,Stopped }
enum StatusShake { Stopped, ShakeRight,Shake }

class _MatchTheFollowingState extends State<MatchTheFollowing>
    with SingleTickerProviderStateMixin {
  int c = 0;
  int start = 0, increament = 0;
  List<String> _leftSideletters = [];
  List<String> _rightSideLetters = [];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  List<Status> _statusColorChange;
  List<Status> _statusShake;
  Map<String, String> _allLetters;
  String _leftSideText, _rightSideText;
  int indexText1, indexText2, indexLeftButton;
  int correct = 0,
      i = 0,
      _oldIndexforLeftButton = 0,
      _oldIndexforRightButton = 0,
      _nextTask = 5,
      flag2 = 0;
  bool _isLoading = true;
  int indexL, flag = 0, flag1 = 0;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 10.0,
        height: 10.0,
        child: new CircularProgressIndicator(),
      );
    }
   return  new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      new Expanded(
         child: _buildLeftSide(context),
        ),
        new Expanded(
         child:_buildRightSide(context),
        ),
      ],
    ); 
  }
  void initState() {
    super.initState();
    _initBoard();
  }

    @override
  void didUpdateWidget(MatchTheFollowing oldWidget) {
    // super.didUpdateWidget(oldWidget);
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }
  void _initBoard() async {
    correct=0;
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
    print("data is comming here:: $_rightSideLetters ,$_rightSideLetters");
    for ( int i = start; i < _nextTask; i++) {
      _shuffledLetters.addAll(
          _leftSideletters.skip(i).take(_nextTask).toList(growable: false)..shuffle());

      _shuffledLetters1.addAll(
          _rightSideLetters.skip(i).take(_nextTask).toList(growable: false)..shuffle());   
    }
    _lettersLeft = _shuffledLetters.sublist(start, _nextTask);
    _lettersRight = _shuffledLetters1.sublist(start, _nextTask);
    _statusColorChange=[];
    _statusColorChange =_shuffledLetters.map((a) => Status.Disable).toList(growable: false);
        _statusShake=[];
    _statusShake = _shuffledLetters1.map((e) => Status.Stopped).toList(growable: false);
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
          _oldIndexforLeftButton = index;
          indexLeftButton = index;
          flag2 = 1;
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
    int score = 2;
    if (_leftSideletters.indexOf(_leftSideText) ==
        _rightSideLetters.indexOf(_rightSideText)) {
      setState(() {
        _lettersLeft[indexText1] = null;
        _lettersRight[indexText2] =null;
      });
      correct++;
      widget.onScore(score);
      widget.onProgress(correct / 5);
      score = score + 2;
    } else {
      if (_statusColorChange[indexLeftButton]==Status.Enable) {
          setState(() {
            _statusShake[indexRightbutton] = Status.Shake;
            _statusColorChange[indexLeftButton] = Status.Shake;
            flag1 = 1;
          });
          try{
          new Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              _statusShake[indexRightbutton] = Status.Stopped;
              _statusColorChange[indexLeftButton] = Status.Enable;
            });
          }
          );
          } catch(exception,e){}
          // catch(exception,e){
          // //   _statusShake[indexRightbutton] = StatusShake.Stopped;
          // // _statusColorChange[indexLeftButton] = Status.Enable;
          // }
      }
    }
  //  _oldIndexforRightButton = indexRightbutton;
    new Future.delayed(const Duration(milliseconds: 300), ()
    {
      if (correct == 5) {
      correct = 0;
      _initBoard();
       setState(() {});
       widget.onEnd();
    }
    }
    );
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
  })
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  bool active;
  Status status;
  Animation shake;
  int flag = 0;
  @override
  createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller, controllerShake;
  Animation animationInvisible, animationShake,noAimation;
  initState() {
    super.initState();
    initStateData();
  }

  initStateData() {
    super.initState();
    _displayText = widget.text;
    print("button key :: ${widget.key}");
    controller = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);
    controllerShake = new AnimationController(
        duration: new Duration(microseconds: 500), vsync: this);
    animationInvisible =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animationShake = new Tween(begin: -2.0, end: 2.0, ).animate(controllerShake);
    noAimation = new Tween(begin: 0.0, end: 0.0, ).animate(controllerShake);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        if (widget.text == null) {
          setState(() => _displayText = widget.text);
        }
      }
    });
    controller.forward();
    shake();
  }
  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    } 
  }

  void shake() {
    animationShake.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerShake.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerShake.forward();
      }
    });
    controllerShake.forward();
  }

  void stop() {
    controllerShake.stop();
  }

  @override
  void dispose() {
    controllerShake.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
   return new Shaker(
        key: widget.key,
        animation: (widget.status == Status.Shake)
            ? animationShake
            : noAimation,
        child: new ScaleTransition(
            scale: animationInvisible,
            key: widget.key,
            child: new RaisedButton(
              disabledColor:  Colors.blue,
                elevation: 5.0,
                splashColor: Colors.red,
                onPressed: () => widget.onPress(),
                color: (widget.status == Status.Enable || widget.status==Status.Shake)
                    ? Colors.yellow[300]
                    : new Color(0xFFed4a79),
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text(_displayText,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic)))));
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
    const double shakeDelta = 1.34;
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