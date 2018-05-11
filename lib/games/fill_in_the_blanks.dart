import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'dart:math';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/flash_card.dart';

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
  int scoretrack = 0;
  String dragdata;
  List<String> dragBoxData, _holdDataOfDragBox, shuffleData, dragBoxDataStore;
  List<String> dropTargetData;
  List<Tuple2<String, String>> _fillData;
  List<String> ref;
  List<int> _flag = new List();
  String fruit = ' ';
  int indexOfDragText, indexOfTarget;
  @override
  void initState() {
    super.initState();
    _initFillBlanks();
  }

  List<String> shufflelist;
  int newprogress = 0;
  int count = 0;
  int dragcount = 0;
  int progres = 0;
  int space = 0;
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
    setState(() => _isLoading = false);
    _size = dragBoxData.length;
    _flag.length = dragBoxData.length + _size + 1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    for (int j = 0; j < dropTargetData.length; j++) {
      if (dropTargetData[j].isNotEmpty) count++;
    }
    for (int j = 0; j < dropTargetData.length; j++) {
      if (dropTargetData[j].isEmpty) dropTargetData[j] = '_';
    }
    space = dragBoxData.length - count;
    dragBoxData.shuffle();
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
            if (dropTargetData[index] == '_') {
              if (_holdDataOfDragBox[index] == data) {
                flag1 = 1;
                progres++;
                widget.onProgress(progres / space);
                dropTargetData[index] = _holdDataOfDragBox[indexOfDragText];
              } else {
                if(dropTargetData[index]=='_'){
                dragcount++;
                if (scoretrack > 0) {
                  scoretrack = scoretrack - 1;
                  widget.onScore(-1);
                } else {
                  widget.onScore(0);
                }
                }
              }
              if (progres == space) {
                scoretrack = scoretrack + 4;
                widget.onScore(4);
                new Future.delayed(const Duration(milliseconds: 400), () {
                  setState(() {
                    _isShowingFlashCard = true;
                  });
                });
              }
            } else {
               if(dropTargetData[index]=='_'){
              dragcount++;
              if (scoretrack > 0) {
                scoretrack = scoretrack - 1;
                widget.onScore(-1);
              } else {
                widget.onScore(0);
              }
               }
            }
            if (dragcount == space + 2) {
              new Future.delayed(const Duration(milliseconds: 700), () {
                setState(() {
                  _isShowingFlashCard = true;
                });
              });
            }

            setState(() {
               if(dropTargetData[index]=='_')
              {
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
          data = text;
          indexOfDragText = _holdDataOfDragBox.indexOf(text);
        });
  }

  @override
  void didUpdateWidget(FillInTheBlanks oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      _initFillBlanks();
    }
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
    if (_isShowingFlashCard) {
      return new FlashCard(
          text: fruit,
          onChecked: () {
            widget.onEnd();
            setState(() {
              _isShowingFlashCard = false;
            });
          });
    }
    print("space is $space");
    if (space == 0) {
      setState(() {
        _initFillBlanks();
      });
    }
    var j = 0, k = 100, h = 0, a = 0;
    var maxChars = _size *
        (_holdDataOfDragBox != null
            ? _holdDataOfDragBox.fold(
            1,
                (prev, element) =>
            element.length > prev ? element.length : prev)
            : 1);
     MediaQueryData media = MediaQuery.of(context);
    return new Container(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Padding(padding: new EdgeInsets.all(10.0)),
            new Expanded(
              flex: 1,
              child: new Container(
                color: new Color(0xffffa3bc8b),
                child: new ResponsiveGridView(
                  rows: 1,
                  padding: media.orientation==Orientation.portrait?dropTargetData.length<5?80.0:20.0:dropTargetData.length<dropTargetData.length*2?0.0:80.0,
                  maxChars: maxChars,
                  cols: dropTargetData.length,
                  maxAspectRatio: 1.0,
                  children: dropTargetData
                      .map((e) => droptarget(j++, e, _flag[h++]))
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
                  maxChars: maxChars,
                //  padding: 10.0,
                  children: dragBoxData
                      .map((e) => dragbox(k++, e, _flag[a++]))
                      .toList(growable: false)),
            ),
          ],
        ),
      ),
    );
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
      this.arr,
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
  List arr;
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
  String _displayText;
  initState() {
    super.initState();
    _displayText = widget.text;
    //_displayText = widget.text;
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
    int portf = 0;
    MediaQueryData media = MediaQuery.of(context);
    if (media.size.height < media.size.width) {
      portf = 1;
    }
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
              return new Center(
                child: new Text(widget.text,
                    key: new Key('${widget.keys}'),
                    style: new TextStyle(
                        color:  new Color(0xffDD6154),
                        fontSize: media.size.height * 0.06)),
              );
            },
          ),
        ),
      );
    } else if (widget.index >= 100) {
      return new ScaleTransition(
        scale: animation,
        child: new Container(
          decoration: new BoxDecoration(
            //  color: new Color(0xffffffffff),
            border: new Border.all(width: 3.0, color: new Color(0xffDD6154)),
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
          ),
          child: new Center(
              child: new Draggable(
                  onDragStarted: widget.onDrag,
                  maxSimultaneousDrags: 1,
                
                  data: '${widget.index}' + '_' + '${widget.code}',
                  child: new Center(
                    child: new Container(
                      height:media.orientation==Orientation.portrait?widget.length>10?media.size.height * 0.01:media.size.height*0.06:media.size.height*0.13,
                      width: media.orientation==Orientation.portrait?widget.length>10?media.size.width * 0.1:media.size.width*0.06:media.size.width*0.07,
                     
                      child: new Center(
                        child: new Text(widget.text,
                            key: new Key("A${widget.keys}"),
                            style: new TextStyle(
                                color:  new Color(0xffDD6154),
                                fontSize: media.size.height * 0.04)),
                      ),
                    ),
                  ),
                  feedback: new Transform.rotate(
                    angle: widget.isRotated == true
                        ? portf == 0 ? 3.14 : 0.0
                        : 0.3,
                    child: new Text(
                      widget.text,
                      style: new TextStyle(
                        color:  new Color(0xffDD6154),
                        decoration: TextDecoration.none,
                        fontSize: media.size.height * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))),
        ),
      );
    }
  }
}
