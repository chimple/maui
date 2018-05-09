import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/flip_animator.dart';
import '../components/responsive_grid_view.dart';
import '../components/shaker.dart';

class Memory extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Memory(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new MemoryState();
}

enum Status { Hidden, Visible, Disappear }
enum ShakeCell { Right, Wrong }

class MemoryState extends State<Memory> {
  int _size = 4;
  int _maxSize = 4;
  List<String> _allLetters = [];
  List<String> _allLettersUpperCase = [];
  List<String> _allLettersLowerCase = [];
  List<String> _shuffledLetters = [];
  List<String> _letters;
  List<Status> _statuses;
  List<ShakeCell> _shaker;
  Map<String, String> _data;
  bool _isLoading = true;
  var _matched = 0;
  var _progressCnt = 1;
  var _pressedTile;
  var _pressedTileIndex;
  var cnt = 0;
  int var1, var2, flag1=0, flag2 = 0;

  @override
  void initState() {
    super.initState();
    print('MemoryState:initState');
     if (widget.gameConfig.level < 4) {
      _maxSize = 2;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 8;
    } else {
      _maxSize = 8;
    }
    _initBoard();
  }

  void _initBoard() async {
    print("Statuses Before Emtying  _stauses: ${_statuses}");
    setState(() => _isLoading = true);
    _data = await fetchPairData(widget.gameConfig.gameCategoryId, _maxSize);
    print("Rajesh-Data-initBoardCall: ${_data}");

    _allLetters = [];
    _data.forEach((k, v) {
      _allLetters.add(k);
      _allLettersUpperCase.add(k);
      _allLetters.add(v);
      _allLettersLowerCase.add(v);
    });
    
    print("Rajesh-Data-after-Mapping: ${_allLetters}");
    print("Rajesh-Data-after-Mapping _allletters1: ${_allLettersUpperCase}");
    print("Rajesh-Data-after-Mapping _allLetters2: ${_allLettersLowerCase}");

    _size = min(_maxSize, sqrt(_allLetters.length).floor());
    _shuffledLetters = [];
    _shuffledLetters.addAll(
          _allLetters.take(_size * _size).toList(growable: false)
            ..shuffle());
    print("Rajesh-Data-after-Shuffling: ${_shuffledLetters}");
    _letters = _shuffledLetters.sublist(0, _size * _size);
    _statuses = [];
    print("Statuses After Emtying _stauses: ${_statuses}");
    _statuses = _letters.map((a) => Status.Hidden).toList(growable: false);
    print("Statuses After Mapping _stauses: ${_statuses}");
    _shaker = [];
    _shaker = _letters.map((a) => ShakeCell.Right).toList(growable: false);
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Memory oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print("Rajesh-Data-didUpdateWidget${_allLetters}");
    }
  }

  Widget _buildItem(int index, String text, Status status, ShakeCell shaker) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        shaker: shaker,
        onPress: () {
          print("Pressed Index: ${index}");
          print("Pressed Text: ${text}");
          print("Pressed Statuses before checking: ${_statuses}");

          if(_statuses[index] == Status.Disappear)
           return;

          int numOfVisible = _statuses.fold(0,(prev, element) => element == Status.Visible ? prev + 1 : prev);

          if (_pressedTileIndex == index || _statuses[index] == Status.Visible || numOfVisible >= 2 || cnt > 2) 
            return;

          cnt++;

          setState(() {
            _statuses[index] = Status.Visible;
          });

          print("Pressed Statuses1: ${_statuses}");

          if (cnt == 2) {
              if (flag1==1)
              {
                var2=_allLettersUpperCase.indexOf(text);
                flag1=0;
              }
              else {
                var1=_allLettersLowerCase.indexOf(text);
                flag2=0;
              }

             if(var1 == var2) {
                print("Olaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                new Future.delayed(const Duration(milliseconds: 250), () {
                  setState(() {
                    _letters[_pressedTileIndex] = null;
                    _letters[index] = null;
                    _statuses[_pressedTileIndex] = Status.Disappear;
                    _statuses[index] = Status.Disappear;
                    _pressedTileIndex = -1;
                    _pressedTile = null;
                    cnt = 0;
                  });
              });

              _matched++;
              widget.onScore(2);
              widget.onProgress((_progressCnt) / ((_maxSize*_maxSize)/2));
              _progressCnt++;

              print("Rajesh-Matched${_matched}");
              if (_matched == ((_maxSize*_maxSize)/2)) {
                _matched = 0;
                new Future.delayed(const Duration(milliseconds: 250), () {
                  print("Rajesh Game-End");
                  widget.onEnd();
                });
              }
              print("Pressed Statuses2: ${_statuses}");
              print("Matched");
             }
             else {
              new Future.delayed(const Duration(milliseconds: 50), () {
                setState(() {
                  _shaker[_pressedTileIndex] = ShakeCell.Wrong;
                  _shaker[index] = ShakeCell.Wrong;
                });
              }); 

              new Future.delayed(const Duration(milliseconds: 700), () {
                setState(() {
                  _shaker[_pressedTileIndex] = ShakeCell.Right;
                  _shaker[index] = ShakeCell.Right;
                });
              });

              new Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  _statuses[_pressedTileIndex] = Status.Hidden;
                  _statuses[index] = Status.Hidden;
                  _pressedTileIndex = -1;
                  _pressedTile = null;
                  cnt = 0;
                });
                print("Pressed Statuses3: ${_statuses}");
              });

              print("Unmatched");
             }
           
            print("Pressed Statuses4: ${_statuses}");
            return;
          }
          _pressedTileIndex = index;
          _pressedTile = text;
          if (_allLettersLowerCase.indexOf(_pressedTile) >= 0)
          {
            var1 = _allLettersLowerCase.indexOf(_pressedTile);
            flag1 = 1;
           }
          else {
            var2 = _allLettersUpperCase.indexOf(_pressedTile);
            flag2 = 1;
          }
     });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    int j = 0;
    return new ResponsiveGridView(
      rows: _size,
      cols: _size,
      children: _letters
          .map((e) => _buildItem(j, e, _statuses[j], _shaker[j++]))
          .toList(growable: false),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.status, this.shaker, this.onPress}) : super(key: key);

  final String text;
  Status status;
  ShakeCell shaker;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, shakeController;
  Animation<double> animation, shakeAnimation, noAnimation;
  AnimationController flipController;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(duration: new Duration(milliseconds: 800), vsync: this);
    shakeController = new AnimationController(duration: new Duration(milliseconds: 50), vsync: this);
    flipController = new AnimationController(duration: new Duration(milliseconds: 250), vsync: this);
    noAnimation = new Tween(begin: 0.0,end:0.0).animate(shakeController);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward().then((f){flipController.reverse();});

    shakeAnimation = new Tween(begin: -6.0, end: 4.0).animate(shakeController);
    _myAnim();
  }

  void _myAnim() {
    shakeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        shakeController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        shakeController.forward();
      }
    });
    shakeController.forward();
  }

   @override
  void dispose() {
    shakeController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    print("Rajesh");
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == null && widget.text != null) {
        flipController.reverse();
       print("Rajesh1");
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
       print("Rajesh2");
      //controller.reverse();
    } else {
       print("Rajesh3");
      if (oldWidget.status != widget.status) {
         print("Rajesh4");
        if (widget.status == Status.Visible) {
           print("Rajesh5");
          flipController.forward();
        } else {
           print("Rajesh6");
          flipController.reverse();
        }
      }
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new ScaleTransition(
      scale: animation,
          child: new Shake(
          animation: widget.shaker == ShakeCell.Wrong ? shakeAnimation : animation,
          child: new FlipAnimator(
              controller: flipController,
              front: new ScaleTransition(
                  scale: animation,
                  child: new UnitButton(
                    onPress: widget.onPress,
                    text: _displayText,
                    unitMode: UnitMode.text,
                   )),
              back: new UnitButton(
                    onPress: widget.onPress,
                    text: ' ',
                    unitMode: UnitMode.text,
                   ))),
    );
  }
}
