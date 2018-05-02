import 'dart:math';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/flash_card.dart';
import 'package:tuple/tuple.dart';

class Quiz extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Quiz(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated})
      : super(key: key);

  @override
  State createState() => new QuizState();
}

class QuizState extends State<Quiz> {
  bool _isLoading = true;
  var keys = 0;
  Tuple3<String, String, List<String>> _allques;
  int _size = 2;
  String questionText;
  String ans;
  List<String> ch;
  List<String> choice = [];
  bool isCorrect;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    choice = [];
    _allques = await fetchMultipleChoiceData(widget.gameCategoryId, 3);
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

    print("My shuffled Choices - $choice");
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        ans: this.ans,
        keys: keys++,
        onPress: () {
          if (text == ans) {
            widget.onScore(4);
            widget.onProgress(1.0);
            widget.onEnd();
            _initBoard();
            choice = [];
          } else {
            widget.onScore(-1);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    keys = 0;
    Size media = MediaQuery.of(context).size;
    double ht = media.height;
    double wd = media.width;
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
    return new LayoutBuilder(builder: (context, constraints) {
      double ht = constraints.maxHeight;
      double wd = constraints.maxWidth;
      print("My Height - $ht");
      print("My Width - $wd");
      return new Material(
          color: const Color(0xFFF8C43C),
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(ht * 0.03),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [new QuestionText(questionText, keys, ht, wd)]),
              new Padding(
                padding: new EdgeInsets.all(ht * 0.03),
              ),
              new Expanded(
                  child: new ResponsiveGridView(
                rows: _size,
                cols: _size,
                children: choice
                    .map((e) => _buildItem(j++, e))
                    .toList(growable: false),
              ))
            ],
          ));
    });
  }
}

class QuestionText extends StatefulWidget {
  final String _question;
  int keys;
  double ht, wd;
  QuestionText(this._question, this.keys, this.ht, this.wd);

  @override
  State createState() => new QuestionTextState();
}

class QuestionTextState extends State<QuestionText>
    with SingleTickerProviderStateMixin {
  Animation<double> _fontSizeAnimation;
  AnimationController _fontSizeAnimationController;

  @override
  void initState() {
    super.initState();
    _fontSizeAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    _fontSizeAnimation = new CurvedAnimation(
        parent: _fontSizeAnimationController, curve: Curves.decelerate);
    _fontSizeAnimation.addListener(() => this.setState(() {
          print(2);
        }));
    _fontSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _fontSizeAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuestionText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._question != widget._question) {
      _fontSizeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    return new Material(
      color: const Color(0xFFf8c43c),
      child: new Container(
        height: widget.ht * 0.22,
        width: widget.wd * 0.6,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(25.0),
          color: const Color(0xFF8ecd4e),
          border: new Border.all(
            color: const Color(0xFFf8c43c),
          ),
        ),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text(widget._question,
                  key: new Key('question'),
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: widget.ht > widget.wd
                          ? widget.ht * 0.06
                          : widget.wd * 0.06,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  String ans;
  MyButton({Key key, this.text, this.ans, this.keys, this.onPress})
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  int keys;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 600), vsync: this);
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
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.text != widget.text) {
      controller.reset();
      controller.forward();
    // }
    // if (oldWidget.text == null && widget.text != null) {
    //   _displayText = widget.text;
    //   // initState();
    //   // controller.forward();
    // }
    // else if (oldWidget.text != widget.text) {
    // controller.reverse();
    // }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    print("_MyButtonState.build");
    return new ScaleTransition(
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
            child: new RaisedButton(
                onPressed: () => widget.onPress(),
                color: const Color(0xFFffffff),
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text(_displayText,
                    key: new Key("${widget.keys}"),
                    style:
                        new TextStyle(color: Colors.black, fontSize: 24.0)))));
  }
}
