import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/db/entity/user.dart';

class ScoreScreen extends StatefulWidget {
  final String gameName;
  final GameDisplay gameDisplay;
  final User myUser;
  final User otherUser;
  final int myScore;
  final int otherScore;
  final List<Widget> otherscore;
  final bool isGameOver;

  ScoreScreen(
      {Key key,
      this.gameName,
      this.gameDisplay,
      this.myUser,
      this.otherUser,
      this.isGameOver = true,
      this.myScore,
      this.otherScore})
      : super(key: key);

  @override
  _ScoreScreenState createState() => new _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
    with TickerProviderStateMixin {
  AnimationController controller, buttoncontroller;

  List<AnimationController> _controllers = new List<AnimationController>();
  List<Animation<double>> _animations = new List<Animation<double>>();

  Animation<double> _buttonAnimation, _characterAnimation;

  String gameName;
  GameDisplay gameDisplay;
  User myUser;
  User otherUser;
  int myScore;
  int otherScore;
  List<Widget> otherscore;
  List<String> mystars = [];
  List<String> otherstars = [];
  bool flag = false;

  var keys = 0;

  @override
  void initState() {
    // TODO: implement initState

    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    buttoncontroller = new AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _buttonAnimation = new CurvedAnimation(
        parent: buttoncontroller, curve: Curves.bounceInOut);
    _characterAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    // _buttonAnimation = new Tween(begin: 0.0, end: 0.0).animate(
    //     new CurvedAnimation(
    //         parent: controller,
    //         curve: new Interval(0.100, 0.400, curve: Curves.elasticOut)));
    // _textAnimation = new Tween(begin: 0.0, end: 0.0).animate(
    //     new CurvedAnimation(
    //         parent: controller,
    //         curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));

    gameName = widget.gameName;
    gameDisplay = widget.gameDisplay;
    myScore = widget.myScore;
    myUser = widget.myUser;
    otherScore = widget.otherScore;
    otherscore = widget.otherscore;
    otherUser = widget.otherUser;

    for (var i = 0; i < 3; i++) {
      myScore > (13 * i) ? mystars.add("true") : mystars.add("false");
    }
    for (var i = 0; i < 3; i++) {
      otherScore > (13 * i) ? otherstars.add("true") : otherstars.add("false");
    }

    for (var i = 0; i < 3; i++) {
      final _controller = new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 500));
      _controllers.add(_controller);
      _animations.add(
          new CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
      new Future.delayed(Duration(milliseconds: 1000 + (i) * 150), () {
        _controller.forward();
      });
      if (i == 2) {
        print("this ois kvkkv $i");
        flag = true;
      }
    }

    new Future.delayed(Duration(milliseconds: 2000), () {
      buttoncontroller.forward();
    });

    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((f) => f.dispose());
    controller.dispose();
    super.dispose();
  }

