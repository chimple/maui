import 'dart:async';
import 'dart:math';
import 'package:maui/games/single_game.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
class Wordgrid extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Wordgrid(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new WordgridState();
}

enum Status { Active, Visible, Disappear }
enum ShakeCell { Right, InActive, Dance, CurveRow }

class WordgridState extends State<Wordgrid> {
  var i = 0;
  var count = 0;
  var _size;
  var size,T,B,j,n,m;
  var k = 0;
  var R = 1;
  var L = 1;
  var count1 = 0;
  var count2 = 0;
  var count3 = 0;
  var count6 = 0;
  var count4 = 0;
  var count5 = 0;
  var count0 = 0;
  var r;
  var center = 0;
  var rand;
  var flag = 0;
  String words = '';
  int _maxSize = 4;
  int _otherSize = 1;
  bool _isShowingFlashCard = false;
  List<String> numbers = [];
  List<String> _shuffledLetters = [];
  List _copyAns = [];
  List<String> _letters;
  List<String> _todnumber = [];
  List<Status> _statuses;
  List<String> _letterex = [];
  bool _isLoading = true;
  var z = 0;
  Tuple2<List<String>, List<String>> data;

  List<ShakeCell> _ShakeCells = [];
  @override
  void initState() {
    super.initState();
    _initBoard();
    if (widget.gameConfig.level < 4) {
      _maxSize = 3;
      _otherSize = 1;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 5;
      _otherSize = 4;
    } else {
      _maxSize = 7;
      _otherSize = 9;
    }
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    // _copyAns=[];
    data = await fetchWordData(
        widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
        print('original data $data');
    print("this data 1 ${data.item1}");
    print('data 2 ${data.item2}');
   _size= sqrt(data.item1.length+data.item2.length).toInt();
   T = _size;
   B = _size;
   j = _size;
   n = _size;
   m = _size;
  size=_size;
    data.item1.forEach((e) {
      _copyAns.add(e);
    });
    var rnge = new Random();
    for (var i = 0; i < 1; i++) {
      rand = rnge.nextInt(2);
    }
    if (rand == 1) {
      data.item1.forEach((e) {
        numbers.add(e);
      });
      data.item2.forEach((v) {
        numbers.add(v);
      });
    } else {
      data.item2.forEach((e) {
        numbers.add(e);
      });
      data.item1.forEach((v) {
        numbers.add(v);
      });
    }
    print("suffle data is in my numbers is $numbers");
    print("sorted numbers are $numbers ");
    for (var i = 0; i < numbers.length; i += _size * _size) {
      _shuffledLetters
          .addAll(numbers.skip(i).take(_size * _size).toList(growable: true));
    }
    _statuses = numbers.map((a) => Status.Active).toList(growable: false);
    _ShakeCells =
        numbers.map((a) => ShakeCell.InActive).toList(growable: false);

    print(_shuffledLetters);

    var todnumbers = new List.generate(m, (_) => new List(n));
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        count3 = count2 + j + 1 + count1;
        _shuffledLetters.sublist(count1, count3).forEach((e) {
          todnumbers[i][j] = e;
        });
      }
      count1 = count3;
    }
    for (var i = 1; i < size; i++) {
      if (i % 2 != 0) {
        Iterable letdo = todnumbers[i].reversed;
        var fReverse = letdo.toList();
        todnumbers[i].setRange(0, size, fReverse.map((e) => e));
      }
    }

    todnumbers.forEach((e) {
      e.forEach((v) {
        _todnumber.add(v);
      });
    });
    var todcolnumbers = new List.generate(m, (_) => new List(n));
    for (var i = 0; i < size; i++) {
      if (i % 2 != 0) {
        for (var j = size - 1; j >= 0; j--) {
          count6 = 1 + count4;
          _shuffledLetters.sublist(count4, count6).forEach((e) {
            todcolnumbers[j][i] = e;
          });
          count4 = count6;
        }
      } else {
        for (var j = 0; j < size; j++) {
          count6 = count2 + j + 1 + count4;
          _shuffledLetters.sublist(count4, count6).forEach((e) {
            todcolnumbers[j][i] = e;
          });
        }
      }
      count4 = count6;
    }

    todcolnumbers.forEach((e) {
      e.forEach((v) {
        _letterex.add(v);
      });
    });

