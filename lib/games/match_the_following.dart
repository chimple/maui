import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/shaker.dart';
class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  MatchTheFollowing({
    key,
    this.onScore,
    this.onProgress,
    this.onEnd,
    this.iteration,
    this.function,
    this.gameCategoryId,
  })
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

enum Status { Disable, Enable }
enum StatusShake { Stopped, Shake }

class _MatchTheFollowingState extends State<MatchTheFollowing>
    with SingleTickerProviderStateMixin {
  int c = 0;
  int start = 0, increament = 0;
  final List<String> _leftSideletters = [];
  final List<String> _rightSideLetters = [];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  List<Status> _statusColorChange;
  List<StatusShake> _statusShake;
  Map<String, String> _allLetters;
  String _leftSideText, _rightSideText;
  int indexText1, indexText2,indexLeftButton;
  int attem = 0, i = 0,_oldIndexforLeftButton=0,_oldIndexforRightButton,_nextTask = 5;
  bool _isLoading = true;
  int _size = 5, indexL,flag=0,flag1=0;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    print("parent build::");
    return new Expanded(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: _buildLeftSide(context),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(35.0),
                  ),
                  new Expanded(child: _buildRightSide(context)),
                ],
              ),
            ),
          ]),
    );
  }

  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allLetters = await fetchPairData(widget.gameCategoryId, 5);
    _allLetters.forEach((k, v) {
      _leftSideletters.add(k);
      _rightSideLetters.add(v);
    });
    print("first initState method");
    for (var i = start; i < _leftSideletters.length; i++) {
      _shuffledLetters.addAll(
          _leftSideletters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
      _shuffledLetters1.addAll(
          _rightSideLetters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
    }
    _lettersLeft = _shuffledLetters.sublist(start, _nextTask);
    _lettersRight = _shuffledLetters1.sublist(start, _nextTask);
    _statusColorChange =
        _shuffledLetters.map((a) => Status.Disable).toList(growable: false);
    _statusShake = _shuffledLetters1
        .map((e) => StatusShake.Stopped)
        .toList(growable: false);
    setState(() => _isLoading = false);
  }

  Widget _buildLeftSide(BuildContext context) {
    // print("_buildLeftSidde method::");
    int j = 0;
    List<TableRow> rows = new List<TableRow>();
    List<Widget> cells;
    for (var i = 0; i < _size; ++i) {
      cells = _lettersLeft
          .skip(i)
          .take(1)
          .map((e) => _buildItemsLeft(j, e, _statusColorChange[j++]))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Table(children: rows);

    // return new Table(children: rows);
  }

  Widget _buildItemsLeft(int index, String text, Status colorstatus) {
    // print("_Build Items Right::");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        colorstatus: colorstatus,
        onPress: () {
          indexText1 = _lettersLeft.indexOf(text);
          _leftSideText = text;
          if (_statusColorChange[index] != Status.Enable) {
            setState(() {
              _statusColorChange[index] = Status.Enable;
            });
            flag=1; 
          }
          if (_oldIndexforLeftButton !=index && flag==1) {
            _statusColorChange[_oldIndexforLeftButton]=Status.Disable;
            flag=0;
          }
          _oldIndexforLeftButton=index;
          indexLeftButton=index;
        });
  }

  Widget _buildRightSide(BuildContext context) {
    int j = 5;
    List<TableRow> rows = new List<TableRow>();
    List<Widget> cells;
    for (var i = 0; i < _size; ++i) {
      cells = _lettersRight
          .skip(i)
          .take(1)
          .map((e) => _buildItemsRight(j, e, _statusShake[j++]))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Table(children: rows);
  }

  Widget _buildItemsRight(int index, String text, StatusShake shakestatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        shakestatus: shakestatus,
        onPress: () {
          indexText2 = _lettersRight.indexOf(text);
          _rightSideText = text;
          match(index);
        });
  }

  void match(int indexRightbutton) {
    int score = 2;
    print("Right Index:: $indexText2");
    if (_leftSideletters.indexOf(_leftSideText) == _rightSideLetters.indexOf(_rightSideText)) {
      setState(() {
        _lettersLeft[indexText1] = '';
        _lettersRight[indexText2] = '';
      });
      print("match::");
      attem++;
      widget.onScore(score);
      widget.onProgress(attem / 5);
      score = score + 2;
    } else {
      if (_statusShake[indexRightbutton]!=StatusShake.Shake)
      setState(() {
        _statusShake[indexRightbutton] = StatusShake.Shake;
        _statusColorChange[indexLeftButton]=Status.Enable;
        flag1=1;
         });
         if (_oldIndexforRightButton!=indexRightbutton && flag1==1) {
           _statusShake[_oldIndexforLeftButton]=StatusShake.Stopped;
           flag1=0;
         }
    }
     _oldIndexforRightButton=indexRightbutton;
    // new Future.delayed(const Duration(milliseconds: 800), () {
    //   setState(() {
    //     _statuses1[indexR] = Status.Stopped;
    //     _statuses[indexL] = Status.Disable;
    //   });
    // });

    if (attem == 5) {
      print("change::");
      attem = 0;
      print("left:: $_lettersLeft");
      print("right:: $_lettersRight");
      _initBoard();
      setState(() {});
    }
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text,
    this.onPress,
    this.active: true,
    this.colorstatus,
    this.shakestatus,
    this.shake,
  })
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  bool active;
  Status colorstatus;
  StatusShake shakestatus;
  Animation shake;
  int flag = 0;
  @override
  createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller, controller1;
  Animation animationInvisible, animationShake;

  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 400), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(microseconds: 500), vsync: this);
    animationInvisible =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animationShake = new Tween(begin: 0.0, end: 5.0).animate(controller1);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        if (widget.text == null) {
          setState(() => _displayText = widget.text);
        }
      }
    });
    // controller1.addStatusListener((state1) {
    //   print("shake is worked");
    //   if (state1 == AnimationStatus.completed) {
    //     new Future.delayed(const Duration(milliseconds: 50), () {
    //       controller1.reverse();
    //     });
    //   } else if (state1 == AnimationStatus.dismissed) {
    //     new Future.delayed(const Duration(milliseconds: 50), () {
    //       controller1.forward();
    //     });
    //   }
    // });
    // controller1.forward();
    // new Future.delayed(const Duration(milliseconds: 1000), () {
    //   controller1.stop();
    // });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    } else if (oldWidget.text == widget.text) {
      controller1.addStatusListener((state1) {
        print("shake is worked");
        if (state1 == AnimationStatus.completed) {
          controller1.reverse();
        } else if (state1 == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
      controller1.forward();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        try {
        controller1.stop();
        }
        catch(exception, exc){}
      });
    }
  }

  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> noAnimation;
    Size media = MediaQuery.of(context).size;
    double _height, _width;
    _height = media.height / 10;
    _width = media.width;
    print("media hieght : $_height width:: $_width");
    //return new Padding(
    //  padding: new EdgeInsets.all(5.0),
    return new Container(
        margin: new EdgeInsets.only(right:  15.0,left: 15.0),
        height: _height,
        padding: new EdgeInsets.all(4.0),
        child: new Shake(
            animation: (widget.shakestatus == StatusShake.Shake || widget.colorstatus==Status.Enable) 
                ? animationShake
                : animationInvisible,
            child: new ScaleTransition(
                scale: animationInvisible,
                key: widget.key,
                child: new RaisedButton(
                    elevation: 8.0,
                    splashColor: Colors.red,
                    onPressed: () => widget.onPress(),
                    color: widget.colorstatus == Status.Enable
                        ? Colors.yellow[300]
                        : Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style: new TextStyle(
                            color: Colors.white, fontSize: 25.0))))));
  }
}

