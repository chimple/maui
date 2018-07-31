import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

import '../components/shaker.dart';
import 'package:maui/components/gameaudio.dart';

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

enum Status { Disable, Enable, Shake, Stopped, Disabled }
enum Highlighted { NoColor, Color }
enum DisableStatus { Active, Deactivate }

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
  List<Highlighted> _highlighted = [];
  List<DisableStatus> _disableStatus = [];
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
  List<int> _status2 = [], _status3 = [], _status4 = [];
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
          (constraints.maxWidth - hPadding * 2) / 2; //- middle_spacing;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Expanded(
                child: _buildLeftSide(context, buttonPadding),
              ),
              // new Padding(
              //     padding:
              //         new EdgeInsets.symmetric(horizontal: middle_spacing)),
              new Expanded(child: _buildRightSide(context, buttonPadding)),
            ],
          ));
    });
  }

  int _constant, _constant1;
  void initState() {
    super.initState();
    leftIsTapped = 0;
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
      _status2.clear();
      _status3.clear();
      _status4.clear();
      leftIsTapped = 0;
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
        _shuffledLetters.map((a) => Status.Stopped).toList(growable: false);
    _highlighted = _shuffledLetters
        .map((a) => Highlighted.NoColor)
        .toList(growable: false);
    _disableStatus = _shuffledLetters
        .map((a) => DisableStatus.Active)
        .toList(growable: false);
    for (int i = 0; i <= _numButtons * 2 - 1; i++) {
      _status2.add(0);
    }
    for (int i = 0; i <= _numButtons * 2 - 1; i++) {
      _status3.add(0);
    }
    for (int i = 0; i <= _numButtons * 2 - 1; i++) {
      _status4.add(0);
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
              child: _buildItemsLeft(j, e, _highlighted[j], _disableStatus[j],
                  _statusColorChange[j++])))
          .toList(growable: false),
    );
  }

  Widget _buildItemsLeft(int index, String text, Highlighted _ht,
      DisableStatus _disableSt, Status colorstatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        unitMode: widget.gameConfig.questionUnitMode,
        status: colorstatus,
        highlighted: _ht,
        disableSt: _disableSt,
        onPress: () {
          indexText1 = _lettersLeft.indexOf(text);
          _leftSideText = text;
          if (_highlighted[index] != Highlighted.Color) {
            setState(() {
              _highlighted[index] = Highlighted.Color;
            });
            flag = 1;
          }
          if (_oldIndexforLeftButton != index && flag == 1) {
            setState(() {
              _highlighted[_oldIndexforLeftButton] = Highlighted.NoColor;
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
              child: _buildItemsRight(
                  j, e, _status4[j], _status3[j], _status2[j++])))
          .toList(growable: false),
    );
  }

  Widget _buildItemsRight(
      int index, String text, int status4, int status3, int status2) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        unitMode: widget.gameConfig.answerUnitMode,
        status2: status2,
        status3: status3,
        status4: status4,
        onPress: () {
          indexText2 = _lettersRight.indexOf(text);
          _rightSideText = text;
          if (_statusColorChange[indexLeftButton] !=
              Status.Shake) if (_status4[index] != 1) {
            match(index);
          }
        });
  }

  void match(int indexRightbutton) {
    if (leftIsTapped == 1 &&
            leftSideTextIndex == _rightSideLetters.indexOf(_rightSideText) ||
        identical(_rightSideText, _leftSideText)) {
      widget.onScore(4);
      correct++;

      widget.onProgress(correct / _numButtons);

      setState(() {
        _disableStatus[indexLeftButton] = DisableStatus.Deactivate;
        _status3[indexRightbutton] = 1;
      });
      leftIsTapped = 0;
    } else {
      //leftSideTextIndex = -1;
      if (leftIsTapped == 1) {
        widget.onScore(-1);
        try {
          setState(() {
            //_status2[indexRightbutton] = 1;

            _statusColorChange[indexLeftButton] = Status.Shake;
            _status2[indexRightbutton] = 1;
            _status4[indexRightbutton] = 1;
            flag1 = 1;
          });
        } catch (exception, e) {}
        try {
          new Future.delayed(const Duration(milliseconds: 700), () {
            setState(() {
              for (int i = 0; i < _numButtons; i++)
                _statusColorChange[i] = Status.Stopped;
              for (int i = 0; i <= _numButtons * 2 - 1; i++) {
                _status4[i] = 0;
                _status2[indexRightbutton] = 0;
              }
            });
          });
        } catch (exception, e) {}
        // leftIsTapped = 0;
        _wrongAttem++;
      }
    }
    if (_wrongAttem >= correct - _constant &&
        _wrongAttem == _numButtons - _constant1) {
      widget.onScore(-correct);
      new Future.delayed(const Duration(milliseconds: 0), () {
        _leftSideletters.clear();
        _rightSideLetters.clear();
        _shuffledLetters.clear();
        _shuffledLetters1.clear();
        _lettersLeft.clear();
        _lettersRight.clear();
        _status2.clear();
        _status3.clear();
        _status4.clear();
        widget.onEnd();
        _wrongAttem = 0;
        correct = 0;
        leftSideTextIndex = -1;
      });
    }

    if (correct == _numButtons) {
      //widget.onScore(-_wrongAttem);
      new Future.delayed(const Duration(milliseconds: 300), () {
        _leftSideletters.clear();
        _rightSideLetters.clear();
        _shuffledLetters.clear();
        _shuffledLetters1.clear();
        _lettersLeft.clear();
        _lettersRight.clear();
        _status2.clear();
        _status3.clear();
        _status4.clear();
        widget.onEnd();
        _wrongAttem = 0;
        correct = 0;
        leftSideTextIndex = -1;
      });
    }
    print("Correct ::$correct ");
    print("Total task:: $_numButtons");
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.unitMode,
    this.text,
    this.onPress,
    this.color,
    this.active: true,
    this.status,
    this.highlighted,
    this.disableSt,
    this.status2,
    this.status3,
    this.status4,
  }) : super(key: key);
  final String text;
  final VoidCallback onPress;
  bool active;
  Status status;
  Highlighted highlighted;
  DisableStatus disableSt;
  int status2, status3, status4;
  List<int> color;
  UnitMode unitMode;
  int flag = 0;
  @override
  createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller, controllerstatus2;

  Animation animationInvisible, animationstatus2, noAimation;

  Animation<BorderRadius> borderRadius;
  initState() {
    super.initState();
    initStateData();
  }

  initStateData() {
    super.initState();
    _displayText = widget.text;

    controllerstatus2 = new AnimationController(
        duration: new Duration(milliseconds: 50), vsync: this);

    animationstatus2 = new Tween(
      begin: 3.0,
      end: -3.0,
    ).animate(controllerstatus2);
    noAimation = new Tween(
      begin: 0.0,
      end: 0.0,
    ).animate(controllerstatus2);

    status2();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void status2() {
    controllerstatus2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerstatus2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controllerstatus2.forward();
      }
    });
    controllerstatus2.forward();
  }

  @override
  void dispose() {
    controllerstatus2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Shake(
        animation: widget.status == Status.Shake || widget.status4 == 1
            ? animationstatus2
            : noAimation,
        child: new UnitButton(
          highlighted:
              widget.highlighted == Highlighted.Color || widget.status2 == 1
                  ? true
                  : false,
          disabled: widget.disableSt == DisableStatus.Deactivate ||
              widget.status3 == 1,
          onPress: () => widget.onPress(),
          text: _displayText,
          unitMode: widget.unitMode,
        ));
  }
}
