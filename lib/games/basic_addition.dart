import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:tuple/tuple.dart';

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
  List addNumber;
  int code;
  bool _isLoading = true;
  String img, dragdata;
  int dindex, dcode;
  var flag1;
  List<bool> _isDropped = new List();
  List dataValues = new List();
  var checkdata;
  Tuple3<List<String>, List<String>, List<String>> basicAdditionData;
  List dropTargetValues = new List();
  int count = 0;
  List<String> questionList;
  List<String> ans;
  List<String> choiceList;
  initState() {
    super.initState();
    initfn();
  }

  initfn() async {
    setState(() => _isLoading = true);

    dataValues = [];
    _isDropped = [];
    questionList = [];
    ans = [];
    choiceList = [];
    print("what is comming here ....${widget.gameCategoryId}");
    basicAdditionData = await fetchBasicAdditionData(widget.gameCategoryId);

    print("hello tuple1 is...${basicAdditionData.item1}");
    print("222 tuple2222   is...${basicAdditionData.item2}");
    print("333 tuple3333   is...${basicAdditionData.item3}");
    questionList = basicAdditionData.item1;
    ans = basicAdditionData.item2;
    choiceList = basicAdditionData.item3;
    choiceList.shuffle();
    // String ansData = ans.first;
    dataValues = ans;
    print(questionList);

    print(ans);

    print(choiceList);

    int temp = 0;
    while (temp < ans.length) {
      if (temp < ans.length) _isDropped.add(false);
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

  @override
  void didUpdateWidget(BasicAddition oldWidget) {
    print("object...iterartion in  dots");
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      initfn();
    }
  }

  Widget _buildItem(int index, String text, compValue) {
    print("hello whta is comming making onend..... $index........ $text");
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      code: code,
      onDrag: _onDragUpdate,
      isRotated: widget.isRotated,
      text: text,
      onDragCompleted: _onDragCompleted,
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
              widget.onScore(1);
              _isDropped[index] = true;
              count = count + 1;

              print("hello what is the lenth and all $count");

              dropTargetValues[index] = valueText;
              if (count == _isDropped.length) {
                setState(() {
                  count = 0;
                  dropTargetValues = [];
                  choiceList = [];
                  widget.onEnd();
                });
              }
            });
          } else if (_isDropped[index] == false) {
            setState(() {
              choiceList[findex] = valueText;
            });
            // wrong
          } else if (_isDropped[index] == true) {
            setState(() {
              choiceList[findex] = valueText;
            });

            // do nothing;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("widget testing contol comming here or not");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    print("after load it  should widget testing contol comming here or not");
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = 0.0, maxHeight = 0.0;
      maxWidth = (constraints.maxWidth - hPadding * 2) / 4;
      maxHeight = (constraints.maxHeight - vPadding * 2) / 4;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 6);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      //  final buttonConfig = ;
      if (ButtonStateContainer.of(context) != null) {
        UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      }

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
                  color: Colors.white,
                  height: constraints.maxHeight / 2,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: hPadding),
                      child: new ResponsiveGridView(
                        rows: 1,
                        cols: questionList.length,
                        children: questionList
                            .map(
                              (e) => new Padding(
                                    padding: EdgeInsets.all(buttonPadding),
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
              child: Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: hPadding),
                        child: ResponsiveGridView(
                            rows: 1,
                            cols: 4,
                            children: dropTargetValues
                                .map(
                                  (e) => Padding(
                                        padding: EdgeInsets.all(buttonPadding),
                                        child: _buildItem(inc, e, ans[inc++]),
                                      ),
                                )
                                .toList(growable: false)),
                      ),
                      Expanded(
                        // flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: hPadding),
                          child: new ResponsiveGridView(
                              rows: 2,
                              cols: 4,
                              children: choiceList
                                  .map(
                                    (e) => Padding(
                                          padding:
                                              EdgeInsets.all(buttonPadding),
                                          child: _buildItem(k++, e, ''),
                                        ),
                                  )
                                  .toList(growable: false)),
                        ),
                      ),
                    ]),
              ),
            )
          ]));
    });
  }

  Widget buildQuestion(int index, e, double d) {
    print("question Button running");
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

  _onDragUpdate(int index, int dcode) {
    int findex = index - 100;
    if (code == dcode) {
      setState(() {
        choiceList[findex] = '';
      });
    }
  }

  _onDragCompleted(int index, String text) {
    int findex = index - 100;
    print(
        "hello here coming or at end of this..... $index.......data is...$text");
    setState(() {
      choiceList[findex] = text;
    });
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
    if (ButtonStateContainer.of(context) != null) {
      return new UnitButton(
          text: widget.text,
          onPress: () => widget.onPress(),
          showHelp: false,
          dotFlag: true);
    } else {
      return Container();
    }
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
      this.onDragCompleted,
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
  final Function onDrag;
  final Function onDragCompleted;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1, rectController;
  Animation<double> animation, animation1;
  Animation<RelativeRect> rectAnimation;
  String dragText;
  String noEmptyString;
  bool isDragging = false;
  initState() {
    super.initState();

    // disptext = widget.text == null ? '' : widget.text;
    if (widget.text != '') {
      dragText = widget.text;
    }

    rectController = controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -3.0, end: 3.0).animate(controller1);
    rectAnimation = new Tween(
      begin: RelativeRect.fromLTRB(10.0, 0.0, 0.0, 0.0),
      end: RelativeRect.fromLTRB(40.0, 400.0, 40.0, 400.0),
    ).animate(rectController);
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
    rectController.dispose();
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
    print("what is comming after onend here");
    var buttonConfig;
    if (ButtonStateContainer.of(context) != null) {
      buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    }

    if (ButtonStateContainer.of(context) != null) {
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
                setState(() {
                  widget.onDrag(widget.index, widget.code);
                });
                isDragging = true;
              });
            }
          },
          onDragCompleted: () {
            if (isDragging) {
              setState(() {
                // widget.onDragCompleted(widget.index, widget.text);
                isDragging = false;
              });
              ButtonStateContainer.of(context).endUsingButton();
            }
          },
          onDraggableCanceled: (Velocity v, Offset o) {
            print("draging cancecllded 111111111");
            widget.onDragCompleted(widget.index, dragText);
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
          data: '${widget.index}' +
              '_' +
              '${widget.code}' +
              '_' +
              '${widget.text}',
          child: new ScaleTransition(
            scale: animation,
            child: new UnitButton(
              key: new Key('A${widget.keys}'),
              text: widget.text,
              showHelp: false,
            ),
          ),
          feedback: Stack(children: [
            Container(
              margin: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
              constraints: BoxConstraints.tightFor(
                  height: buttonConfig.height, width: buttonConfig.width - 10),
              // color: Colors.white,
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                      Radius.circular(buttonConfig?.radius ?? 8.0))),
            ),
            Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(buttonConfig?.radius ?? 8.0))),
                constraints: BoxConstraints.tightFor(
                    height: buttonConfig.height, width: buttonConfig.width),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  splashColor: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).primaryColor,
                  onPressed: null,
                  padding: EdgeInsets.all(0.0),
                  shape: new RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Theme.of(context).primaryColor, width: 4.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(buttonConfig?.radius ?? 8.0))),
                  child: Center(
                    child: Text(widget.text,
                        style: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: buttonConfig.fontSize)),
                  ),
                )),
          ]),
        );
      }
    } else {
      return Container();
    }
  }
}