    var rng = new Random();
    for (var i = 0; i < 1; i++) {
      r = rng.nextInt(4);
    }
    if (r == 4) {
      r = r - 1;
    }
    switch (r) {
      case 0:
        {
          _letters = _todnumber;
        }
        break;
      case 1:
        {
          Iterable _number4 = _todnumber.reversed;
          var fruitsInReverset = _number4.toList();
          _letters = fruitsInReverset;
        }
        break;

      case 2:
        {
          _letters = _letterex;
        }
        break;
      case 3:
        {
          Iterable _number4 = _letterex.reversed;
          var fruitsInReverset = _number4.toList();
          _letters = fruitsInReverset;
        }
        break;
    }

    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Wordgrid oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  Widget _buildItem(int index, String text, Status status, ShakeCell tile) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        onPress: () {
          if (status == Status.Active) {
            if ((text == _copyAns[i]) &&
                (index == center + R ||
                    index == center - L ||
                    index == center - T ||
                    index == center + B ||
                    (center == 0 && flag == 0))) {
              center = index;
              flag = 1;
              setState(() {
                _statuses[index] = Status.Visible;
                widget.onScore(1);
                widget.onProgress((i + 1) / (_copyAns.length));
                count0++;
              });
              i++;
              if (i == _copyAns.length) {
                setState(() {
                  _copyAns.forEach((e) {
                    words = "$words" + "$e";
                  });
                });

                _copyAns.removeRange(0, _copyAns.length);
                i = 0;
                new Future.delayed(const Duration(milliseconds: 500), () {
                  k = 0;
                  center = 0;
                  flag = 0;
                  count0 = 0;
                  count1 = 0;
                  count2 = 0;
                  count3 = 0;
                  count6 = 0;
                  count4 = 0;
                  count5 = 0;
                  
                  _todnumber.removeRange(0, _todnumber.length);
                  _letters.removeRange(0, _letters.length);

                  _letterex.removeRange(0, _letterex.length);
                  numbers.removeRange(0, numbers.length);

                  _shuffledLetters.removeRange(0, _shuffledLetters.length);
                  //  _copyAns.removeRange(0, _copyAns.length);
                  new Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      _isShowingFlashCard = true; // widget.onEnd();
                    });
                  });
                  //
                });
              }
            } else {
              setState(() {
                _ShakeCells[index] = ShakeCell.Right;
                new Future.delayed(const Duration(milliseconds: 400), () {
                  setState(() {
                    _ShakeCells[index] = ShakeCell.InActive;
                  });
                });
              });
            }
          }
        });
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
    if (_isShowingFlashCard) {
      return new FlashCard(
          text:words,
          onChecked: () {
            widget.onEnd(); // _initBoard();

            setState(() {
              _isShowingFlashCard = false;
              words = '';
            });
          });
    }
    var j = 0;
    return new LayoutBuilder(builder: (context, constraints) {

    final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

    return new Column(
      children: [
        new LimitedBox(
              maxHeight: maxHeight,
              child: new Material(
                  color: Colors.orange,
                  elevation: 4.0,
                  textStyle: new TextStyle(
                      color: Colors.white, fontSize: state.buttonFontSize,letterSpacing: 8.0),
                  child: new Container(
                  padding: EdgeInsets.all(buttonPadding),
                  child: new Center(
                    child: new Text(words),
                  ),
                ))),
          new Expanded(
           child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
          
                child: new ResponsiveGridView(
                  rows: _size,
                  cols: _size,
              //    maxAspectRatio: 1.0,
                  children: _letters
                      .map((e) =>Padding(
                            padding: EdgeInsets.all(buttonPadding),
                          child:_buildItem(j, e, _statuses[j], _ShakeCells[j++])))
                      .toList(growable: false),
                )))
      ],
    );});
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status, this.tile, this.onPress})
      : super(key: key);

  final String text;
  Status status;
  ShakeCell tile;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 10), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -1.0, end: 1.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _color = 0xFF5F9EA0;

    if (widget.tile == ShakeCell.Right) {
      _color = 0xFFff0000; // red
    }

    return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.tile == ShakeCell.Right
                ? animationWrong
                : animationRight,
            child: new ScaleTransition(
                scale: animationRight,
                child: new UnitButton(
                  disabled:widget.status==Status.Visible?true:false,
                  text: _displayText,
                  onPress: () => widget.onPress(),
                  unitMode: UnitMode.text,
                ))));
  }
}
