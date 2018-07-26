import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'dart:math';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/gameaudio.dart';

class FillInTheBlanks extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  bool isRotated;
  int iteration;
  int gameCategoryId;
  FillInTheBlanks(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new FillInTheBlanksState();
}

class FillInTheBlanksState extends State<FillInTheBlanks> {
  bool _isLoading = true;
  var flag1 = 0;
  int code, dcode, dindex;
  bool _isShowingFlashCard = false;
  var keys = 0;
  int _size;
  String dragdata;
  List<String> dragBoxData, _holdDataOfDragBox, shuffleData, dragBoxDataStore;
  List<String> dropTargetData;
  List<Tuple2<String, String>> _fillData;
  List _correct = [];
  List<int> _flag = new List();
  String fruit = ' ';
  int indexOfDragText, indexOfTarget;
  @override
  void initState() {
    super.initState();
    _initFillBlanks();
  }

  int count = 0;
  int dragcount = 0;
  int progres = 0;
  int space = 0;
  @override
  void didUpdateWidget(FillInTheBlanks oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _correct.clear();
      _initFillBlanks();
    }
  }

  void _initFillBlanks() async {
    count = 0;
    progres = 0;
    fruit = ' ';
    dragcount = 0;
    space = 0;
    setState(() => _isLoading = true);
    _fillData = await fetchWordWithBlanksData(widget.gameCategoryId);
    dragBoxData = _fillData.map((f) {
      return f.item2;
    }).toList(growable: false);
    _holdDataOfDragBox = _fillData.map((f) {
      return f.item2;
    }).toList(growable: false);
    dropTargetData = _fillData.map((f) {
      return f.item1;
    }).toList(growable: false);
    for (var i = 0; i < dragBoxData.length; i++) {
      if (dropTargetData[i] == '') {
        fruit = fruit + _holdDataOfDragBox[i];
      } else {
        fruit = fruit + dropTargetData[i];
      }
    }
    var rng = new Random();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    _size = dragBoxData.length;
    _flag.length = dragBoxData.length + _size + 1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    for (int j = 0; j < dropTargetData.length; j++) {
      if (dropTargetData[j].isNotEmpty) count++;
    }
    for (int i = 0; i < dragBoxData.length; i++) {
      if (dropTargetData[i].isEmpty) {
        _correct.add(dragBoxData[i]);
        _correct.add(i);
      }
    }
    for (int j = 0; j < dropTargetData.length; j++) {
      if (dropTargetData[j].isEmpty) dropTargetData[j] = '_';
    }

    space = dragBoxData.length - count;
    dragBoxData.shuffle();
    setState(() => _isLoading = false);
  }

  String data;
  Widget droptarget(int index, String text, int flag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        onAccepted: (dcindex) {
          flag1 = 0;
          var flagtemp = 0;
          dragdata = dcindex;
          dindex = int.parse(dragdata.substring(0, 3));
          dcode = int.parse(dragdata.substring(4));
          if (code == dcode) {
            var i = 0;
            for (; i < _correct.length; i++) {
              if (dragBoxData[dindex - 100] == _correct[i] &&
                  index == _correct[++i] &&
                  dropTargetData[index] == '_') {
                flag1 = 1;
                break;
              }
            }
            if (flag1 == 1) {
              print('correct');
              progres++;
              widget.onProgress(progres / space);
              dropTargetData[index] = _correct[--i];
            } else {
              if (dropTargetData[index] == '_') {
                dragcount++;
                widget.onScore(-1);
              }
            }
            if (progres == space) {
              widget.onScore(4);
              new Future.delayed(const Duration(milliseconds: 400), () {
                setState(() {
                  _isShowingFlashCard = true;
                });
              });
            }
            if (dragcount == space + 2) {
              new Future.delayed(const Duration(milliseconds: 700), () {
                setState(() {
                  _isShowingFlashCard = true;
                });
              });
            }
            setState(() {
              if (dropTargetData[index] == '_') {
                if (flag1 == 0) {
                  _flag[index] = 1;
                  if (dropTargetData[index] == '') {
                    dropTargetData[index] = _holdDataOfDragBox[indexOfDragText];
                    flagtemp = 1;
                  }
                  new Future.delayed(const Duration(milliseconds: 400), () {
                    setState(() {
                      _flag[index] = 0;
                      if (flagtemp == 1) {
                        dropTargetData[index] = '';
                        flagtemp = 0;
                      }
                    });
                  });
                }
              }
            });
          }
        },
        flag: flag,
        code: code,
        length: dropTargetData.length,
        isRotated: widget.isRotated,
        keys: keys++);
  }

  Widget dragbox(int index, String text, int flag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        code: code,
        flag: flag,
        length: dragBoxData.length,
        isRotated: widget.isRotated,
        keys: keys++,
        onDrag: () {
          setState(() {});
          data = text;
          indexOfDragText = _holdDataOfDragBox.indexOf(text);
        });
  }

  @override
  Widget build(BuildContext context) {
    keys = 0;
    if (_isLoading) {
      return new SizedBox(
        width: 5.0,
        height: 5.0,
        child: new CircularProgressIndicator(),
      );
    }

    if (space == 0) {
      setState(() {
        _initFillBlanks();
      });
    }
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = 0.0, maxHeight = 0.0;
      maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      maxHeight = (constraints.maxHeight - vPadding * 2) / _size;
      var j = 0, k = 100, h = 0, a = 0;
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      if (_isShowingFlashCard) {
        return FractionallySizedBox(
          widthFactor:
              constraints.maxHeight > constraints.maxWidth ? 0.8 : 0.65,
          heightFactor:
              constraints.maxHeight > constraints.maxWidth ? 0.6 : 0.75,
          child: new FlashCard(
              text: fruit,
              onChecked: () {
                widget.onEnd();
                setState(() {
                  _isShowingFlashCard = false;
                });
              }),
        );
      }

      return new Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Container(
              color: new Color(0xffffa3bc8b),
              child: new ResponsiveGridView(
                rows: 1,
                cols: dropTargetData.length,
                maxAspectRatio: 1.0,
                children: dropTargetData
                    .map((e) => Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: droptarget(j++, e, _flag[h++])))
                    .toList(growable: false),
              ),
            ),
          ),
          new Expanded(
            flex: 2,
            child: new ResponsiveGridView(
                rows: 1,
                cols: dragBoxData.length,
                maxAspectRatio: 1.0,
                padding: 10.0,
                children: dragBoxData
                    .map((e) => Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: dragbox(k++, e, _flag[a++])))
                    .toList(growable: false)),
          ),
        ],
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.code,
      this.length,
      this.onDrag,
      this.isRotated = false,
      this.keys})
      : super(key: key);
  var index;
  final int color1;
  final int flag;
  final int length;
  final String text;
  final int code;
  bool isRotated;
  int keys;
  final DragTargetAccept onAccepted;
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controllerShake, controllerDrag;
  Animation<double> animation, animationShake, animationDrag;
  bool isDragging = false;

  String _displayText;
  initState() {
    super.initState();
    _displayText = widget.text;
    controllerShake = new AnimationController(
        duration: new Duration(milliseconds: 60), vsync: this);
    animationShake = new Tween(end: -5.0, begin: 5.0).animate(controllerShake);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 400), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    shake();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerShake.dispose();
    super.dispose();
  }

  void shake() {
    animationShake.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        controllerShake.reverse();
      } else if (state == AnimationStatus.dismissed) {
        controllerShake.forward();
      }
    });
    controllerShake.forward();
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    widget.keys++;
    if (widget.index < 100) {
      return new Shake(
        animation: widget.flag == 1 ? animationShake : animation,
        child: new ScaleTransition(
          scale: animation,
          child: new DragTarget(
            onAccept: (String data) => widget.onAccepted(data),
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return new UnitButton(
                key: new Key('A${widget.keys}'),
                text: widget.text,
                showHelp: false,
                highlighted: widget.flag == 1 ? true : false,
              );
            },
          ),
        ),
      );
    } else if (widget.index >= 100) {
      return new ScaleTransition(
        scale: animation,
        child: new Draggable(
            onDragStarted: () {
              if (ButtonStateContainer.of(context).startUsingButton()) {
                setState(() {
                  isDragging = true;
                });
                print(
                    'onDragStarted ${widget.text} $isDragging ${ButtonStateContainer.of(context).isButtonBeingUsed}');
                widget.onDrag();
              }
            },
            onDragCompleted: () {
              print(
                  'onDragCompleted start ${widget.text} $isDragging ${ButtonStateContainer.of(context).isButtonBeingUsed}');
              if (isDragging) {
                setState(() {
                  isDragging = false;
                });
                ButtonStateContainer.of(context).endUsingButton();
                print(
                    'onDragCompleted end ${widget.text} $isDragging ${ButtonStateContainer.of(context).isButtonBeingUsed}');
              }
            },
            onDraggableCanceled: (Velocity v, Offset o) {
              print('onDraggableCanceled ${widget.text} $isDragging');
              if (isDragging) {
                setState(() {
                  isDragging = false;
                });
                ButtonStateContainer.of(context).endUsingButton();
              }
            },
            maxSimultaneousDrags: (isDragging ||
                    !ButtonStateContainer.of(context).isButtonBeingUsed)
                ? 1
                : 0,
            data: '${widget.index}' + '_' + '${widget.code}',
            child: new UnitButton(
              key: new Key('A${widget.keys}'),
              text: widget.text,
              showHelp: false,
            ),
            feedback: new Transform.rotate(
              angle: 0.2,
              child: new UnitButton(
                text: widget.text,
                maxHeight: buttonConfig.height,
                maxWidth: buttonConfig.width,
                fontSize: buttonConfig.fontSize,
              ),
            )),
      );
    }
  }
}
