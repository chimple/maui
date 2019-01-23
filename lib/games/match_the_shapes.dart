import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';

class MatchTheShapes extends StatefulWidget {
  MatchTheShapes({
    key,
  });
  _MatchTheShapesState createState() => _MatchTheShapesState();
}

class _MatchTheShapesState extends State<MatchTheShapes> {
  Offset _position;
  Map<String, String> data = {'1': '1', '2': '2', '3': '3'};
  List<String> _leftletters = [];
  List<String> _rightletters = [];
  List<Offset> posi = [];
  List<Offset> posiR = [];
  bool loading = true;
  int leftIndex;

  positionUpdateCallback(String text, Offset updatedPos, bool isLeft) {
    if (isLeft)
      posi[_leftletters.indexOf(text)] = updatedPos;
    else
      posiR[_leftletters.indexOf(text)] = updatedPos;
    setState(() {
      print('rebuild is started $text');
    });
  }

  removeMatchButtons(String text) {
    setState(() {
      posi.removeAt(_leftletters.indexOf(text));
      posiR.removeAt(_rightletters.indexOf(text));
      _leftletters.remove(text);
      _rightletters.remove(text);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    initboard(size.height, size.width);
    setState(() {});
  }

  initboard(sHeight, sWidth) async {
    /// pixel adjustment is hard-coded here
    double screenHeight = sHeight - 300.0; //1000.0;
    double screenWidth = sWidth - 300.0; //500.0;
    var rnd = new Random();

    for (int i = 0; i < data.length; i++) {
      posi.add(new Offset(rnd.nextDouble() * screenWidth,
          (rnd.nextDouble() * screenHeight) + 150.0));
      posiR.add(new Offset(rnd.nextDouble() * screenWidth,
          (rnd.nextDouble() * screenHeight) + 150.0));
    }
    _leftletters.addAll(data.keys);
    _rightletters.addAll(data.values);
  }

  Widget _leftbuild(double height, double width) {
    return Stack(
      children: _leftletters
          .map((ele) => MyButton(
              '$ele',
              _leftletters.indexOf('$ele'),
              posi[_leftletters.indexOf('$ele')],
              positionUpdateCallback,
              removeMatchButtons,
              true))
          .toList(growable: false),
    );
  }

  Widget _rightbuild(double height, double width) {
    return Stack(
      children: _rightletters
          .map((ele) => MyButton(
              '$ele',
              _rightletters.indexOf('$ele'),
              posiR[_rightletters.indexOf('$ele')],
              positionUpdateCallback,
              removeMatchButtons,
              false))
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    var maxChars = (_leftletters != null
        ? _leftletters.fold(
            1,
            (prev, element) => element.toString().length > prev
                ? element.toString().length
                : prev)
        : 1);

    maxChars = (_rightletters != null
        ? _rightletters.fold(
            maxChars,
            (prev, element) => element.toString().length > prev
                ? element.toString().length
                : prev)
        : 1);
    return new LayoutBuilder(
      builder: (context, constraints) {
        final hPadding = pow(constraints.maxWidth / 75.0, 2);
        final vPadding = pow(constraints.maxHeight / 75.0, 2);

        double maxWidth =
            (constraints.maxWidth - hPadding) / (_leftletters.length);
        double maxHeight =
            (constraints.maxHeight - vPadding) / (_leftletters.length);

        final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

        maxWidth -= buttonPadding * 2;
        maxHeight -= buttonPadding * 2;
        print('myconstraints $constraints');
        double screenHeight = MediaQuery.of(context).size.height - 150.0;
        double screenWidth = MediaQuery.of(context).size.width - 150.0;
        print('This is max width $maxWidth , <> $maxHeight');
        return Stack(
          children: <Widget>[
            _leftbuild(screenHeight, screenWidth),
            _rightbuild(screenHeight, screenWidth),
          ],
        );
      },
    );
  }
}

class MyButton extends StatefulWidget {
  String text;
  int index;
  Offset _position;
  Function positionUpdateCallback;
  Function removeMatchButtons;
  bool isLeft;

  MyButton(this.text, this.index, this._position, this.positionUpdateCallback,
      this.removeMatchButtons, this.isLeft);
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool dragging = false;
  bool isDraggable = true;

  @override
  void initState() {
    super.initState();
  }

  String dropData(String text, bool isLeft) {
    return '$text,$isLeft';
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Positioned(
          top: widget._position.dy - 142.0,
          left: widget._position.dx,
          child: Stack(
            children: <Widget>[
              new Draggable(
                data: dropData(widget.text, widget.isLeft),
                child: new UnitButton(
                  text: widget.text,
                  showHelp: false,
                  highlighted: false,
                  maxHeight: 152.0,
                  maxWidth: 152.0,
                  fontSize: 52.0,
                ),
                feedback: new UnitButton(
                  text: widget.text,
                  showHelp: false,
                  highlighted: false,
                  maxHeight: 152.0,
                  maxWidth: 152.0,
                  fontSize: 52.0,
                ),
                childWhenDragging: new Container(),
                maxSimultaneousDrags: 1,
                onDragEnd: (DraggableDetails details) {
                  widget.positionUpdateCallback(
                      widget.text, details.offset, widget.isLeft);
                },
                onDragCompleted: () {},
              ),
              DragTarget(
                onAccept: (String data) {
                  String droppedText = data.split(',')[0];
                  String isleftData = data.split(',')[1];
                  bool thisButtonData = widget.isLeft;
                  if (droppedText == widget.text &&
                      isleftData != '$thisButtonData') {
                    widget.removeMatchButtons(droppedText);
                  }
                },
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return Container(
                    height: 152.0,
                    width: 152.0,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