  Widget _buildItem(int index, String text, double ht, double wd) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        keys: keys++,
        height: ht,
        width: wd,
        onPress: () {});
  }

  Future<bool> _onWillPop() {
    Navigator.of(context).popUntil(ModalRoute.withName('/tab'));
    var completer = Completer<bool>();
    completer.complete(false);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    int j = 0;
    int k = 0;

    List<Widget> tablestars1 = new List<Widget>();
    List<Widget> tablestars2 = new List<Widget>();
    final _colors = SingleGame.gameColors[widget.gameName];
    final color = _colors != null ? _colors[0] : Colors.amber;

    print(
        "gmaeName: $gameName...gameDisplay: $gameDisplay...myUser: $myUser...otherUser: $otherUser...myScore:$myScore...otherScore: $otherScore...otherscore: $otherscore");
    List<Widget> scores = [
      new Expanded(
          flex: 1,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new UserItem(user: myUser),
                new Text('$myScore')
              ]))
    ];
    if (otherUser != null) {
      scores.add(new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new UserItem(user: otherUser),
            new Text('$otherScore')
          ]));
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new LayoutBuilder(builder: (context, constraints) {
        print("flag = $flag");
        double ht = constraints.maxHeight;
        double wd = constraints.maxWidth;

        List<Widget> starsMap1 = mystars
            .map(
              (e) => _buildItem(j++, e, ht, wd),
            )
            .toList(growable: false);

        List<Widget> starsMap2 = otherstars
            .map(
              (e) => _buildItem(k++, e, ht, wd),
            )
            .toList(growable: false);
        for (var i = 0; i < 3; i++) {
          tablestars1.add(
              new ScaleTransition(scale: _animations[i], child: starsMap1[i]));
        }

        for (var l = 0; l < 3; l++) {
          tablestars2.add(
              new ScaleTransition(scale: _animations[l], child: starsMap2[l]));
        }

        return new Scaffold(
            backgroundColor: color,
            body: new SafeArea(
                child: new Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new ScaleTransition(
                  scale: _characterAnimation,
                  child: new Container(
                    height: ht > wd ? ht * 0.15 : wd * 0.13,
                    child: new Image(
                      image: new AssetImage("assets/hoodie/$gameName.png"),
                    ),
                  ),
                ),

                new Row(
                  mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ||
                          gameDisplay == GameDisplay.networkTurnByTurn ||
                          gameDisplay == GameDisplay.localTurnByTurn
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        height: ht > wd ? ht * 0.19 : wd * 0.15,
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new LimitedBox(
                                maxHeight: ht * 0.13,
                                child: new UserItem(user: myUser),
                              ),
                              new Text(
                                '$myScore',
                                style: new TextStyle(
                                    fontSize: ht > wd ? ht * 0.05 : wd * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ])),
                    gameDisplay == GameDisplay.myHeadToHead ||
                            gameDisplay == GameDisplay.networkTurnByTurn ||
                            gameDisplay == GameDisplay.localTurnByTurn
                        ? new Container(
                            height: ht > wd ? ht * 0.19 : wd * 0.15,
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new LimitedBox(
                                    maxHeight: ht * 0.13,
                                    child: new UserItem(user: otherUser),
                                  ),
                                  new Text(
                                    '$otherScore',
                                    style: new TextStyle(
                                        fontSize:
                                            ht > wd ? ht * 0.05 : wd * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ]))
                        : new Row()
                  ],
                ),

                //Stars Being Displayed according to the score
                new ScaleTransition(
                  scale: _characterAnimation,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment:
                              gameDisplay == GameDisplay.myHeadToHead ||
                                      gameDisplay ==
                                          GameDisplay.networkTurnByTurn ||
                                      gameDisplay == GameDisplay.localTurnByTurn
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Row(
                                mainAxisAlignment:
                                    gameDisplay == GameDisplay.myHeadToHead ||
                                            gameDisplay ==
                                                GameDisplay.networkTurnByTurn ||
                                            gameDisplay ==
                                                GameDisplay.localTurnByTurn
                                        ? MainAxisAlignment.center
                                        : MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: tablestars1),
                            new Padding(
                              padding: new EdgeInsets.all(10.0),
                            ),
                            gameDisplay == GameDisplay.myHeadToHead ||
                                    gameDisplay ==
                                        GameDisplay.networkTurnByTurn ||
                                    gameDisplay == GameDisplay.localTurnByTurn
                                ? new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: tablestars2)
                                : new Row(),
                          ]),
                      new Row(
                          mainAxisAlignment:
                              gameDisplay == GameDisplay.myHeadToHead ||
                                      gameDisplay ==
                                          GameDisplay.networkTurnByTurn ||
                                      gameDisplay == GameDisplay.localTurnByTurn
                                  ? MainAxisAlignment.spaceAround
                                  : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Row(
                                mainAxisAlignment:
                                    gameDisplay == GameDisplay.myHeadToHead ||
                                            gameDisplay ==
                                                GameDisplay.networkTurnByTurn ||
                                            gameDisplay ==
                                                GameDisplay.localTurnByTurn
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                crossAxisAlignment:
                                    gameDisplay == GameDisplay.myHeadToHead ||
                                            gameDisplay ==
                                                GameDisplay.networkTurnByTurn ||
                                            gameDisplay ==
                                                GameDisplay.localTurnByTurn
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    myScore < 13
                                        ? "Poor"
                                        : myScore >= 13 && myScore < 26
                                            ? "Good"
                                            : myScore >= 26 && myScore < 39
                                                ? "Very Good"
                                                : "Excellent",
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: ht > wd ? ht * 0.05 : wd * 0.04,
                                    ),
                                  )
                                ]),
                            gameDisplay == GameDisplay.myHeadToHead ||
                                    gameDisplay ==
                                        GameDisplay.networkTurnByTurn ||
                                    gameDisplay == GameDisplay.localTurnByTurn
                                ? new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                        new Text(
                                          otherScore < 13
                                              ? "Poor"
                                              : otherScore >= 13 &&
                                                      otherScore < 26
                                                  ? "Good"
                                                  : otherScore >= 26 &&
                                                          otherScore < 39
                                                      ? "Very Good"
                                                      : "Excellent",
                                          style: new TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                ht > wd ? ht * 0.05 : wd * 0.04,
                                          ),
                                        )
                                      ])
                                : new Row(),
                          ]),
                    ],
                  ),
                ),

                // Icons which redirect to home, refresh and fast-forward
                new ScaleTransition(
                    scale: buttoncontroller,
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            icon: new Image.asset("assets/home_button.png"),
                            iconSize: ht > wd ? ht * 0.1 : wd * 0.08,
                            onPressed: () {
                              if (flag == true) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                print(" hi ");
                              }
                            }),
                        IconButton(
                            icon: new Image.asset("assets/forward_button.png"),
                            iconSize: ht > wd ? ht * 0.1 : wd * 0.08,
                            onPressed: () {
                              if (flag == true) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                print(" forwAARS ");
                              }
                            }),
                      ],
                    )),

                ht > wd
                    ? new Padding(
                        padding: new EdgeInsets.all(ht * 0.001),
                      )
                    : new Padding(padding: new EdgeInsets.all(0.0)),
              ],
            )));
      }),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key, this.text, this.keys, this.height, this.width, this.onPress})
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  double height, width;
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
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size media = MediaQuery.of(context).size;
    double ht = widget.height;
    double wd = widget.width;
    widget.keys++;
    print("_MyButtonState.build");
    print("star height - $ht");
    print("star width - $wd");
    return new Shake(
        animation: animation,
        child: new IconButton(
          icon: _displayText == "true"
              ? new Image.asset("assets/star_gained.png")
              : new Image.asset("assets/star.png"),
          key: new Key("${widget.keys}"),
          iconSize: ht > wd ? wd * 0.1 : wd * 0.05,
          color: Colors.black,
          onPressed: () {},
        ));
  }
}
// (ht > 1080 ? ht * 0.06 : (ht < 600 ? ht * 0.007 : ht * 0.01))
