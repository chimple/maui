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
  int result = 5;
  int _num = 5;
  int count = 0;
  List<int> a = [1, 2, 3, 4, 5];
  @override
  void initState() {
    super.initState();
    _animTimerController = new AnimationController(vsync: this, duration: new Duration(seconds: 10));
    _animationController = new AnimationController(duration: new Duration(milliseconds: 100), vsync: this);

    _animationTimer = new StepTween(begin: 0, end: 5).animate(_animTimerController);
    _animation = new Tween(begin: 0.0, end: 15.0).animate(_animationController);
    _myAnim1();
  }

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

  void _myAnim1() {
    _animationTimer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if(count == 1)
        {
          _animTimerController.forward(from: 0.0);
          new Future.delayed(const Duration(milliseconds: 500), () {
            _animTimerController.stop();
          });

        }
        else {
          count = count + 1;
          _animTimerController.forward(from: 0.0);
          //}
        }}
    });
    _animTimerController.forward(from: 0.0);
    print('Pushed the Button');
  }

  void _clickText () {
    if(result ==  a[_animationTimer.value]){
      setState(() => this.result = 1);
    }
    else{
      _myAnim();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        _animationController.stop();
        _animTimerController.forward(from:0.0);

      });
    }
  }//end of _clickText function


  @override
  Widget build(BuildContext context) {

    MediaQueryData media = MediaQuery.of(context);
    double _height = media.size.height;
    print(media.size);
    return new Center(
            child: new Container(
                color: Colors.greenAccent,
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      new Expanded (
                          flex: 1,
                          child: new AspectRatio(
                              aspectRatio: 1.0,
                              child: new TextAnimation(
                                  animation: _animation,
                                  text: result.toString(),
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
                                  child: new Container (
                                      alignment: Alignment.center,
                                      color: new Color(0X00000000),
                                      child:new Countdown(
                                        animation: _animationTimer,
                                        height: _height, )))))])));
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
        child:  new Container(
            color: Colors.greenAccent,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  new Expanded (
                      flex: 1,
                      child: new Container(
                          margin: new EdgeInsets.only(left: _animation.value ?? 0,top: height * 0.1),

                          alignment: Alignment.center,
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Colors.white,
                                  width: height * 0.01),
                              shape: BoxShape.circle),
                          child: new Center(
                              child: new Text(text,
                                  style:new
                                  TextStyle(color: Colors.white, fontSize: height * 0.18)))))])));
  }
}

class Countdown extends AnimatedWidget {
  Countdown({ Key key, this.animation, this.height }) : super(key: key, listenable: animation);
  Animation<int> animation;
  double height;
  List<int> a = [1, 2, 3, 4, 5];

  @override
  build(BuildContext context){
    return new Text(
        a[animation.value].toString(),
        key: new Key('question'),
        style: new TextStyle(
            fontSize: height * 0.2,
            fontWeight: FontWeight.bold,
            color: Colors.white )
    );
  }
}
