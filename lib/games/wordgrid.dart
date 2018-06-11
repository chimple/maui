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
  int _maxSize;
  int _otherSize;
  var size, _size;
  String words = '';
  bool _isShowingFlashCard = false;
  List<Status> _statuses;
  bool _isLoading = true;
  List<double> cdlist = [];
  List<int> cdletters = [];
  List<String> newletters = [];
  List<String> newothers = [];
  Tuple2<List<String>, List<String>> data;
  int visible = 0;
  int cdindex = 1;
  var progress = 0;
  int endflag=0;
  List<ShakeCell> _ShakeCells = [];
  List<int> clicks = [];
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
    data = await fetchWordData(
        widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
    print('original data $data');
    print("this data 1 ${data.item1}");
    print('data 2 ${data.item2}');
    var f = 4;
    while (data.item1.length != _maxSize || data.item2.length<_otherSize) {
      print('hi');
      data = await fetchWordData(
          widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
      f--;
      if (f == 0) {
        print('hi22');
        _maxSize = 4;
        _otherSize = 5;
        f = 10;
      }
      if (f == 7) {
        print('lastttt dataa');
        _maxSize = 3;
        _otherSize = 1;
      }
      if (f == 5) {
        break;
      }
    }
    _size = sqrt(data.item1.length + _otherSize).toInt();
    size = _size;
    data.item1.forEach((e) {
      words = words + e;
    });
    var rng = new Random();
    cdlist = [];
    for (var i = 0; i < _size; i++) {
      for (var j = 0; j < _size; j++) {
        cdlist.add(i + j / 10);
      }
    }
    var cflag = 1;
    while (cflag == 1) {
      var start = 0;
      if (_size < 3) {
        if (rng.nextInt(3) == 1)
          start = 0;
        else
          start = 1;
      } else if (rng.nextInt(2) == 0) {
        start = rng.nextInt(2 * _size - 2);
      } else {
        start = rng.nextInt(_size * _size - _size);
      }

      var cdstart = cdlist[start];
      int eflag = 1;
      _fun(int m, int p, int q) {
        switch (m) {
          case 1:
            for (var i = 0; i < cdletters.length; i++) {
              if (p * _size + (q + 1) == cdletters[i]) {
                return false;
              }
            }
            return true;
          case 2:
            for (var i = 0; i < cdletters.length; i++) {
              if ((p + 1) * _size + q == cdletters[i]) {
                return false;
              }
            }
            return true;
          case 3:
            for (var i = 0; i < cdletters.length; i++) {
              if (p * _size + (q - 1) == cdletters[i]) {
                return false;
              }
            }
            return true;
          case 4:
            for (var i = 0; i < cdletters.length; i++) {
              if ((p - 1) * _size + q == cdletters[i]) {
                return false;
              }
            }
            return true;
        }
      }
      while (eflag == 1) {
        eflag = 0;
        var p = cdstart.toInt();
        var q = ((cdstart - p) * 10).toInt();
        var len = 0;
        var top=1;
        cdletters = [];
       var rand = rng.nextInt(4)==0||rng.nextInt(5)==0||rng.nextInt(3)==0;
       print('rand  $rand');
        while (len < data.item1.length) {
          cflag = 0;
          if (q + 1 < _size && _fun(1, p, q) && !rand && top<2) {
            cdletters.add(p * _size + (q + 1));
            q++;
            top=1;
          } else if (p + 1 < _size && _fun(2, p, q) && top<3) {
            cdletters.add((p + 1) * _size + q);
            p++;
            top=2;
          }else if(q + 1 < _size && _fun(1, p, q) && rand && top<2) {
            cdletters.add(p * _size + (q + 1));
            q++;
            top=1;
          } 
          else if (q - 1 >= 0 && _fun(3, p, q)&& top<4) {
            cdletters.add(p * _size + (q - 1));
            q--;
            top=3;
          } else if (p - 1 >= 0 && _fun(4, p, q)&& top<5) {
            cdletters.add((p - 1) * _size + q);
            p--;
            top=4;
          } else {
            print('exit 2 breakkkkk');
            cflag = 1;
            break;
          }
          len++;
          if(len>4){
            top=top;
          }
          else{
            top=1;
          }
        }
        if (cdletters.length != data.item1.length) {
          eflag = 1;
        }
      }
    }
    cdletters.add(cdletters.last);
    newletters = [];
    newletters.length = data.item1.length + _otherSize;
    print('new letters lenght ${newletters.length}');
    print('other lenght $_otherSize');
    for (var i = 0; i < cdletters.length - 1; i++) {
      newletters[cdletters[i]] = data.item1[i];
    }
    for (var i = 0, j = 0; i < newletters.length; i++) {
      if (newletters[i] == null) {
        newletters[i] = data.item2[j];
        j++;
      }
    }
    _statuses = [];
    _statuses = newletters.map((a) => Status.Active).toList(growable: false);
    _ShakeCells =
        newletters.map((a) => ShakeCell.InActive).toList(growable: false);
    visible = 1;
    cdindex = 1;
    clicks.add(cdletters[0]);
    _statuses[cdletters[0]] = Status.Visible;
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
          if (index != cdletters[0] && endflag==0) {
            clicks.add(index);
            print('clicks    $clicks    indexx  $index');
            if (_statuses[index] == Status.Visible) {
              clicks.removeLast();
              if (clicks.last == index) {
                setState(() {
                  visible--;
                  _statuses[index] = Status.Active;
                });
                clicks.removeLast();
              }
            } else {
              print('ff $clicks   ${clicks.length}   ');
              setState(() {
                print('nik $index  $cdindex  $cdletters ');
                 if (cdletters[cdindex] == index && clicks[clicks.length - 2]==cdletters[cdindex-1]) {
                  setState(() {
                    print('scoredddd');
                    widget.onScore(4);
                    widget.onProgress(++cdindex / (cdletters.length - 1));
                  });
                }
                else{
                  widget.onScore(-1);
                  print('score -1');
                }
                if (index == clicks[clicks.length - 2] + 1) {
                  if (index % _size != 0) {
                    _statuses[index] = Status.Visible;
                    visible++;
                  } else {
                    clicks.removeLast();
                    _ShakeCells[index] = ShakeCell.Right;
                    new Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        _ShakeCells[index] = ShakeCell.InActive;
                      });
                    });
                  }
                } else if (index == clicks[clicks.length - 2] - 1) {
                  if ((index + 1) % _size != 0) {
                    _statuses[index] = Status.Visible;
                    visible++;
                  } else {
                    clicks.removeLast();
                    _ShakeCells[index] = ShakeCell.Right;
                    new Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        _ShakeCells[index] = ShakeCell.InActive;
                      });
                    });
                  }
                } else if (index == clicks[clicks.length - 2] - _size) {
                  _statuses[index] = Status.Visible;
                  visible++;
                } else if (index == clicks[clicks.length - 2] + _size) {
                  _statuses[index] = Status.Visible;
                  visible++;
                } else {
                  clicks.removeLast();
                  _ShakeCells[index] = ShakeCell.Right;
                  new Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      _ShakeCells[index] = ShakeCell.InActive;
                    });
                  });
                }
              });
            }
            if (visible == cdletters.length - 1) {
              var flag = 0;
              var c = 0;
              for (var j = 0; j < _statuses.length; j++) {
                if (_statuses[j] == Status.Visible) {
                  for (var k = 0; k < cdletters.length - 1; k++) {
                    if (j == cdletters[k]) {
                      c++;
                      break;
                    }
                  }
                }
                setState(() {
                  if (flag == 0 && c == cdletters.length - 1) {
                    widget.onScore(4);
                    widget.onProgress(1.0);
                    endflag=1;
                    new Future.delayed(const Duration(milliseconds: 900), () {
                      setState(() {
                        _isShowingFlashCard = true; // widget.onEnd();
                      });
                    });
                  }
                });
              }
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

      if (_isShowingFlashCard) {
        return FractionallySizedBox(
            widthFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.9 : 0.65,
            heightFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.9 : 0.9,
            child: new FlashCard(
                text: words,
                image: words,
                onChecked: () {
                  widget.onEnd(); // _initBoard();
                  setState(() {
                    _isShowingFlashCard = false;
                    endflag=0;
                    words = '';
                  });
                }));
      }
      var j = 0;
      return new Column(
        children: [
          new LimitedBox(
              maxHeight: maxHeight,
              child: new Material(
                  color: Colors.orange,
                  elevation: 4.0,
                  textStyle: new TextStyle(
                      color: Colors.white,
                      fontSize: state.buttonFontSize / 1.3),
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(buttonPadding / 2.0),
                          child: UnitButton(
                            text: words,
                            bgImage: 'assets/dict/${words.toLowerCase()}.png',
                            primary: false,
                            onPress: () {},
                            unitMode: UnitMode.image,
                          ))))),
          new Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: _size,
                    cols: _size,
                    children: newletters
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(
                                j, e, _statuses[j], _ShakeCells[j++])))
                        .toList(growable: false),
                  )))
        ],
      );
    });
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
    animationWrong = new Tween(begin: -4.0, end: 4.0).animate(controller1);
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
                  highlighted: widget.status == Status.Visible ? true : false,
                  text: _displayText,
                  onPress: () => widget.onPress(),
                  unitMode: UnitMode.text,
                  showHelp: false,
                ))));
  }
}
