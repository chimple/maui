import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/flash_card.dart';

class TapHome extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  TapHome(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TapState();
}

class _TapState extends State<TapHome> with TickerProviderStateMixin {
  Animation _animation, _animationTimer;
  AnimationController _animationController, _animTimerController;
  List<int> result = [2, 3, 4];
  int _num = 0;
  int count = 0;
  bool _isLoading = true;
  List<String> _option;
  String _answer;
  Tuple2<String, List<String>> _gameData;

  @override
  void initState() {
    super.initState();
    _animTimerController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 10));
    _animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);

    _animationTimer =
        new StepTween(begin: 0, end: 7).animate(_animTimerController);
    _animation = new Tween(begin: 0.0, end: 15.0).animate(_animationController);
    _initBoard();
  }

  void _initBoard() async {
    _num = 0;
    count = 0;
    setState(() => _isLoading = true);
    _gameData = await fetchSequenceData(widget.gameCategoryId, 7);
    _option = _gameData.item2;
    _answer = _gameData.item1;
    print("data is coming $_option");
    _myAnim1();
    setState(() => _isLoading = false);
  }

  //used for shaking animation
  void _myAnim() {
    _animTimerController.stop();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
    print('Pushed the Button');
  }

  //used for changing the number at proper interval
  void _myAnim1() {
    _animationTimer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (count == 1) {
          count = 0;
          new Future.delayed(const Duration(milliseconds: 2000), () {
            _animTimerController.stop();
            widget.onEnd();
          });
        } else {
          count = count + 1;
          _animTimerController.forward(from: 0.0);
        }
      }
    });
    _animTimerController.forward(from: 0.0);
    print('Pushed the Button');
  }

  //this function is used for matching on tap
  void _clickText() {
    if (_answer == _option[_animationTimer.value]) {
      _animTimerController.stop();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        widget.onScore(1);
        widget.onProgress(1.0);
        widget.onEnd();
      });
    } else {
      _myAnim();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        _animationController.stop();
        _animTimerController.forward(from: 0.0);
      });
    }
  }

  @override
  void didUpdateWidget(TapHome oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print(_gameData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print("this is  data");
      print(constraints.maxHeight);
      print(constraints.maxWidth);
      double _height;
      _height = constraints.maxHeight;
      if (_isLoading) {
        return new SizedBox(
          width: 20.0,
          height: 20.0,
          child: new CircularProgressIndicator(),
        );
      }

      return new Center(
          child: new Container(
              color: Colors.greenAccent,
              child: new Column(mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: new AspectRatio(
                            aspectRatio: 1.0,
                            child: new TextAnimation(
                                animation: _animation,
                                text: _answer.toString(),
                                height: _height))),
                    new Expanded(
                        flex: 1,
                        child: new Material(
                            shadowColor: Colors.black87,
                            color: Colors.transparent,
                            type: MaterialType.circle,
                            child: new InkWell(
                                onTap: _clickText,
                                enableFeedback: true,
                                highlightColor: Colors.blueGrey,
                                child: new Container(
                                    alignment: Alignment.center,
                                    color: new Color(0X00000000),
                                    child: new Countdown(
                                        animation: _animationTimer,
                                        height: _height,
                                        option: _option)))))
                  ])));
    });
  }
}


class TextAnimation extends AnimatedWidget {
  TextAnimation({Key key, Animation animation, this.text, this.height})
      : super(key: key, listenable: animation);
  final String text;
  final double height;

  @override
  Widget build(BuildContext context) {
    Animation _animation = listenable;
    return new Center(
        child: new Container(
            color: Colors.greenAccent,
            child: new Container(
                margin: new EdgeInsets.only(
                    left: _animation.value ?? 0, top: height * 0.1),
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                    border: new Border.all(
                        color: Colors.white, width: height * 0.01),
                    shape: BoxShape.circle),
                child: new Center(
                    child: new Text(text,
                        style: new TextStyle(
                            color: Colors.white, fontSize: height * 0.18))))));
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation, this.height, this.option})
      : super(key: key, listenable: animation);
  Animation<int> animation;
  double height;
  List<String> option;

  @override
  build(BuildContext context) {
    return new Text(option[animation.value].toString(),
        key: new Key('question'),
        style: new TextStyle(
            fontSize: height * 0.2,
            fontWeight: FontWeight.bold,
            color: Colors.white));
  }
}
