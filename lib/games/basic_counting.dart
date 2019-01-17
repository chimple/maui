import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/button_state_container.dart';

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

class BasicCountingState extends State<BasicCounting>
    with SingleTickerProviderStateMixin {
  int _size = 2;

  List<Status> _statuses = [];
  static int _maxSize = 2;
  List<String> _all = ["manu", "kiran", "3", "4", "5"];
  List<String> _answer = ["8"];
  List<String> _question = ["8", "3"];

  @override
  void initState() {
    super.initState();
    print("this are my game basic");
    _statuses = _all.map((e) => Status.active).toList(growable: false);
  }

  Widget _buildItem(int index, String text, Status status, maxChars,
      double maxWidth, double maxHeight, code) {
    print("clicking button calling again and again we have fix");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        code: code,

        //question unit mode
        status: status,
        onPress: () {
          if (code == Code.question) {
            print("this is text $text");
            print("this is answer ${_answer[0]}");
            if (_answer[0] == text) {
              print("success");
              _statuses[index] = Status.visible;
            }
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
                      children: _all
                          .map((e) => Padding(
                              padding: EdgeInsets.all(buttonPadding),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: Colors.blueGrey,
                                    width: 200.0,
                                    height: 200.0,
                                    child: Image.asset(
                                      "assets/$e.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )))
                          .toList(growable: false),
                    ))),
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
                              child: _buildItem(k, e, _statuses[k++], maxChars,
                                  maxWidth, maxHeight, Code.question)))
                          .toList(growable: false),
                    ))),
          ],
        ),
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.onPress,
      this.status,
      this.maxChars,
      this.maxWidth,
      this.maxHeight,
      this.code})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
  final Status status;
  UnitMode unitMode; //question unit mode
  final int maxChars;
  final double maxWidth;
  final double maxHeight;
  final Code code;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
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
    if (ButtonStateContainer.of(context) != null) {
      UnitButton.saveButtonSize(
          context, widget.maxChars, widget.maxWidth, widget.maxHeight);

      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    }
    print({"this is 123 kiran column": widget.text});

    return ButtonStateContainer.of(context) != null
        ? UnitButton(
            text: widget.text,
            onPress: widget.onPress,
            unitMode: UnitMode.text,
          )
        : Container();
  }
}
