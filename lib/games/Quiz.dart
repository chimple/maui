import 'dart:math';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/gameaudio.dart';

class Quiz extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Quiz(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated})
      : super(key: key);

  @override
  State createState() => new QuizState();
}

enum Status { Active, Right, Wrong }

class QuizState extends State<Quiz> {
  bool _isLoading = true;
  var keys = 0;
  Tuple3<String, String, List<String>> _allques;
  int _size = 2;
  String questionText;
  String ans;
  List<String> ch;
  List<String> choice = [];
  List<Status> _statuses = [];
  bool isCorrect;
  int scoretrack = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    choice = [];
    _allques =
        await fetchMultipleChoiceData(widget.gameConfig.gameCategoryId, 3);
    print("this is my data  $_allques");
    print(_allques.item1);
    questionText = _allques.item1;
    print(_allques.item2);
    ans = _allques.item2;
    print(_allques.item3);
    ch = _allques.item3;
    for (var x = 0; x < ch.length; x++) {
      choice.add(ch[x]);
    }
    choice.add(ans);
    print("My Choices - $choice");

    choice.shuffle();
    _size = min(2, sqrt(choice.length).floor());

    _statuses = choice.map((a) => Status.Active).toList(growable: false);

    print("My shuffled Choices - $choice");
    print("My states - $_statuses");

    setState(() => _isLoading = false);
  }

  Widget _buildItem(Status status, int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        unitMode: widget.gameConfig.answerUnitMode,
        status: status,
        text: text,
        ans: this.ans,
        keys: keys++,
        onPress: () {
          if (text == ans) {
            scoretrack = scoretrack + 4;
            widget.onScore(4);
            widget.onProgress(1.0);
            widget.onEnd();
            choice.removeRange(0, choice.length);
          } else {
            setState(() {
              _statuses[index] = Status.Wrong;
            });
            new Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                _statuses[index] = Status.Active;
              });
            });
            if (scoretrack > 0) {
              scoretrack = scoretrack - 1;
              widget.onScore(-1);
            } else {
              widget.onScore(0);
            }
          }
        });
  }

  @override
  void didUpdateWidget(Quiz oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print(_allques);
    }
  }

  @override
  Widget build(BuildContext context) {
    keys = 0;
    print("Question text here $questionText");
    print("Answer here $ans");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    int j = 0;
    final maxChars = (choice != null
        ? choice.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);

    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / 2;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 3;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;

      double ht = constraints.maxHeight;
      double wd = constraints.maxWidth;
      print("My Height - $ht");
      print("My Width - $wd");
      return new Column(
        children: <Widget>[
          new Material(
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              child: new LimitedBox(
                  maxHeight: maxHeight,
                  child: new Center(
                    child: new Text(questionText,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: buttonConfig.fontSize)),
                  ))),
          new Expanded(
              child: new ResponsiveGridView(
            rows: _size,
            cols: _size,
            children: choice
                .map((e) => new Padding(
                      padding: EdgeInsets.all(buttonPadding),
                      child: _buildItem(_statuses[j], j++, e),
                    ))
                .toList(growable: false),
          ))
        ],
      );
    });
  }
}

class MyButton extends StatefulWidget {
  String ans;
  Status status;
  UnitMode unitMode;
  MyButton(
      {Key key,
      this.status,
      this.text,
      this.ans,
      this.keys,
      this.unitMode,
      this.onPress})
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  int keys;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, wrongController;
  Animation<double> animation, wrongAnimation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;

    controller = new AnimationController(
        duration: new Duration(milliseconds: 600), vsync: this);
    wrongController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);

    animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticOut)
          ..addStatusListener((state) {
//        print("$state:${animation.value}");
            if (state == AnimationStatus.dismissed) {
              // print('dismissed');
              // if (widget.text != null) {
              //   setState(() => _displayText = widget.text);
              //   controller.forward();
              // }
            }
          });
    wrongAnimation = new Tween(begin: -8.0, end: 10.0).animate(wrongController);
    controller.forward();
    _myAnim();
  }

  void _myAnim() {
    wrongAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        wrongController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        wrongController.forward();
      }
    });
    wrongController.forward();
  }

  @override
  void dispose() {
    wrongController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    print("_MyButtonState.build");
    return new Shake(
        animation: widget.status == Status.Wrong ? wrongAnimation : animation,
        child: new GestureDetector(
          onLongPress: () {
            showDialog(
                context: context,
                child: new FractionallySizedBox(
                    heightFactor: 0.5,
                    widthFactor: 0.8,
                    child: new FlashCard(text: widget.text)));
          },
          child: new UnitButton(
            onPress: () => widget.onPress(),
            text: _displayText,
            unitMode: widget.unitMode,
//                child: new RaisedButton(
//                    onPressed: () => widget.onPress(),
//                    color: const Color(0xFFffffff),
//                    shape: new RoundedRectangleBorder(
//                        borderRadius:
//                        const BorderRadius.all(const Radius.circular(8.0))),
//                    child: new Text(_displayText,
//                        key: new Key("${widget.keys}"),
//                        style:
//                        new TextStyle(color: Colors.black, fontSize: 24.0))
          ),
        ));
  }
}
