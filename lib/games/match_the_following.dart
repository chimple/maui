import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

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

enum Status { Disable, Enable, Shake, Stopped }

class _MatchTheFollowingState extends State<MatchTheFollowing>
    with SingleTickerProviderStateMixin {
  final double middle_spacing = 50.0;
  int c = 0;
  int start = 0, increament = 0;
  List<String> _leftSideletters = [];
  List<String> _rightSideLetters = [];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  List<Status> _statusColorChange = [];
  Map<String, String> _allLetters;
  String _leftSideText, _rightSideText;
  final int score = 2;
  int indexText1, indexText2, indexLeftButton;
  int _oldIndexforLeftButton = 0,
      _numButtons,
      leftIsTapped = 0,
      leftSideTextIndex = 0;
  bool _isLoading = true;
  int indexL, flag = 0, flag1 = 0, correct = 0, _wrongAttem = 0;
  List<int> _shake = [];
  String loading = 'Loading...';
  int c1 = 0;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
        child: new Text(
          loading,
          style: new TextStyle(fontSize: 40.0, color: Colors.green),
        ),
      );
    }

    var maxChars = (_leftSideletters != null
        ? _leftSideletters.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);

    maxChars = (_rightSideLetters != null
        ? _rightSideLetters.fold(maxChars,
            (prev, element) => element.length > prev ? element.length : prev)
        : 1);
    print("MaxChar value:: $maxChars");
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth =
          (constraints.maxWidth - hPadding * 2) / 2 - middle_spacing;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / _numButtons;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

      return new Container(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: _buildLeftSide(context, buttonPadding),
              ),
              new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: middle_spacing)),
              new Expanded(child: _buildRightSide(context, buttonPadding)),
            ],
          ));
    });
  }

  int _constant, _constant1;
  void initState() {
    super.initState();
    print("initState called::");
    if (widget.gameConfig.level < 4) {
      print("level <4");
      _numButtons = 2;
      _constant = 0;
      _constant1 = 0;
    } else if (widget.gameConfig.level < 6) {
      print("level <8");
      _numButtons = 4;
      _constant = 0;
      _constant1 = 1;
    } else {
      print("level <10");
      _numButtons = 6;
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
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _leftSideletters.clear();
      _rightSideLetters.clear();
      _shuffledLetters.clear();
      _shuffledLetters1.clear();
      _lettersLeft.clear();
      _lettersRight.clear();
      _shake.clear();
      _initBoard();
    }
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    print('initBoard $_numButtons');
    _allLetters =
        await fetchPairData(widget.gameConfig.gameCategoryId, _numButtons);
    _allLetters.forEach((k, v) {
      _leftSideletters.add(k);
      _rightSideLetters.add(v);
    });
    _shuffledLetters.addAll(
        _leftSideletters.take(_numButtons).toList(growable: false)..shuffle());
    _shuffledLetters1.addAll(
        _rightSideLetters.take(_numButtons).toList(growable: false)..shuffle());
    _lettersLeft = _shuffledLetters.sublist(0, _numButtons);
    _lettersRight = _shuffledLetters1.sublist(0, _numButtons);
    _statusColorChange =
        _shuffledLetters.map((a) => Status.Disable).toList(growable: false);
    for (int i = 0; i <= _numButtons * 2 - 1; i++) {
      _shake.add(0);
    }
    setState(() => _isLoading = false);
    print("All data :: $_allLetters");
  }

  Widget _buildLeftSide(BuildContext context, double buttonPadding) {
    int j = 0;
    return new ResponsiveGridView(
      rows: _numButtons,
      cols: 1,
      children: _lettersLeft
          .map((e) => Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: _buildItemsLeft(j, e, _statusColorChange[j++])))
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
          _oldIndexforLeftButton = index;
          indexLeftButton = index;
          leftIsTapped = 1;
          leftSideTextIndex = _leftSideletters.indexOf(_leftSideText);
        });
  }

  Widget _buildRightSide(BuildContext context, double buttonPadding) {
    int j = _numButtons;
    return new ResponsiveGridView(
      rows: _numButtons,
      cols: 1,
      padding: 4.0,
      maxAspectRatio: 1.3,
      children: _lettersRight
          .map((e) => Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: _buildItemsRight(j, e, _shake[j++])))
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
      setState(() {
        _shake[indexRightbutton] = 1;
      });
      correct++;
      widget.onScore(1);
      widget.onProgress(correct / _numButtons);
      leftIsTapped = 0;
      new Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _statusColorChange[_oldIndexforLeftButton] = Status.Disable;
        });
      });
    } else {
      leftSideTextIndex = -1;
      if (leftIsTapped == 1) {
        widget.onScore(-1);
        try {
          setState(() {
            _shake[indexRightbutton] = 1;
            _statusColorChange[indexLeftButton] = Status.Shake;
            _shake[indexRightbutton] = 2;
            flag1 = 1;
          });
        } catch (exception, e) {}
        try {
          new Future.delayed(const Duration(milliseconds: 700), () {
            setState(() {
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
        _wrongAttem == _numButtons - _constant1) {
      _wrongAttem = 0;
      widget.onScore(-correct);
      correct = 0;
      new Future.delayed(const Duration(milliseconds: 700), () {
        widget.onEnd();
      });
    }

    if (correct == _numButtons) {
      _wrongAttem = 0;
      correct = 0;
      widget.onScore(-_wrongAttem);
      new Future.delayed(const Duration(milliseconds: 1000), () {
        _leftSideletters.clear();
        _rightSideLetters.clear();
        _shuffledLetters.clear();
        _shuffledLetters1.clear();
        _lettersLeft.clear();
        _lettersRight.clear();
        _shake.clear();
        widget.onEnd();
      });
    }
    print("Correct ::$correct ");
    print("Total task:: $_numButtons");
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
        setState(() => _displayText = widget.text);
      }
    });
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
        } else if (status == AnimationStatus.dismissed) {}
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
    return new Shake(
        animation: widget.status == Status.Shake || widget.shake == 2
            ? animationShake
            : noAimation,
        child: new ScaleTransition(
          scale:
              widget.status == Status.Enable ? buttonPress : animationInvisible,
          child: new UnitButton(
            disabled: widget.status == Status.Disable || widget.shake == 0
                ? false
                : true,
            onPress: (widget.status == Status.Disable || widget.shake == 0)
                ? () => widget.onPress()
                : null,
            text: _displayText,
            unitMode: UnitMode.text,
          ),
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
