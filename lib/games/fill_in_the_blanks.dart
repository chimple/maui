import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
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
      this.isRotated=false
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new FillInTheBlanksState();
}

class FillInTheBlanksState extends State<FillInTheBlanks> {
  bool _isLoading = true;
  var flag1 = 0;
  bool _isShowingFlashCard = false;
  var keys = 0;
  int _size;
  List<String> dragBoxData, _holdDataOfDragBox, shuffleData, dragBoxDataStore;
  List<String> dropTargetData;
  //List<Status> _statusShake;
  List<Tuple2<String, String>> _fillData;
  List<String> ref;
  List<int> _flag = new List();
  String fruit;
  int indexOfDragText, indexOfTarget;
  @override
  void initState() {
    super.initState();
    _initFillBlanks();
  }

  List<String> shufflelist;
  int newprogress = 0;
  int count = 0;
  int progres = 0;
  void _initFillBlanks() async {
    count = 0;
    progres = 0;
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

    print("dragbox data$dragBoxData");
    print("drop box $dropTargetData");
    setState(() => _isLoading = false);
    _size = dragBoxData.length;
    _flag.length = dragBoxData.length + _size + 1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    for (int j = 0; j < dropTargetData.length; j++) {
      if (dropTargetData[j].isNotEmpty) count++;
    }
    count = dropTargetData.length - count;
    dragBoxData.shuffle();
  }

  @override
  void didUpdateWidget(FillInTheBlanks oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      _initFillBlanks();
    }
  }

  Widget droptarget(int index, String text, int flag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        onAccepted: (targetindex) {
          print(targetindex);
          print(index);
          print(indexOfDragText);
          flag1 = 0;
          var flagtemp = 0;
          print("Text of darg :: ${text}");
          if (index == indexOfDragText) {
            flag1 = 1;
            progres++;
            widget.onProgress(progres / count);
            dropTargetData[index] = _holdDataOfDragBox[indexOfDragText];
            dragBoxData[targetindex - 100] = '1';
            _holdDataOfDragBox[indexOfDragText] = ' ';
          }
          if (progres == count) {
            widget.onScore(2);
            widget.onEnd();
          }

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
        },
        flag: flag,
        keys: keys++);
  }

  Widget dragbox(int index, String text, int flag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        flag: flag,
        keys: keys++,
        onDrag: () {
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

    var j = 0, k = 100, h = 0, a = 0;

    return new Container(
      padding: new EdgeInsets.all(2.0),
      color: Colors.green[300],
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new ResponsiveGridView(
                rows: 1,
                cols: dropTargetData.length,
                children: dropTargetData
                    .map((e) => droptarget(j++, e, _flag[h++]))
                    .toList(growable: false),
              ),
            ),
            new Padding(padding: new EdgeInsets.all(20.0)),
            new Expanded(
              child: new ResponsiveGridView(
                  rows: 1,
                  cols: dropTargetData.length,
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
      this.onDrag,
      this.isRotated = false,
      this.keys})
      : super(key: key);

  var index;
  final int color1;
  final int flag;

  final String text;
  List arr;
   bool isRotated;
  int keys;
  final DragTargetAccept onAccepted;
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controllerShake;
  Animation<double> animation, animationShake;
  initState() {
    super.initState();
    controllerShake = new AnimationController(
        duration: new Duration(microseconds: 500), vsync: this);
    animationShake = new Tween(end: -1.0, begin: 1.0).animate(controllerShake);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
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
    widget.keys++;
    //print("value ${widget.keys}");
    //print('build of MyButton: ${widget.index} ${widget.text}');
    if (widget.index < 100) {
      return new Shake(
          animation: widget.flag == 1 ? animationShake : animation,
          child: new ScaleTransition(
            scale: animation,
            child: new Container(
              decoration: new BoxDecoration(
                color: widget.color1 == 1 ? Colors.white : Colors.purple[300],
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new DragTarget(
                onAccept: (int data) => widget.onAccepted(data),
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return new Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                          width: 3.0,
                          color: accepted.isEmpty
                              ? Colors.grey
                              : Colors.cyan[300]),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0)),
                    ),
                    child: new Center(
                      child: new Text(widget.text,
                          key: new Key('${widget.keys}'),
                          style: new TextStyle(
                              color: Colors.black, fontSize: 24.0)),
                    ),
                  );
                },
              ),
            ),
          ));
    } else if (widget.index >= 100 && widget.text == '1') {
      return new Container(
        color: Colors.green[300],
      );
    } else if (widget.index >= 100) {
      return new Draggable(
          onDragStarted: widget.onDrag,
          data: widget.index,
          child: new ScaleTransition(
            scale: animation,
            child: new Container(
                decoration: new BoxDecoration(
                  color: widget.color1 == 1 ? Colors.white : Colors.purple[300],
                  border: new Border.all(width: 1.0, color: Colors.cyan[300]),
                  borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                ),
                child: new Center(
                  child: new Text(widget.text,
                      key: new Key("A${widget.keys}"),
                      style:
                          new TextStyle(color: Colors.black, fontSize: 24.0)),
                  //   ),
                )),
          ),
          feedback: new Container(
            height: 60.0,
            width: 60.0,
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                color: Colors.yellow[400]),
            child: new Center(
              child: new Text(
                widget.text,
                style: new TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 26.0,
                ),
              ),
            ),
          ));
    }
  }
}
