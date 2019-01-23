import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/repos/game_data.dart';

class BasicCounting extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  BasicCounting(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.onTurn,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new BasicCountingState();
}

enum Status { active, visible }

enum Code { question, answer }

class BasicCountingState extends State<BasicCounting> {
  int _size = 2;
  Tuple3<List<String>, List<String>, List<String>> basicData;
  List<Status> _statuses = [];
  static int _maxSize = 2;
  bool _isLoading = true;
  // List<String> _all = ["manu", "kiran", "3", "4", "5"];
  List _all = [];
  List _answer = [];
  List _question = [];
  List newAnswer = [];

  @override
  void initState() {
    super.initState();
    print("this are my game basic");
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);

    basicData = await fetchBasicCountingData(widget.gameConfig.gameCategoryId);
    basicData.item1.forEach((e) {
      _question.add(e);
    });
    basicData.item2.forEach((e) {
      _all.add(e);
    });
    basicData.item3.forEach((e) {
      _answer.add(e);
    });
    newAnswer = _answer.sublist(0, 2);
    print("this is al ieierjierl $_question");
    print("this is a answer $_answer");
    print("this is a new answer $newAnswer");
    _statuses = _question.map((e) => Status.active).toList(growable: false);
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(BasicCounting oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      _all = [];
      _answer = [];
      _question = [];
      _statuses = [];
      _initBoard();
    }
  }

  Widget _buildItem(int index, String text, Status status, maxChars,
      double maxWidth, double maxHeight) {
    print(
        "clicking button calling again and again we have fix...... $index........ $text.......");
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        status: status,
        onPress: () {
          if (_all[0] == text) {
            print("success");
            _statuses[index] = Status.visible;
            setState(() {
              widget.onEnd();
              _all = [];
              _answer = [];
              _question = [];
              _statuses = [];
            });
          }
          print(" staus is.......::$_statuses");

          print("this is my new index of text $text");
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    print("this is my letters $_all");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    print("this is after random $_question");

    return new LayoutBuilder(builder: (context, constraints) {
      if (_isLoading) {
        return new SizedBox(
            width: 20.0, height: 20.0, child: new CircularProgressIndicator());
      }

      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      final maxChars = (_question != null
          ? _question.fold(1,
              (prev, element) => element.length > prev ? element.length : prev)
          : 1);
      print("$maxChars");
      double maxWidth = (constraints.maxWidth - hPadding * 2) / _maxSize;
      double maxHeight =
          (constraints.maxHeight - vPadding * 2) / (_maxSize + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;

      if (ButtonStateContainer.of(context) != null) {
        UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);

        final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
      }
      print("this is my new $_all");
      var k = 0;
      return Container(
        child: new Column(
          children: <Widget>[
            // new LimitedBox(
            //     maxHeight: maxHeight,
            //     maxWidth: maxWidth,
            //     child: new Material(
            //         color: Theme.of(context).accentColor,
            //         elevation: 4.0,
            //         textStyle: new TextStyle(
            //             color: Colors.orangeAccent, fontSize: 20),
            //         child: new Container(
            //             padding: EdgeInsets.all(10.0),
            //             child: new Center(
            //               child: new Text(
            //                   "Count Your Fingers and Pick the Number choice"),
            //             )))),
            new Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: vPadding, horizontal: hPadding),
                    child: new ResponsiveGridView(
                      rows: 1,
                      cols: 2,
                      children: _question
                          .map((e) => Padding(
                              padding: EdgeInsets.all(buttonPadding),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: Colors.blueGrey,
                                    width: media.size.width *0.4,
                                    height: media.size.height *0.3,
                                    child: Image.asset(
                                      "assets/finger_count/$e.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )))
                          .toList(growable: false),
                    ))),
            new Expanded(
                child: Container(
              decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: 1,
                    cols: 2,
                    children: newAnswer
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(k, e, _statuses[k++], maxChars,
                                maxWidth, maxHeight)))
                        .toList(growable: false),
                  )),
            )),
          ],
        ),
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.text,
      this.onPress,
      this.status,
      this.maxChars,
      this.maxWidth,
      this.maxHeight})
      : super(key: key);
  final int index;
  final String text;
  final VoidCallback onPress;
  final Status status;
  UnitMode unitMode; //question unit mode
  final int maxChars;
  final double maxWidth;
  final double maxHeight;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  void initState() {
    super.initState();
    print("my button is......");
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    print({"oldwidget data ": oldWidget.text});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// print({"this is 123 kiran data": widget.Rtile});
    print("heello datta is not comming here lets check");
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    if (ButtonStateContainer.of(context) != null) {
      return UnitButton(
        dotFlag:true,
        text: widget.text,
        onPress: widget.onPress,
        unitMode: UnitMode.text,
      );
    } else {
      return Container();
    }
  }
}
