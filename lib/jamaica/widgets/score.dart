import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:maui/jamaica/widgets/coin_animation.dart';

typedef UpdateCoins(int coins);

class Score extends StatefulWidget {
  final int starCount;
  final int coinsCount;
  final int score;
  final UpdateCoins updateCoins;
  Score({
    Key key,
    this.starCount,
    this.coinsCount,
    this.score,
    this.updateCoins,
  }) : super(key: key);

  @override
  _ScoreState createState() => new _ScoreState();
}

class _ScoreState extends State<Score> with TickerProviderStateMixin {
  AnimationController controller, buttoncontroller;
  AnimationController _animationController;
  double animationDuration = 0.0;
  GlobalKey _globalKey = new GlobalKey();
  // int starCount = 5;
  // Random().nextInt(5-0)+1;
  List<int> starValues = [];
  Offset _offset = Offset(0.0, 0.0);
  // int coinCount = 100;
  bool moveAnime = false;
  bool animationCompleted = false;
  List<String> gameplaytitle = [
    "Very Bad",
    "Bad",
    "Good",
    "Very Good",
    "Excellent"
  ];

  callback(t) {
    setState(() {
      animationCompleted = t;
    });
  }

  @override
  void initState() {
    super.initState();
    // to get coin animation destination offset
    WidgetsBinding.instance.addPostFrameCallback((s) {
      _afterLayout();
    });
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    buttoncontroller = new AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    final int totalDuration = 4000;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));
    animationDuration =
        totalDuration / (100 * (totalDuration / widget.starCount));
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (_animationController.isCompleted) {
        setState(() {
          moveAnime = true;
          widget.updateCoins(widget.starCount);
        });
      }
    });
    for (int i = 1; i <= widget.starCount; i++) {
      starValues..add(0);
    }

    new Future.delayed(Duration(milliseconds: 50), () {
      buttoncontroller.forward();
    });
    controller.forward();
  }

  void _afterLayout() {
    RenderBox box = _globalKey.currentContext.findRenderObject();
    _offset = box.localToGlobal(Offset.zero);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    buttoncontroller.dispose();
    super.dispose();
  }

  _buildCoinItem(int index, int e) {
    return MoveCoinAnimation(
      key: new ValueKey<int>(index),
      callback: callback,
      index: index,
      starCount: widget.starCount,
      offset: _offset,
    );
  }

  buildFlareAnimation() {
    Size media = MediaQuery.of(context).size;
    return Container(
      height: media.height * .15,
      width: media.width * .15,
      child: FlareActor(
        "assets/coin.flr",
        animation: "coin",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      double ht = constraints.maxHeight;
      double wd = constraints.maxWidth;
      int inc = 0;

      return new Scaffold(
        backgroundColor: Colors.blue[900],
        body: new SafeArea(
          child: Stack(overflow: Overflow.visible, children: <Widget>[
            new Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                              height: ht > wd ? ht * 0.1 : ht * .15,
                              width: ht > wd ? ht * 0.1 : ht * .15,
                              decoration: new ShapeDecoration(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  image: new DecorationImage(
                                      image: AssetImage(
                                          "assets/accessories/apple.png"),
                                      fit: BoxFit.fill))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "UserName",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Container(
                                // height: ht * .05,
                                width: wd * 0.18,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      key: _globalKey,
                                      height: ht * .08,
                                      width: wd * .08,
                                      child: FlareActor(
                                        "assets/coin.flr",
                                      ),
                                    ),
                                    Text("${widget.coinsCount}",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      new Container(
                          height: ht > wd ? ht * 0.1 : ht * .15,
                          width: ht > wd ? ht * 0.1 : ht * .15,
                          decoration: new ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.white,
                                      width: 2.0,
                                      style: BorderStyle.solid)),
                              image: new DecorationImage(
                                  image: AssetImage(
                                      "assets/accessories/apple.png"),
                                  fit: BoxFit.fill))),
                    ],
                  ),
                  new Container(
                      height: ht > wd ? ht * 0.2 : wd * 0.13,
                      child: Image(
                          image: AssetImage("assets/accessories/apple.png"),
                          fit: BoxFit.fill)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            height: ht > wd ? ht * .2 : ht * .25,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ButtonBar(
                              children: <Widget>[
                                animationCompleted
                                    ? Container(
                                        height: ht * .15,
                                        child: Center(
                                            child: Text(
                                                "${gameplaytitle[widget.starCount - 1]}",
                                                style: TextStyle(
                                                    fontSize:
                                                        ht > wd ? 60.0 : 40.0,
                                                    fontWeight:
                                                        FontWeight.w900))))
                                    : !moveAnime
                                        ? new Container(
                                            height: ht * .15,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: starValues
                                                    .map((e) => Padding(
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        child:
                                                            buildFlareAnimation()))
                                                    .toList(growable: false)),
                                          )
                                        : Container(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: starValues
                                                    .map((e) => Padding(
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        child: _buildCoinItem(
                                                            inc++, e)))
                                                    .toList(growable: false)),
                                          ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: new Text(
                      '${widget.score}',
                      style: new TextStyle(
                          fontSize: ht > wd ? ht * 0.08 : ht * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    child: new ScaleTransition(
                      scale: buttoncontroller,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Stack(children: <Widget>[
                            Container(
                              height: ht > wd ? ht * .075 : ht * 0.11,
                              width: ht > wd ? wd * .3 : wd * .2,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            Container(
                              height: ht > wd ? ht * .07 : ht * 0.1,
                              width: ht > wd ? wd * .3 : wd * .2,
                              margin: EdgeInsets.only(bottom: 10.0),
                              decoration: new BoxDecoration(
                                color: Colors.orange,
                                border: new Border.all(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Text("Next",
                                      style: new TextStyle(
                                          fontSize:
                                              ht > wd ? ht * 0.03 : wd * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ]),
          ]),
        ),
      );
    });
  }
}
