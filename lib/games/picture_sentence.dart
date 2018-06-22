import 'dart:math';
// import 'dart:math' as math;
import 'dart:async';
// import 'package:collection/collection.dart';
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
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:meta/meta.dart';

class PictureSentence extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  GameConfig gameConfig;
  bool isRotated;

  PictureSentence(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.gameCategoryId,
      this.iteration,
      this.gameConfig,
      this.isRotated})
      : super(key: key);

  @override
  State createState() => new PictureSentenceState();
}

enum Status { Active, Right, Wrong }

class PictureSentenceState extends State<PictureSentence> {
  bool _isLoading = true;
  var keys = 0;
  int _size = 2;
  int indexOfBlank1 = 0;
  int indexOfBlank2 = 0;
  // String questionText;
  String output1 = "";
  String output2 = "";
  Color color = Colors.white;

  List<String> ans = [];
  List<String> choice = [];
  List<Status> _statuses = [];
  String sentence1;
  bool isCorrect;
  int scoretrack = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  Tuple3<String, List<String>, List<String>> picturedata;
  void _initBoard() async {
    setState(() => _isLoading = true);

    picturedata = await fetchPictureSentenceData(widget.gameCategoryId);
    print(" fectched data  >>>> $picturedata");
    sentence1 = picturedata.item1;
    ans = picturedata.item2;
    choice = picturedata.item3;
    // ans = _allques.item2;
    // print(_allques.item3);
    // ch = _allques.item3;
    // for (var x = 0; x < ch.length; x++) {
    //   choice.add(ch[x]);
    // }
    // choice.add(ans);
    print("My Choices - $choice");

    choice.shuffle();

    print("After shuffle Choices - $choice");
    // _size = min(2, sqrt(choice.length).floor());

    _statuses = choice.map((a) => Status.Active).toList(growable: false);

    // print("My shuffled Choices - $choice");
    print("My states - $_statuses");

    setState(() => _isLoading = false);
  }

  Widget _buildItem(Status status, int indexOfBlank1, String text) {
    // String buttonPressed() {
    //   output1 = ans[0];
    //   return output1;
    // }

    return new MyButton(
        key: new ValueKey<int>(indexOfBlank1),
        // unitMode: widget.gameConfig.answerUnitMode,
        status: status,
        text: text,
        ans: this.ans[0],
        keys: keys++,
        onPress: () {
          print("ans[0] >>>>> ${ans[0]}");
          print("ans[1] >>>>> ${ans[1]}");
          if (text == ans[0]) {
            output1 = ans[0];
            print(" inside condition ans[0] >>>>> ${ans[0]}");
            scoretrack = scoretrack + 4;
            widget.onScore(4);
            widget.onProgress(1.0);
            // widget.onEnd();
            // choice.removeRange(0, choice.length);
          } else if (text == ans[1]) {
            output2 = ans[1];
            scoretrack = scoretrack + 4;
            widget.onScore(4);
            widget.onProgress(1.0);
            widget.onEnd();
          } else {
            setState(() {
              _statuses[indexOfBlank1] = Status.Wrong;
            });
            new Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                _statuses[indexOfBlank1] = Status.Active;
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

  Widget sentenceLayout(String sentence) {
    List<String> split = sentence.split(" ");
    String sentencePart1 = "";
    String sentencePart2 = "";
    print(split);

    indexOfBlank1 = sentence.indexOf("1");
    int listElement1 = split.indexOf("1_");
    String subString1 = sentence.substring(0, 40);

    indexOfBlank2 = sentence.indexOf("2");
    String subString2 = sentence.substring(40, sentence.length);

    print("split[indexOfBlank1] >>>>>>> ${split[listElement1]}");
    for (int i = 0; i < listElement1; i++) {
      if (split[i] != '1_' && split[i] != '2_') {
        sentencePart1 += split[i] + " ";
      }
    }
    print("sentencePart1 >>>>>>> $sentencePart1");

    int listElement2 = split.indexOf("2_");
    for (int i = listElement1; i < listElement2; i++) {
      if (split[i] != '1_' && split[i] != '2_') {
        sentencePart2 += split[i] + " ";
      }
    }
    print("sentencePart2 >>>>>>> $sentencePart2");

    var text1 = new Text(sentencePart1,
        softWrap: true,
        style: new TextStyle(
            fontWeight: FontWeight.bold, color: color, fontSize: 40.0));

    var blankSpace1 = (output1 == "")
        ? new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Stack(children: [
              new Container(
                child: new Text(""),
                color: Colors.grey,
                height: 40.0,
                width: 200.0,
              ),
              new Positioned(
                right: 1.0,
                child: new IconButton(
                  iconSize: 24.0,
                  color: Colors.black,
                  icon: new Icon(Icons.announcement),
                  tooltip: 'check the picture',
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: new FractionallySizedBox(
                            heightFactor: 0.5,
                            widthFactor: 0.8,
                            child: new PictureCard(
                              text: "widget.text",
                              image: "assets/dict/mountain.png",
                            )));
                  },
                ),
              ),
            ]),
          )
        : new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Container(
                alignment: Alignment.bottomLeft,
                child: new Text(output1,
                    softWrap: true,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 40.0))),
          );

    var text2 = new Text(sentencePart2,
        softWrap: true,
        style: new TextStyle(
            fontWeight: FontWeight.bold, color: color, fontSize: 40.0));

    var blankSpace2 = (output2 == "")
        ? new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Stack(children: [
              new Container(
                child: new Text(""),
                color: Colors.grey,
                height: 40.0,
                width: 200.0,
              ),
              new Positioned(
                right: 1.0,
                child: new IconButton(
                  iconSize: 24.0,
                  color: Colors.black,
                  icon: new Icon(Icons.announcement),
                  tooltip: 'check the picture',
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: new FractionallySizedBox(
                            heightFactor: 0.5,
                            widthFactor: 0.8,
                            child: new PictureCard(
                              text: "widget.text",
                              image: "assets/dict/earth.png",
                            )));
                  },
                ),
              ),
            ]),
          )
        : new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Container(
                alignment: Alignment.bottomLeft,
                child: new Text(output2,
                    softWrap: true,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 40.0))),
          );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[text1, blankSpace1],
        ),
        new Row(
          children: <Widget>[text2, blankSpace2],
        )
      ],
    );
  }

  @override
  void didUpdateWidget(PictureSentence oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  @override
  Widget build(BuildContext context) {
    keys = 0;

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
                child: sentenceLayout(sentence1)),
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
            // unitMode: widget.unitMode,
          ),
        ));
  }
}

class PictureCard extends StatefulWidget {
  final String text;
  final String image;

  PictureCard({Key key, @required this.text, this.image}) : super(key: key);

  @override
  _PictureCardState createState() {
    return new _PictureCardState();
  }
}

class _PictureCardState extends State<PictureCard> {
  Unit _unit;
  bool _isLoading = true;

  int i;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _unit = await new UnitRepo().getUnit(widget.text);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new LayoutBuilder(builder: (context, constraints) {
      return new Card(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.all(
                Radius.circular(constraints.maxHeight * 0.02))),
        child: new Container(
            width: 200.0,
            height: 200.0,
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    fit: BoxFit.fill, image: new AssetImage(widget.image)))),
      );
    });
  }
}
