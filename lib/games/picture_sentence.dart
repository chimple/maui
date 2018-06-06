import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:flutter/animation.dart';

class PictureSentence extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  PictureSentence(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated})
      : super(key: key);

  @override
  State createState() => new PictureSentenceState();
}

enum Status { Active, Right, Wrong }

class PictureSentenceState extends State<PictureSentence> with SingleTickerProviderStateMixin {
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
 Animation animation;
 AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController= AnimationController(duration: Duration(milliseconds: 3000),vsync: this);
    animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animationController.reverse();
      }
      else if (status == AnimationStatus.dismissed){
        animationController.forward();
      }
    });
    animation = Tween(begin: 0.0, end: 1000.0).animate(animationController);
    animationController.forward();
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
  void didUpdateWidget(PictureSentence oldWidget) {
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

      double maxWidth = (constraints.maxWidth - hPadding * 2) / 3;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 5;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

      double ht = constraints.maxHeight;
      double wd = constraints.maxWidth;
      print("My Height - $ht");
      print("My Width - $wd");
      return new Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Material(
                color: Theme.of(context).accentColor,
                elevation: 4.0,
                child: new LimitedBox(
                    maxHeight: maxHeight,
                    maxWidth: double.infinity,
                    child: new Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      textBaseline: TextBaseline.ideographic,
                      children: <Widget>[
                        new Text("Which is the highest",
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 40.0)),
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Stack(children: [
                            new Container(
                              color: Colors.grey,
                              height: 40.0,
                              width: 100.0,
                            ),
                            new IconButton(
                              iconSize: 24.0,
                              color: Colors.black,
                              icon: new Icon(Icons.comment),
                              tooltip: 'check the picture',
                              onPressed: () {
                                
                                // PictureAnimation( ,
                                //    animation);
                              },
                            ),
                          ]),
                        ),
                        new Text(
                          "in the  ",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              color: Colors.black),
                        ),
                        new Container(
                          color: Colors.grey,
                          height: 40.0,
                          width: 100.0,
                        ),
                      ],
                    ))),
          ),
          new Expanded(
            flex: 1,
            child: new Container(
                width: 200.0,
                height: 200.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/dict/mountain.png')))),
          ),
          new Expanded(
              flex: 2,
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
@override
void dispose()
{
  animationController.dispose();
  super.dispose();
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
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
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
              child: new UnitButton(
                onPress: () => widget.onPress(),
                text: _displayText,
                unitMode: widget.unitMode,
              ),
            )));
  }
}

class PictureAnimation extends AnimatedWidget {
  PictureAnimation(Key key,Animation animation)
      : super( key: key ,listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Center(
      child: Container(
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}
