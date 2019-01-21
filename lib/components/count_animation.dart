import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class CountAnimation extends StatefulWidget {
  int index;
  int rndVal;
  var selectedIndex;
  int countVal;
  CountAnimation(
      {key, this.index, this.rndVal, this.selectedIndex, this.countVal})
      : super(key: key);
  @override
  CountAnimationState createState() {
    return new CountAnimationState();
  }
}

enum CountWidgetStatus { hidden, becomingVisible, visible, becomingInvisible }

class CountAnimationState extends State<CountAnimation>
    with TickerProviderStateMixin {
  MediaQueryData queryData;
  int countVal = 0;
  int counting = 0;
  bool tapped = false;
  double _sparklesAngle = 0.0;
  CountWidgetStatus _countWidgetStatus = CountWidgetStatus.hidden;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  Random random;
  Timer holdTimer, countOutEta;
  AnimationController countInAnimationController,
      countOutAnimationController,
      countSizeAnimationController,
      sparklesAnimationController;
  Animation countOutPositionAnimation, sparklesAnimation;

  initState() {
    super.initState();
    random = new Random();
    countInAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 150), vsync: this);
    countInAnimationController.addListener(() {
      setState(() {}); // Calls render function
    });

    countOutAnimationController =
        new AnimationController(vsync: this, duration: duration);
    countOutPositionAnimation = new Tween(begin: 100.0, end: 150.0).animate(
        new CurvedAnimation(
            parent: countOutAnimationController, curve: Curves.easeOut));
    countOutPositionAnimation.addListener(() {
      setState(() {});
    });
    countOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _countWidgetStatus = CountWidgetStatus.hidden;
      }
    });

    countSizeAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 150));
    countSizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        countSizeAnimationController.reverse();
      }
    });
    countSizeAnimationController.addListener(() {
      setState(() {});
    });

    sparklesAnimationController =
        new AnimationController(vsync: this, duration: duration);
    sparklesAnimation = new CurvedAnimation(
        parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener(() {
      setState(() {});
    });
  }

  dispose() {
    countInAnimationController.dispose();
    countOutAnimationController.dispose();
    super.dispose();
  }

  void increment(Timer t) {
    countSizeAnimationController.forward(from: 0.0);
    sparklesAnimationController.forward(from: 0.0);

    if (widget.selectedIndex[widget.index] == 0) {
      for (int i = 0; i < widget.selectedIndex.length; i++) {
        if (widget.selectedIndex[i] == 1) {
          if (counting <= widget.rndVal) {
            setState(() {
              counting = counting + 1;
            });
          }
        }
      }
    } else {
      countVal = 0;
      for (int i = 0; i < widget.selectedIndex.length; i++) {
        if (widget.selectedIndex[i] == 1) {
          if (counting <= widget.rndVal) {
            setState(() {
              countVal = countVal + 1;
            });
          }
        }
      }
    }
    setState(() {
      widget.countVal = widget.selectedIndex[widget.index] == 0
          ? widget.countVal + counting + 1
          : countVal;
      _sparklesAngle = random.nextDouble() * (2 * pi);
      widget.selectedIndex[widget.index] = 1;
      AppStateContainer.of(context).playWord(widget.countVal.toString());
    });
  }

  void onTapDown(int index) {
    setState(() {
      tapped = true;
    });
    if (countOutEta != null) {
      countOutEta.cancel();
    }
    if (_countWidgetStatus == CountWidgetStatus.becomingInvisible) {
      countOutAnimationController.stop(canceled: true);
      _countWidgetStatus = CountWidgetStatus.visible;
    } else if (_countWidgetStatus == CountWidgetStatus.hidden) {
      _countWidgetStatus = CountWidgetStatus.becomingVisible;
      countInAnimationController.forward(from: 20.0);
    }
    increment(null);
    holdTimer = new Timer.periodic(duration, increment);
    setState(() {
      // Flame.audio.play('smash.mp3');
    });
    holdTimer.cancel();

    countOutEta = new Timer(oneSecond, () {
      countOutAnimationController.forward(from: 0.0);
      _countWidgetStatus = CountWidgetStatus.becomingInvisible;
    });
    holdTimer.cancel();
  }

  Widget getCountButton(int index, MediaQueryData media) {
    var countPosition = 0.0;
    var countOpacity = 0.0;
    var extraSize = 0.0;
    switch (_countWidgetStatus) {
      case CountWidgetStatus.hidden:
        break;
      case CountWidgetStatus.becomingVisible:
      case CountWidgetStatus.visible:
        countPosition =
            countInAnimationController.value * media.size.height * .1;
        countOpacity = countInAnimationController.value;
        extraSize = countSizeAnimationController.value * 5;
        break;
      case CountWidgetStatus.becomingInvisible:
        countPosition = countOutPositionAnimation.value;
        countOpacity = 1.0 - countOutAnimationController.value;
    }

    var stackChildren = <Widget>[];

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparklesAnimationController.value * 50);
    var sparklesOpacity = (1 - sparklesAnimation.value);

    for (int i = 0; i < 5; ++i) {
      var currentAngle = (firstAngle + ((2 * pi) / 5) * (i));
      var sparklesWidget = new Positioned(
        child: new Transform.rotate(
            angle: currentAngle - pi / 2,
            child: new Opacity(
                opacity: sparklesOpacity,
                child: new Image.asset(
                  "assets/sparkles.png",
                  width: 15.0,
                  height: 15.0,
                ))),
        left: (sparkleRadius * cos(currentAngle)) + 8,
        top: (sparkleRadius * sin(currentAngle)) + 8,
      );
      stackChildren.add(sparklesWidget);
      // print("count position   $countPosition");
    }

    stackChildren.add(new Opacity(
        opacity: countOpacity,
        child: new Container(
            height: 30.0 + extraSize,
            width: 30.0 + extraSize,
            decoration: new ShapeDecoration(
              shape: new CircleBorder(side: BorderSide.none),
              color: Colors.pink,
            ),
            child: new Center(
                child: new Text(
              widget.countVal.toString(),
              style: new TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            )))));

    var widget1 = new Positioned(
        child: new Stack(
          alignment: FractionalOffset.center,
          overflow: Overflow.visible,
          children: stackChildren,
        ),
        bottom: countPosition);
    return widget1;
  }

  Widget getImageButton(int index) {
    var extraSize = 0.0;
    if (_countWidgetStatus == CountWidgetStatus.visible ||
        _countWidgetStatus == CountWidgetStatus.becomingVisible) {
      extraSize = countSizeAnimationController.value * 20;
    }
    return Container(
      width: 70.0 - extraSize,
      height: 70.0 - extraSize,
      child: widget.index != null ?
      Image(
        image: widget.selectedIndex[widget.index] == 0
            ? AssetImage("assets/orange.png")
            : AssetImage("assets/orange2.png"),
      ): Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        onTapDown(widget.index);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: new Stack(
          alignment: FractionalOffset.center,
          overflow: Overflow.visible,
          children: <Widget>[
            tapped ? getCountButton(widget.index, media) : Container(),
            getImageButton(widget.index),
          ],
        ),
      ),
    );
  }
}
