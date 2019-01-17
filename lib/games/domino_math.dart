import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/button_state_container.dart';

enum GameMode { counting, addition }

class Domino extends StatefulWidget {
  Domino({
    Key key,
  }) : super(key: key);
  @override
  _DominoState createState() => _DominoState();
}

class _DominoState extends State<Domino> {
  List<int> data;
  bool _isLoading = true;
  int _buttonCount;
  int _sum;
  int _num1;
  int _num2;
  List<int> _shuffledData;

  @override
  void initState() {
    super.initState();
    _initNumbers();
  }

  void _initNumbers() async {
    data = await fetchDominoMathData();

    _buttonCount = data.length - 1;
    _num1 = data[0];
    _shuffledData = data.sublist(1);
    _num2 = _shuffledData[0];
    _sum = _num1 + _num2;
    _shuffledData.shuffle();

    setState(() => _isLoading = false);
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

    return new LayoutBuilder(
      builder: (context, constraints) {
        final hPadding = pow(constraints.maxWidth / 150.0, 2);
        final vPadding = pow(constraints.maxHeight / 150.0, 2);

        double maxWidth = (constraints.maxWidth - hPadding * 2) / data.length;
        double maxHeight = (constraints.maxHeight - vPadding * 2) / 5;

        final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

        maxWidth -= buttonPadding * 2;
        maxHeight -= buttonPadding * 2;
        UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            DominoQuestion(_num1),
            // DominoAddition(_num1, _num2, _sum),
            new Expanded(
              flex: 1,
              child: new Material(
                color: Theme.of(context).accentColor,
                child: ResponsiveGridView(
                    rows: 1,
                    cols: _buttonCount,
                    children: _shuffledData
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: DominoAnswer("$e", Colors.blueAccent, e)))
                        .toList(growable: false)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DominoQuestion extends StatefulWidget {
  final int question;
  DominoQuestion(this.question);

  @override
  _DominoQuestionState createState() => new _DominoQuestionState();
}

class _DominoQuestionState extends State<DominoQuestion> {
  bool _matched = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "${widget.question}",
          style: TextStyle(
              color: Colors.indigo,
              fontSize: 100.0,
              fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DragTarget(
              // onWillAccept: (data) {
              //   return true;
              // },
              onAccept: (int number) {
                if (number == widget.question) {
                  _matched = true;
                }
              },
              builder:
                  (context, List<dynamic> accepted, List<dynamic> rejected) {
                return _matched
                    ? UnitButton(
                        text: "${widget.question}",
                      )
                    : UnitButton(text: "");
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DominoAddition extends StatefulWidget {
  final int num1;
  final int num2;
  final int sum;
  DominoAddition(this.num1, this.num2, this.sum);

  @override
  _DominoAdditionState createState() => new _DominoAdditionState();
}

class _DominoAdditionState extends State<DominoAddition> {
  bool _matched = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "${widget.sum}",
          style: TextStyle(
              color: Colors.indigo,
              fontSize: 100.0,
              fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UnitButton(
              text: "${widget.num1}",
            ),
            Text(
              "+",
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 100.0,
                  fontWeight: FontWeight.bold),
            ),
            DragTarget(
              // onWillAccept: (data) {
              //   return true;
              // },
              onAccept: (int number) {
                if (number == widget.num2) {
                  _matched = true;
                }
              },
              builder:
                  (context, List<dynamic> accepted, List<dynamic> rejected) {
                return _matched
                    ? UnitButton(
                        text: "${widget.num2}",
                      )
                    : UnitButton(text: "");
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DominoAnswer extends StatefulWidget {
  final String label;
  final Color boxColor;
  final int data;
  DominoAnswer(
    this.label,
    this.boxColor,
    this.data,
  );

  @override
  _DominoAnswerState createState() => new _DominoAnswerState();
}

class _DominoAnswerState extends State<DominoAnswer> {
  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;

    return Draggable(
      childWhenDragging: Container(),
      data: widget.data,
      child: new UnitButton(
        text: "${widget.label}",
      ),
      // onDraggableCanceled: (velocity, offset) {
      //   setState(() {});
      // },
      feedback: new UnitButton(
        text: "${widget.label}",
        maxHeight: buttonConfig.height,
        maxWidth: buttonConfig.width,
        fontSize: buttonConfig.fontSize,
      ),
    );
  }
}