// class Shake extends AnimatedWidget {
//   const Shake({
//     Key key,
//     Animation<double> animation,
//     this.child,
//   })
//       : super(key: key, listenable: animation);

//   final Widget child;

//   Animation<double> get animation => listenable;
//   double get translateX {
//     const double shakeDelta = 0.0;
//     final double t = animation.value;
//     // if (t <= 2.0)
//     //   return -t * shakeDelta;
//     // // else if (t < 0.75)
//     // //   return (t - 0.5) * shakeDelta;
//       //return (1.0 - t) * 4.0 * shakeDelta;
//       return t*1.2;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Transform(
//       transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
//       child: child,
//     );
//   }
// }
// class ButtonAnimation extends AnimatedWidget {
//   ButtonAnimation({Key key, Animation animation, this.onPressed})
//       : super(key: key, listenable: animation);

//   Function onPressed;

//   @override
//   Widget build(BuildContext context) {

//     print("Child build::");
//     Animation animation = listenable;
//     print("list:  $listenable");
//     return new Center(
//       child: new Container(
//         height: 30.0,
//         width: 30.0,
//         margin: new EdgeInsets.only(left: animation.value ?? 0),
//         child: new RaisedButton(
//           child:  new Text("Push Me"),
//           onPressed: onPressed,
//         ),
//       ),
//     );
//   }
// }
