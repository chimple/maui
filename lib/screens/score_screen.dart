import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/nima.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/log_repo.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';

class ScoreScreen extends StatefulWidget {
  final String gameName;
  final GameDisplay gameDisplay;
  final User myUser;
  final User otherUser;
  final int myScore;
  final int otherScore;
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
  AnimationController controller, buttoncontroller, sparklesAnimationController;

  List<AnimationController> _controllers = new List<AnimationController>();
  List<Animation<double>> _animations = new List<Animation<double>>();

  Animation<double> _buttonAnimation, _characterAnimation, sparklesAnimation;

  String gameName;
  GameDisplay gameDisplay;
  User myUser;
  User otherUser;
  int myScore;
  int otherScore;
  List<String> mystars = [];
  List<String> otherstars = [];
  bool flag = false;
  double _sparklesAngle = 0.0;
  Random random;
  var currentAngle, sparklesWidget, firstAngle, sparkleRadius, sparklesOpacity;
  var keys = 0;
  var _cumulativeIncrement = 0;
  bool _pageExited = false;

  @override
  void initState() {
    // TODO: implement initState
    random = new Random();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    buttoncontroller = new AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _buttonAnimation =
        new CurvedAnimation(parent: buttoncontroller, curve: Curves.easeOut);
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
    sparklesAnimationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    sparklesAnimation = new CurvedAnimation(
        parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener(() {
      setState(() {});
    });

    gameName = widget.gameName;
    gameDisplay = widget.gameDisplay;
    myScore = widget.myScore;
    myUser = widget.myUser;
    otherScore = widget.otherScore;
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

    new Future.delayed(Duration(milliseconds: 50), () {
      buttoncontroller.forward();
    });

    super.initState();
    controller.forward();
    sparklesAnimationController.forward(from: 0.0);
    _sparklesAngle = random.nextDouble() * (2 * pi);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((f) => f.dispose());
    controller.dispose();
    buttoncontroller.dispose();

    sparklesAnimationController.dispose();
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
    final textcolor = _colors[1] == Color(0xFFFAFAFA) ||
            _colors[1] == Color(0xFFFFF1B8) ||
            _colors[1] == Color(0xFF9b671b) ||
            _colors[1] == Color(0xFF75F2F2)
        ? Colors.black
        : _colors[1];

    print(
        "gmaeName: $gameName...gameDisplay: $gameDisplay...myUser: $myUser...otherUser: $otherUser...myScore:$myScore...otherScore: $otherScore");
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
    if (myScore < otherScore) {
      _cumulativeIncrement -= 1;
    } else if (myScore == otherScore || myScore > otherScore) {
      _cumulativeIncrement += 1;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: new LayoutBuilder(builder: (context, constraints) {
        print("flag = $flag");
        double ht = constraints.maxHeight;
        double wd = constraints.maxWidth;

        Widget getScoreButton() {
          var stackChildren = <Widget>[];
          firstAngle = _sparklesAngle;
          sparkleRadius = (sparklesAnimationController.value * .25);
          sparklesOpacity = (1 - sparklesAnimation.value);

          for (int i = 0; i < 5; ++i) {
            var currentAngle = (firstAngle + ((2 * pi) / 5) * (i));
            var sparklesWidget =
                // new Positioned(child:
                new Transform.rotate(
                    angle: currentAngle - pi / 2,
                    child: new Opacity(
                        opacity: sparklesOpacity,
                        child: new Image.asset(
                          "images/sparkles.png",
                          width: 50.0,
                          height: 50.0,
                        ))
                    // ),
                    // left:(sparkleRadius*cos(currentAngle)) + 20,
                    // top: (sparkleRadius* sin(currentAngle)) + 20 ,
                    );
            stackChildren.add(sparklesWidget);
          }
          stackChildren.add(new Container(
              decoration: new ShapeDecoration(
                shape: new CircleBorder(side: BorderSide.none),
              ),
              child: new Center(
                  child: new Text(
                myScore > otherScore
                    ? Loca.of(context).youWon
                    : myScore == otherScore
                        ? Loca.of(context).tie
                        : Loca.of(context).youLoose,
                style: new TextStyle(
                    color: textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: ht > wd ? ht * 0.04 : wd * 0.05),
              ))));

          var widget = new Positioned(
              child: new Stack(
            alignment: FractionalOffset.center,
            overflow: Overflow.visible,
            children: stackChildren,
          ));
          return widget;
        }

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
                      child: Nima(
                          pageExited: _pageExited,
                          name: widget.gameName,
                          score: _cumulativeIncrement,
                          tag: gameDisplay != GameDisplay.myHeadToHead
                              ? 'assets/hoodie/${widget.gameName}.png'
                              : 'other.png')
//                    new Image(
//                      image: new AssetImage("assets/hoodie/$gameName.png"),
//                    ),

                      ),
                ),

                new Row(
                  mainAxisAlignment: gameDisplay == GameDisplay.myHeadToHead ||
                          gameDisplay == GameDisplay.networkTurnByTurn ||
                          gameDisplay == GameDisplay.localTurnByTurn
                      ? MainAxisAlignment.spaceEvenly
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
                            ])),
                    gameDisplay == GameDisplay.myHeadToHead ||
                            gameDisplay == GameDisplay.networkTurnByTurn ||
                            gameDisplay == GameDisplay.localTurnByTurn
                        ? new Container(
                            child: new Text(
                                widget.isGameOver == true
                                    ? Loca.of(context).gameOver
                                    : Loca.of(context).waitingForTurn,
                                style: new TextStyle(
                                    fontSize: ht > wd ? wd * 0.06 : wd * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: textcolor)))
                        : new Row(),
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
                                ]))
                        : new Row()
                  ],
                ),

                new Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    new Padding(
                        padding: new EdgeInsets.all(
                            ht > wd ? ht * 0.02 : wd * 0.025),
                        child: new Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(50.0),
                              border: new Border.all(
                                width: 6.0,
                                color: Colors.white,
                              ),
                            ),
                            child: new Row(
                              mainAxisAlignment: gameDisplay ==
                                          GameDisplay.myHeadToHead ||
                                      gameDisplay ==
                                          GameDisplay.networkTurnByTurn ||
                                      gameDisplay == GameDisplay.localTurnByTurn
                                  ? MainAxisAlignment.spaceAround
                                  : MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    //Current user's score
                                    new Text(
                                      '$myScore',
                                      style: new TextStyle(
                                          fontSize:
                                              ht > wd ? ht * 0.05 : wd * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: textcolor),
                                    )
                                  ],
                                ),

                                //text added so as to align score according to the image of the user above
                                gameDisplay == GameDisplay.myHeadToHead ||
                                        gameDisplay ==
                                            GameDisplay.networkTurnByTurn ||
                                        gameDisplay ==
                                            GameDisplay.localTurnByTurn
                                    ? new Container(
                                        child: new Text(
                                            widget.isGameOver == true
                                                ? Loca.of(context).gameOver
                                                : Loca.of(context)
                                                    .waitingForTurn,
                                            style: new TextStyle(
                                                fontSize: ht > wd
                                                    ? ht * 0.01
                                                    : wd * 0.01,
                                                color: Colors.white)))
                                    : new Row(),

                                //Other user's score
                                gameDisplay == GameDisplay.myHeadToHead ||
                                        gameDisplay ==
                                            GameDisplay.networkTurnByTurn ||
                                        gameDisplay ==
                                            GameDisplay.localTurnByTurn
                                    ? new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Text(
                                            '$otherScore',
                                            style: new TextStyle(
                                                fontSize: ht > wd
                                                    ? ht * 0.05
                                                    : wd * 0.035,
                                                fontWeight: FontWeight.bold,
                                                color: textcolor),
                                          )
                                        ],
                                      )
                                    : new Row()
                              ],
                            ))),

                    //Circular container which shows the V/S text
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          gameDisplay == GameDisplay.myHeadToHead ||
                                  gameDisplay ==
                                      GameDisplay.networkTurnByTurn ||
                                  gameDisplay == GameDisplay.localTurnByTurn
                              ? new Container(
                                  height: ht > wd ? ht * 0.1 : wd * 0.08,
                                  width: ht > wd ? ht * 0.1 : wd * 0.08,
                                  alignment: new FractionalOffset(0.5, 0.5),
                                  decoration: new BoxDecoration(
                                    color: textcolor,
                                    border: new Border.all(
                                      color: textcolor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: new Text(Loca.of(context).vs,
                                      style: new TextStyle(
                                          fontSize:
                                              ht > wd ? ht * 0.03 : wd * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))
                              : new Container(),
                        ])
                  ],
                ),

                //Stars Being Displayed according to the score
                // new ScaleTransition(
                //   scale: _characterAnimation,
                //   child: new Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       new Row(
                //           mainAxisAlignment:
                //               gameDisplay == GameDisplay.myHeadToHead ||
                //                       gameDisplay ==
                //                           GameDisplay.networkTurnByTurn ||
                //                       gameDisplay == GameDisplay.localTurnByTurn
                //                   ? MainAxisAlignment.spaceEvenly
                //                   : MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: <Widget>[
                //             new Row(
                //                 mainAxisAlignment:
                //                     gameDisplay == GameDisplay.myHeadToHead ||
                //                             gameDisplay ==
                //                                 GameDisplay.networkTurnByTurn ||
                //                             gameDisplay ==
                //                                 GameDisplay.localTurnByTurn
                //                         ? MainAxisAlignment.center
                //                         : MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: tablestars1),
                //             new Padding(
                //               padding: new EdgeInsets.all(10.0),
                //             ),
                //             gameDisplay == GameDisplay.myHeadToHead ||
                //                     gameDisplay ==
                //                         GameDisplay.networkTurnByTurn ||
                //                     gameDisplay == GameDisplay.localTurnByTurn
                //                 ? new Row(
                //                     mainAxisAlignment: MainAxisAlignment.end,
                //                     crossAxisAlignment: CrossAxisAlignment.end,
                //                     children: tablestars2)
                //                 : new Row(),
                //           ]),

                //     ],
                //   ),
                // ),

                new Container(
                    height: ht * .2,
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(5.0)),
                      image: new DecorationImage(
                        image: myScore > otherScore
                            ? new AssetImage(
                                "assets/background_gif/Win_loop.gif")
                            : new AssetImage("other.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: new Padding(
                        padding: new EdgeInsets.only(right: 20.0),
                        child: new Stack(
                          alignment: FractionalOffset.center,
                          overflow: Overflow.visible,
                          children: <Widget>[getScoreButton()],
                        ))),

                // Icons which redirect to home, refresh and fast-forward
                new Container(
                    color: textcolor,
                    child: new ScaleTransition(
                        scale: buttoncontroller,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                                icon: new Image.asset("assets/home_button.png"),
                                iconSize: ht > wd ? ht * 0.1 : wd * 0.08,
                                onPressed: () {
                                  setState(() {
                                    _pageExited = true;
                                  });

                                  AppStateContainer.of(context)
                                      .play('_audiotap.mp3');
                                  if (flag == true) {
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/tab'));
                                  }
                                }),
                            IconButton(
                                icon: new Image.asset(
                                    "assets/forward_button.png"),
                                iconSize: ht > wd ? ht * 0.1 : wd * 0.08,
                                onPressed: () {
                                  setState(() {
                                    _pageExited = true;
                                  });
                                  AppStateContainer.of(context)
                                      .play('_audiotap.mp3');
                                  if (flag == true) {
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/tab'));
                                  }
                                }),
                          ],
                        ))),
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
