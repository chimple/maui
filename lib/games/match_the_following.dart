import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
//import 'package:maui/components/shaker.dart';
import 'package:maui/components/unit_button.dart';

class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  GameConfig gameConfig;
  bool isRotated;
  final Color disableColor;
  MatchTheFollowing(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.function,
      this.gameConfig,
      this.disableColor,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

enum Status { Disable, Enable, Dump, Shake, Stopped, Color }
enum StatusShake {
  Stopped,
  ShakeRight,
  Shake,
}

//enum color {0xFFaa0e42}
class _MatchTheFollowingState extends State<MatchTheFollowing>
    with SingleTickerProviderStateMixin {
  int c = 0;
  int start = 0, increament = 0;
  List<String> _leftSideletters = [];
  List<String> _rightSideLetters = [];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  List<Status> _statusColorChange = [];
  List<Status> _statusShake = [];
  Map<String, String> _allLetters;
  String _leftSideText, _rightSideText;
  final int score = 2;
  int indexText1, indexText2, indexLeftButton;
  int _oldIndexforLeftButton = 0,
      _nextTask,
      leftIsTapped = 0,
      leftSideTextIndex = 0;
  bool _isLoading = true;
  int indexL, flag = 0, flag1 = 0, correct = 0, _wrongAttem = 0;
  List<String> image = [
    'assets/back.jpg',
    'assets/back1.jpg',
    'assets/background.jpg'
  ];
  List<int> _shake = [];
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 10.0,
        height: 10.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new Container(
        //color: new Color(0xffAB47BC),
        child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Expanded(
          child: _buildLeftSide(context),
        ),
        new Padding(padding: new EdgeInsets.all(60.0)),
        new Expanded(child: _buildRightSide(context)),
      ],
    ));
    // return new Stack(
    //   fit: StackFit.expand,
    //   children: <Widget>[
    //         new Container(
    //   //        child: new Image(
    //   //          fit: BoxFit.fill,
    //   //      image: new AssetImage(image[0])
    //   // ),
    //   ),
    //       new Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         new Expanded(
    //           child: _buildLeftSide(context),
    //         ),
    //        new Padding(padding: new EdgeInsets.all(60.0)),
    //         new Expanded(child: _buildRightSide(context)),
    //       ],
    //     )
    //   ],
    // );
  }

  int _constant, _constant1;
  void initState() {
    super.initState();
    print("initState called::");
    if (widget.gameConfig.level < 4) {
      print("level <4");
      _nextTask = 2;
      _constant = 0;
      _constant1 = 0;
    } else if (widget.gameConfig.level < 6) {
      print("level <8");
      _nextTask = 4;
      _constant = 0;
      _constant1 = 1;
    } else if (widget.gameConfig.level < 8) {
      print("level <10");
      _nextTask = 6;
      _constant = 1;
      _constant1 = 2;
    }

    _initBoard();
    new Future.delayed(
      const Duration(milliseconds: 1000),
    );
  }

  @override
  void didUpdateWidget(MatchTheFollowing oldWidget) {
    //super.didUpdateWidget(oldWidget);
    // print(oldWidget.iteration);
    //print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _leftSideletters.clear();
      _rightSideLetters.clear();
      _shuffledLetters.clear();
      _shuffledLetters1.clear();
      _lettersLeft.clear();
      _lettersRight.clear();
      _shake.clear();
      _initBoard();
      print("Iteration:: ${oldWidget.iteration}");
      print("New Iteration:: ${widget.iteration}");
      print("shuffle data:: $_lettersLeft");
      print("shuffle data:: $_lettersRight");
    }
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allLetters =
        await fetchPairData(widget.gameConfig.gameCategoryId, _nextTask);
    _allLetters.forEach((k, v) {
      _leftSideletters.add(k);
      _rightSideLetters.add(v);
    });
    _shuffledLetters.addAll(
        _leftSideletters.take(_nextTask).toList(growable: false)..shuffle());
    _shuffledLetters1.addAll(
        _rightSideLetters.take(_nextTask).toList(growable: false)..shuffle());
    _lettersLeft = _shuffledLetters.sublist(0, _nextTask);
    _lettersRight = _shuffledLetters1.sublist(0, _nextTask);
    _statusColorChange =
        _shuffledLetters.map((a) => Status.Disable).toList(growable: false);
    for (int i = 0; i <= _nextTask * 2 - 1; i++) {
      _shake.add(0);
    }
    setState(() => _isLoading = false);
    print("All data :: $_allLetters");
  }

  Widget _buildLeftSide(BuildContext context) {
    int j = 0;
    return new ResponsiveGridView(
      rows: _nextTask,
      cols: 1,
      //padding: const EdgeInsets.all(5.0),
      // maxAspectRatio: 4.0,
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
            setState(() {
              _statusColorChange[_oldIndexforLeftButton] = Status.Disable;
              flag = 0;
            });
          }
          //_statusColorChange[index]=Status.Enable;
          _oldIndexforLeftButton = index;
          indexLeftButton = index;
          leftIsTapped = 1;
          leftSideTextIndex = _leftSideletters.indexOf(_leftSideText);
          // question=_rightSideText[ _leftSideletters.indexOf(_leftSideText)];
        });
  }

  Widget _buildRightSide(BuildContext context) {
    int j = _nextTask;
    return new ResponsiveGridView(
      rows: _nextTask,
      cols: 1,
      children: _lettersRight
          .map((e) => _buildItemsRight(j, e, _shake[j++]))
          .toList(growable: false),
    );
  }

  Widget _buildItemsRight(int index, String text, int shake) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        shake: shake,
        onPress: () {
          indexText2 = _lettersRight.indexOf(text);
          _rightSideText = text;

          match(index);
        });
  }

  void match(int indexRightbutton) {
    if (leftIsTapped == 1) if (leftSideTextIndex ==
            _rightSideLetters.indexOf(_rightSideText) ||
        identical(_rightSideText, _leftSideText)) {
      // if (identical(question, answer)) {

      setState(() {
        //  _lettersLeft[indexText1] = null;
        // _lettersRight[indexText2] = null;
        //_statusShake[indexRightbutton] = Status.Dump;
        //_statusColorChange[indexLeftButton] = Status.Disable;
        _shake[indexRightbutton] = 1;
      });
      correct++;
      widget.onScore(1);
      widget.onProgress(correct / _nextTask);
      leftIsTapped = 0;
    } else {
      leftSideTextIndex = -1;
      if (leftIsTapped == 1) {
        //widget.onScore(-1);
        try {
          setState(() {
            _shake[indexRightbutton] = 1;
            //  _statusShake[indexRightbutton] = Status.Shake;
            _statusColorChange[indexLeftButton] = Status.Shake;
            _shake[indexRightbutton] = 2;
            flag1 = 1;
          });
        } catch (exception, e) {}
        try {
          new Future.delayed(const Duration(milliseconds: 700), () {
            setState(() {
              //_statusShake[indexRightbutton] = Status.Stopped;
              _statusColorChange[indexLeftButton] = Status.Disable;
              _shake[indexRightbutton] = 0;
            });
          });
        } catch (exception, e) {}
        leftIsTapped = 0;
        _wrongAttem++;
      }
    }
    if (_wrongAttem >= correct - _constant &&
        _wrongAttem == _nextTask - _constant1) {
      _wrongAttem = 0;
      widget.onScore(-correct);
      correct = 0;
      new Future.delayed(const Duration(milliseconds: 700), () {
        widget.onEnd();
        // _initBoard();
      });
    }

    if (correct == _nextTask) {
      //print('Game Over::');
      //  print("score::$correct-$_wrongAttem}");
      _wrongAttem = 0;
      correct = 0;
      widget.onScore(-_wrongAttem);

      //setState(() {});
      new Future.delayed(const Duration(milliseconds: 1000), () {
        _leftSideletters.clear();
        _rightSideLetters.clear();
        _shuffledLetters.clear();
        _shuffledLetters1.clear();
        _lettersLeft.clear();
        _lettersRight.clear();
        _shake.clear();
        widget.onEnd();

        // _initBoard();
      });
    }
    print("Correct ::$correct ");
    print("Total task:: $_nextTask");
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
  int shake;
  List<int> color;
  int flag = 0;
  @override
  createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller,
      controllerShake,
      dumpController,
      radiusCntroller,
      controllerPress;
  Animation animationInvisible,
      animationShake,
      noAimation,
      dumpAnimation,
      buttonPress;
  Animation<BorderRadius> borderRadius;
  initState() {
    super.initState();
    initStateData();
  }

  initStateData() {
    super.initState();
    _displayText = widget.text;
    //print("button key :: ${widget.key}");
    controllerPress = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    controllerShake = new AnimationController(
        duration: new Duration(milliseconds: 75), vsync: this);
    animationInvisible = new CurvedAnimation(
        parent: controller,
        curve: new Interval(0.0, 1.0, curve: Curves.easeInOut));
    buttonPress = new Tween(begin: .98, end: 0.94).animate(controllerPress);
    animationShake = new Tween(
      begin: 1.0,
      end: -1.0,
    ).animate(controllerShake);
    noAimation = new Tween(
      begin: 0.0,
      end: 0.0,
    ).animate(controllerShake);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        // if (widget.text == null) {
        setState(() => _displayText = widget.text);
        //}
      }
    });
    // borderRadius = new BorderRadiusTween(
    //   begin: new BorderRadius.circular(4.0),
    //   end: new BorderRadius.circular(75.0),
    // ).animate(
    //   new CurvedAnimation(
    //     parent: radiusCntroller,
    //     curve: new Interval(
    //       0.375,
    //       0.500,
    //       curve: Curves.ease,
    //     ),
    //   ),
    // );
    controller.forward();
    shake();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text) {
      controllerPress.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerPress.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //controllerPress.forward();
        }
      });
    }
    controllerPress.forward();
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
    controllerPress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
    final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);
    const double radius = 8.0;
    Size media = MediaQuery.of(context).size;
    double _w = media.height;
    _w = _w / 20;
    int _color = 0xFFed4a79;
    int changeColor = 0xFFed4a79;
    if (widget.shake == 2) {
      _color = 0xFFff0000; // red
    }
    if (widget.status == Status.Enable) {
      changeColor = 0xFFFA8072;
      //widget.disableColor=changeColor;
    }
    if (widget.shake == 1) {
      changeColor = 0xFF00FF00;
    }

    return new Shake(
        animation: widget.status == Status.Shake || widget.shake == 2
            ? animationShake
            : noAimation,
        child: new ScaleTransition(
          scale:
              widget.status == Status.Enable ? buttonPress : animationInvisible,
          child: new UnitButton(
            onPress: (widget.status == Status.Disable || widget.shake == 0)
                ? () => widget.onPress()
                : null,
            text: _displayText,
            unitMode: UnitMode.text,
            // disableColor: widget.status == Status.Enable || widget.shake == 1
            //     ? new Color(changeColor)
            //     : new Color(_color),
          ),
          // child: new RaisedButton(
          //     //splashColor: new Color(0xFFed4a79),
          //     //color: new Color(_color),
          //     disabledColor: widget.status == Status.Enable || widget.shake == 1
          //         ? new Color(changeColor)
          //         : new Color(_color), // red color
          //     elevation: 8.0,
          //     onPressed: (widget.status == Status.Disable || widget.shake == 0)
          //         ? () => widget.onPress()
          //         : null,
          //     shape: new RoundedRectangleBorder(
          //         borderRadius: widget.shake == 1
          //             ? const BorderRadius.all(const Radius.circular(16.0))
          //             : const BorderRadius.all(const Radius.circular(radius))),
          //     child: new Text(_displayText,
          //         style: new TextStyle(
          //             color: Colors.white,
          //             fontSize: _w,
          //             fontStyle: FontStyle.italic))),
        ));
  }
}

class Shake extends AnimatedWidget {
  const Shake({
    Key key,
    Animation<double> animation,
    this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable;
  double get translate {
    final double t = animation.value;
    const double shakeDelta = 2.0;
    // if (t <= 0.25)
    //   return -t * shakeDelta;
    // else if (t < 0.75)
    //   return - (t - 0.5) * shakeDelta;
    // else
    //   return -(1.0 - t) * 4.0 * shakeDelta;
    // return -t*1.2;
    if (t <= 1) {
      return pi * t / 45;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Transform.rotate(
      // transform: new Matrix4.rotationY(translateX),
      child: child,
      angle: translate,
    );
  }
}
