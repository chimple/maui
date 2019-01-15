import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/button_state_container.dart';

class BasicAddition extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  BasicAddition(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  _BasicAdditionState createState() => _BasicAdditionState();
}

class _BasicAdditionState extends State<BasicAddition> {
  List arr1 = ["6", "+", "6"];
  List ans = [
    "12",
  ];
  List<String> listOfNumbers = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
  ];

  int code;
  bool _isLoading = true;
  String img, dragdata;
  int dindex, dcode;
  var flag1;
  List<bool> _isDropped = new List();
  List dataValues = new List();
  var checkdata;
  List dropTargetValues = new List();
  initState() {
    super.initState();
    initfn();
  }

  initfn() {
    setState(() => _isLoading = true);

    String ansData = ans.first;
    dataValues = ansData.split('');

    int temp = 0;
    while (temp < dataValues.length) {
      if (temp < dataValues.length) _isDropped.add(false);
      dropTargetValues.add(null);
      temp++;
    }

    var rng = new Random();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }

    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, compValue) {
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      code: code,
      onDrag: () {
        setState(() {});
      },
      isRotated: widget.isRotated,
      text: text,
      onAccepted: (data) {
        flag1 = 0;
        dragdata = data;

        String valueText =
            dragdata.substring(dragdata.length - 1, dragdata.length);

        dindex = int.parse(dragdata.substring(0, 3));

        dcode = int.parse(dragdata.substring(4, 7));

        if (code == dcode) {
          int findex = dindex - 100;
          print('gg $index ${_isDropped[index]} $index');
          if (valueText == compValue) {
            //right

            setState(() {
              _isDropped[index] = true;
              dropTargetValues[index] = listOfNumbers[findex];
            });
          } else if (_isDropped[index] == false) {
            // wrong
          } else if (_isDropped[index] == true) {
            // do nothing;
          }
        }
      },
    );
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
      double maxWidth = 0.0, maxHeight = 0.0;
      maxWidth = (constraints.maxWidth - hPadding * 2) / 4;
      maxHeight = (constraints.maxHeight - vPadding * 2) / 4;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      int j = 0;
      int inc = 0;
      int k = 100;
      return new Container(
          child: new Column(

              // portrait mode
              children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  color: Colors.red,
                  height: constraints.maxHeight / 2,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: new ResponsiveGridView(
                        rows: 1,
                        cols: arr1.length,
                        children: arr1
                            .map(
                              (e) => new Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: buildQuestion(
                                      j++,
                                      e,
                                      (constraints.maxHeight / 2) * 0.2,
                                    ),
                                  ),
                            )
                            .toList(growable: false),
                      ))),
            ),
            Expanded(
              flex: 2,
              child: Column(children: [
                new Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: ResponsiveGridView(
                        rows: 1,
                        cols: 4,
                        children: dropTargetValues
                            .map(
                              (e) => Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child:
                                        _buildItem(inc, e, dataValues[inc++]),
                                  ),
                            )
                            .toList(growable: false)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: new ResponsiveGridView(
                        rows: 2,
                        cols: 4,
                        children: listOfNumbers
                            .map(
                              (e) => Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: _buildItem(k++, e, ''),
                                  ),
                            )
                            .toList(growable: false)),
                  ),
                ),
              ]),
            )
          ]));
    });
  }

  Widget buildQuestion(int index, e, double d) {
    if (e == "+" || e == "-") {
      return new Text(
        "$e",
        style: TextStyle(color: Colors.amber, fontSize: 30.0),
      );
    } else {
      return new MyQuestionButton(
          key: new ValueKey<int>(index),
          maxHeight: d,
          text: e,
          //question unit mode
          onPress: () {
            print("......object what i click is.....$e");
          });
    }
  }
}

class MyQuestionButton extends StatefulWidget {
  MyQuestionButton(
      {Key key,
      this.text,
      this.onPress,
      //question unit mode

      this.maxHeight})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
//question unit mode

  final double maxHeight;
  @override
  _MyQuestionButtonState createState() => new _MyQuestionButtonState();
}

class _MyQuestionButtonState extends State<MyQuestionButton> {
  @override
  Widget build(BuildContext context) {
    return new UnitButton(
      text: widget.text,
      onPress: () => widget.onPress(),
      showHelp: false,
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
      this.code,
      this.isRotated,
      this.img,
      this.onDrag,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  final DragTargetAccept onAccepted;
  final keys;
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;

  bool isDragging = false;
  initState() {
    super.initState();
    // disptext = widget.text == null ? '' : widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -3.0, end: 3.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    if (widget.index < 100) {
      return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.flag == 1 ? animation1 : animation,
            child: new ScaleTransition(
                scale: animation,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: new DragTarget(
                    onAccept: (String data) => widget.onAccepted(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return widget.text == null
                          ? UnitButton(
                              text: '',
                            )
                          : UnitButton(
                              text: widget.text,
                            );
                    },
                  ),
                ))),
      );
    } else if (widget.index >= 100) {
      return new Draggable(
        onDragStarted: () {
          if (ButtonStateContainer.of(context).startUsingButton()) {
            setState(() {
              isDragging = true;
            });

            widget.onDrag();
          }
        },
        onDragCompleted: () {
          if (isDragging) {
            setState(() {
              isDragging = false;
            });
            ButtonStateContainer.of(context).endUsingButton();
          }
        },
        onDraggableCanceled: (Velocity v, Offset o) {
          if (isDragging) {
            setState(() {
              isDragging = false;
            });
            ButtonStateContainer.of(context).endUsingButton();
          }
        },
        maxSimultaneousDrags:
            (isDragging || !ButtonStateContainer.of(context).isButtonBeingUsed)
                ? 1
                : 0,
        data:
            '${widget.index}' + '_' + '${widget.code}' + '_' + '${widget.text}',
        child: new ScaleTransition(
          scale: animation,
          child: new UnitButton(
            key: new Key('A${widget.keys}'),
            text: widget.text,
            showHelp: false,
          ),
        ),
        feedback: UnitButton(
          text: widget.text,
          maxHeight: buttonConfig.height,
          maxWidth: buttonConfig.width,
          fontSize: buttonConfig.fontSize,
        ),
      );
    }
  }
}
