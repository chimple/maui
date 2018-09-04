import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/gameaudio.dart';

class TrueFalseGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  TrueFalseGame(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated})
      : super(key: key);

  @override
  State createState() => new TrueFalseGameState();
}

enum Status { Active, Right, Wrong }

class TrueFalseGameState extends State<TrueFalseGame> {
  bool _isLoading = true;

  Tuple3<String, String, bool> _allques;
  String questionText, answerText;
  bool tf;
  bool isCorrect;
  bool overlayShouldBeVisible = false;
  int scoretrack = 0;
  List<String> choice = [];
  List<Status> _statuses = [];
  String ans;
  var keys = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allques = await fetchTrueOrFalse(widget.gameConfig.gameCategoryId);
    print("this is my data  $_allques");
    print(_allques.item1);
    questionText = _allques.item1;
    print(_allques.item2);
    answerText = _allques.item2;
    print(_allques.item3);
    tf = _allques.item3;
    choice = ['true', 'false'];
    _statuses = choice.map((a) => Status.Active).toList(growable: false);
    ans = tf == true ? 'true' : 'false';
    setState(() => _isLoading = false);
  }

  Widget _buildItem(Status status, int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        unitMode: widget.gameConfig.answerUnitMode,
        text: text,
        status: status,
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
  void didUpdateWidget(TrueFalseGame oldWidget) {
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
    print("Answer here $tf");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    final maxChars = (choice != null
        ? choice.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);
    int j = 0;
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
          new Column(
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                new Material(
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    child: new LimitedBox(
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                        child: new Material(
                            color: Theme.of(context).accentColor,
                            elevation: 4.0,
                            textStyle: new TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: buttonConfig.fontSize),
                            child: new Container(
                                padding: EdgeInsets.all(buttonPadding),
                                child: new Center(
                                  child: new UnitButton(
                                    text: "$questionText",
                                    primary: true,
                                    unitMode:
                                        widget.gameConfig.questionUnitMode,
                                  ),
                                ))))),
                new Material(
                  color: Theme.of(context).accentColor,
                  elevation: 8.0,
                  child: new LimitedBox(
                      maxHeight: maxHeight,
                      maxWidth: maxWidth,
                      child: new Material(
                          color: Theme.of(context).accentColor,
                          elevation: 4.0,
                          textStyle: new TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: buttonConfig.fontSize),
                          child: new Container(
                              padding: EdgeInsets.all(buttonPadding),
                              child: new Center(
                                child: new UnitButton(
                                  text: "$answerText",
                                  primary: true,
                                  unitMode: widget.gameConfig.questionUnitMode,
                                ),
                              )))),
                )
              ]),
          new Expanded(
              child: new ResponsiveGridView(
            rows: 1,
            cols: 2,
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

    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
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
    Size media = MediaQuery.of(context).size;
    double ht = media.height;
    double wd = media.width;
    widget.keys++;
    print("_MyButtonState.build");
    return new Shake(
        animation: widget.status == Status.Wrong ? wrongAnimation : animation,
        child: new ScaleTransition(
            scale: animation,
            child: new GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      child: new FractionallySizedBox(
                          heightFactor: 0.5,
                          widthFactor: 0.8,
                          child: new FlashCard(text: widget.text)));
                },
                // child: new UnitButton(
                //   onPress: () => widget.onPress(),
                //   text: _displayText,
                //   unitMode: widget.unitMode,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(20.0),
                    border: new Border.all(
                      width: 6.0,
                      color: _displayText == 'true' ? Colors.green : Colors.red,
                    ),
                  ),
                  child: new FlatButton(
                      onPressed: () => widget.onPress(),
                      color: Colors.transparent,
                      shape: new RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(8.0))),
                      child: new Icon(
                        _displayText == 'true' ? Icons.check : Icons.close,
                        key: new Key("${widget.keys}"),
                        size: ht > wd ? ht * 0.15 : wd * 0.15,
                        color:
                            _displayText == 'true' ? Colors.green : Colors.red,
                      )),
                ))));
  }
}
