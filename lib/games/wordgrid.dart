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
  int currentindex = 0;
  int cdindex = 1;
  var progress = 0;
  var completeflag = 0;
  List<int> tempcd = [];
  List<String> disp = [];
  List<Widget> temp = [];
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
    // _copyAns=[];
    data = await fetchWordData(
        widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
    print('original data $data');
    print("this data 1 ${data.item1}");
    print('data 2 ${data.item2}');

    var f = 4;
    while (data.item1.length != _maxSize || data.item2.length != _otherSize) {
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
        _maxSize = 3;
        _otherSize = 1;
      }
      if (f == 5) {
        break;
      }
    }
    _size = sqrt(data.item1.length + data.item2.length).toInt();
    size = _size;
    print('original2 data  $data');
    print("this2 data 1 ${data.item1}");
    print('data2 2 ${data.item2}');
    // _statuses = numbers.map((a) => Status.Active).toList(growable: false);
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
      } else if (_size == 3) {
        start = rng.nextInt(cdlist.length - _size - (2 * (_size - 2)));
      } else {
        while (start < 1) {
          start = rng.nextInt(cdlist.length - _size - (2 * (_size - 3)));
        }
      }
      var cdstart = cdlist[start];
      int eflag = 1;
      while (eflag == 1) {
        eflag = 0;
        var p = cdstart.toInt();
        var q = ((cdstart - p) * 10).toInt();
        var len = 0;
        cdletters = [];
        //   print('rng   ${rng.nextInt(2)  }');
        while (len < data.item1.length) {
          cflag = 0;
          if (q + 1 < _size && rng.nextInt(2) == 0) {
            var f = 0;
            for (var i = 0; i < cdletters.length; i++) {
              if (p * _size + (q + 1) == cdletters[i]) {
                f = 1;
              }
            }
            if (f == 0) {
              cdletters.add(p * _size + (q + 1));
              q++;
            }
          } else if (p + 1 < _size && rng.nextInt(2) == 0) {
            var f = 0;
            for (var i = 0; i < cdletters.length; i++) {
              if ((p + 1) * _size + q == cdletters[i]) {
                f = 1;
              }
            }
            if (f == 0) {
              cdletters.add((p + 1) * _size + q);
              p++;
            }
          } else if (q - 1 >= 0) {
            var f = 0;
            for (var i = 0; i < cdletters.length; i++) {
              if (p * _size + (q - 1) == cdletters[i]) {
                f = 1;
              }
            }
            if (f == 0) {
              cdletters.add(p * _size + (q - 1));
              q--;
            }
          } else if (p - 1 >= 0) {
            var f = 0;
            for (var i = 0; i < cdletters.length; i++) {
              if ((p - 1) * _size + q == cdletters[i]) {
                f = 1;
              }
            }
            if (f == 0) {
              cdletters.add((p - 1) * _size + q);
              p--;
            }
          } else {
            print('exit 2 breakkkkk');
            cflag = 1;
            break;
          }
          len++;
        }
        if (cdletters.length != data.item1.length) {
          eflag = 1;
        }
      }
      print('nik new $cdletters  $start ${cdlist[start]}');
    }
    tempcd = [];
    for (var i = 0; i < cdletters.length; i++) {
      tempcd.add(cdletters[i]);
    }
    for (var i = 0; i < data.item1.length; i++) {
      disp.add(data.item1[i]);
    }
    newletters = [];
    newletters.length = data.item1.length + data.item2.length;
    for (var i = 0; i < cdletters.length; i++) {
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
    currentindex = 1;
    cdindex = 1;
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
          if (index != cdletters[0]) {
            clicks.add(index);

            print('qw $clicks');
            if (_statuses[index] == Status.Visible) {
              clicks.removeLast();
              if (clicks.last == index) {
                print('kkk  ${clicks.last}  index $index');
                if (cdletters[cdindex - 1] == index) {
                  setState(() {
                    widget.onScore(-1);
                    widget.onProgress(--cdindex / cdletters.length);
                  });
                }
                setState(() {
                  currentindex--;
                  _statuses[index] = Status.Active;
                });
                clicks.removeLast();
              }
            } else {
              print('hi  $cdindex');
               setState(() {  
                _statuses[index] = Status.Visible;  
              });
               currentindex++;
               print('got');
               if(cdindex+1<cdletters.length){
              if (cdletters[cdindex + 1] == index) {
                setState(() {
                  widget.onScore(2);
                  widget.onProgress(++cdindex / cdletters.length);
                });
              } 
               }           
            }
            print('current $currentindex  ${cdletters.length}');
            if (currentindex == cdletters.length) {

              var flag = 0;
              var c = 0;
              for (var j = 0; j < _statuses.length; j++) {
                if (_statuses[j] == Status.Visible) {
                  for (var k = 0; k < cdletters.length; k++) {
                    if (j == cdletters[k]) {
                      c++;
                      break;
                    } 
                  }
                }

                setState(() {
                  if (flag == 0 && c == cdletters.length) {
                    print('hi 56789');
                    completeflag = 1;
                    widget.onScore(2);
                    widget.onProgress(1.0);
                    new Future.delayed(const Duration(milliseconds: 1000), () {
                      setState(() {
                        _isShowingFlashCard = true; // widget.onEnd();
                      });
                    });
                  }
                });
              }
              // var pflag = 0;
              // for (var c = 0; c < cdletters.length; c++) {
              //   if (index == tempcd[c]) {
              //     progress++;
              //     tempcd[c] = -1;
              //     setState(() {
              //       widget.onScore(2);
              //       print('scxore   2');
              //       //  widget.onProgress(progress/cdletters.length);
              //     });
              //     break;
              //   } else {
              //     if (c == cdletters.length - 1) {
              //       pflag = 1;
              //     }
              //   }
              // }
              // if (pflag == 1 && _statuses[index] == Status.Visible) {
              //   setState(() {
              //     widget.onScore(-1);
              //     print('scxore   -1');
              //   });
              // }

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
          text: words,
          onChecked: () {
            widget.onEnd(); // _initBoard();

            setState(() {
              _isShowingFlashCard = false;
              words = '';
              disp = [];
              completeflag = 0;
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
                      color: Colors.white, fontSize: state.buttonFontSize),
                  child: new ListView(
                      // reverse: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(buttonPadding),
                      itemExtent: state.buttonWidth,
                      children: completeflag == 1
                          ? disp
                              .map((l) => Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(buttonPadding),
                                      child: UnitButton(
                                        text: l,
                                        primary: false,
                                        onPress: () {},
                                      ))))
                              .toList(growable: false)
                          : temp))),
          new Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: _size,
                    cols: _size,
                    //    maxAspectRatio: 1.0,
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
                  highlighted: widget.status == Status.Visible ? true : false,
                  text: _displayText,
                  onPress: () => widget.onPress(),
                  unitMode: UnitMode.text,
                  showHelp: false,
                ))));
  }
}
