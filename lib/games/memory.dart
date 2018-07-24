import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/flip_animator.dart';
import '../components/responsive_grid_view.dart';
import '../components/shaker.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/gameaudio.dart';

bool initialVisibility = false;

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
  var _clickCnt = 0;
  int _firstClickedId;
  int _secondClickedId;
  int _allLettersUpperCaseTriggred = 0;
  int _allLettersLowerCaseTriggred = 0;

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
    if (_data.length == 2 ||
        _data.length == 3 ||
        _data.length == 4 ||
        _data.length == 5 ||
        _data.length == 6 ||
        _data.length == 7) {
      _maxSize = 2;
    }
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
        _allLetters.take(_size * _size).toList(growable: false)..shuffle());
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
    super.didUpdateWidget(oldWidget);
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      initialVisibility = true;
      _allLetters.clear();
      _letters.clear();
      _initBoard();
      print("Rajesh-Data-didUpdateWidget${_allLetters}");
    }
  }

  Widget _buildItem(int index, String text, int maxChars, double maxWidth,
      double maxHeight, Status status, ShakeCell shaker) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        shaker: shaker,
        unitMode: widget.gameConfig.questionUnitMode,
        onPress: () {
          print("Pressed Index: ${index}");
          print("Pressed Text: ${text}");
          print("Pressed Statuses before checking: ${_statuses}");
          print("maxSize Size ${_maxSize}");
          print("_size Size ${_size}");
          print("initialVisibility ${initialVisibility}");

          if (initialVisibility == true) return;

          if (_statuses[index] == Status.Disappear) return;

          int numOfVisible = _statuses.fold(0,
              (prev, element) => element == Status.Visible ? prev + 1 : prev);

          if (_pressedTileIndex == index ||
              _statuses[index] == Status.Visible ||
              numOfVisible >= 2 ||
              _clickCnt > 2) return;

          _clickCnt++;

          setState(() {
            _statuses[index] = Status.Visible;
          });

          print("Pressed Statuses1: ${_statuses}");

          if (_clickCnt == 2) {
            if (_allLettersUpperCaseTriggred == 1) {
              _secondClickedId = _allLettersLowerCase.indexOf(text);
              _allLettersUpperCaseTriggred = 0;
            } else {
              _firstClickedId = _allLettersUpperCase.indexOf(text);
              _allLettersLowerCaseTriggred = 0;
            }
            if (_firstClickedId == _secondClickedId) {
              print("Olaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
              new Future.delayed(const Duration(milliseconds: 250), () {
                setState(() {
                  _letters[_pressedTileIndex] = null;
                  _letters[index] = null;
                  _statuses[_pressedTileIndex] = Status.Disappear;
                  _statuses[index] = Status.Disappear;
                  _pressedTileIndex = -1;
                  _pressedTile = null;
                  _clickCnt = 0;
                });
              });
              _matched++;
              widget.onScore(2);
              widget.onProgress((_progressCnt) / ((_size * _size) / 2));
              _progressCnt++;

              print("Rajesh-Matched${_matched}");
              if (_matched == ((_size * _size) / 2)) {
                _matched = 0;
                _progressCnt = 1;
                new Future.delayed(const Duration(milliseconds: 250), () {
                  print("Rajesh Game-End");
                  widget.onEnd();
                });
              }
              print("Pressed Statuses2: ${_statuses}");
              print("Matched");
            } else {
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
                  _clickCnt = 0;
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
          if (_allLettersUpperCase.indexOf(_pressedTile) >= 0) {
            _firstClickedId = _allLettersUpperCase.indexOf(_pressedTile);
            _allLettersUpperCaseTriggred = 1;
          } else {
            _secondClickedId = _allLettersLowerCase.indexOf(_pressedTile);
            _allLettersLowerCaseTriggred = 1;
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
    final maxChars = (_allLetters != null
        ? _allLetters.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);

    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

      return new Padding(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          child: ResponsiveGridView(
            rows: _size,
            cols: _size,
            children: _letters
                .map((e) => Padding(
                    padding: EdgeInsets.all(buttonPadding),
                    child: _buildItem(j, e, maxChars, maxWidth, maxHeight,
                        _statuses[j], _shaker[j++])))
                .toList(growable: false),
          ));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.status,
      this.shaker,
      this.unitMode,
      this.onPress})
      : super(key: key);

  final String text;
  Status status;
  ShakeCell shaker;
  final VoidCallback onPress;
  UnitMode unitMode;

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
    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    shakeController = new AnimationController(
        duration: new Duration(milliseconds: 50), vsync: this);
    flipController = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    noAnimation = new Tween(begin: 0.0, end: 0.0).animate(shakeController);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticInOut)
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

    initialVisibility = true;
    controller.forward().then((f) {
      flipController.forward();
      new Future.delayed(const Duration(milliseconds: 2000), () {
        flipController.reverse();
        initialVisibility = false;
      });
    });

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
    flipController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("_MyButtonState.didUpdateWidget: ${oldWidget.text} ${widget.text} ");
    print("Rajesh");
    if (oldWidget.text == null && widget.text != null) {
      flipController.reverse();
      print("Rajesh1");
      _displayText = widget.text;
      flipController.forward();
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
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new ScaleTransition(
      scale: animation,
      child: new Shake(
          animation:
              widget.shaker == ShakeCell.Wrong ? shakeAnimation : animation,
          child: new FlipAnimator(
              controller: flipController,
              front: new ScaleTransition(
                  scale: animation,
                  child: new UnitButton(
                    onPress: widget.onPress,
                    text: _displayText,
                    unitMode: widget.unitMode,
                    disabled: widget.status == Status.Disappear ? true : false,
                  )),
              back: new UnitButton(
                onPress: widget.onPress,
                text: ' ',
                unitMode: null,
              ))),
    );
  }
}
