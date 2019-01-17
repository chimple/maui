import 'package:flutter/material.dart';
import 'dart:math';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:tuple/tuple.dart';

class SequenceTheNumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  bool isRotated;
  int iteration;
  int gameCategoryId;
  GameConfig gameConfig;
  SequenceTheNumber(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);
  @override
  _SequenceTheNumberState createState() => _SequenceTheNumberState();
}

class _SequenceTheNumberState extends State<SequenceTheNumber> {
  List<String> _dragBoxData, _holdDataOfDragBox;
  List<String> _dragTargetData;
  List<Tuple2<String, String>> _data;
  bool _isLoading = true;
  int _size;
  String _holdDragText;
  int _indexOfDragText;
  @override
  void initState() {
    super.initState();
    _sequenceTheNumber();
  }

  void _sequenceTheNumber() async {
    setState(() => _isLoading = true);
    _data = await fetchSequenceNumberData();
    _dragBoxData = _data.map((f) {
      return f.item2;
    }).toList(growable: false);
    _holdDataOfDragBox = _data.map((f) {
      return f.item2;
    }).toList(growable: false);
    _dragTargetData = _data.map((f) {
      return f.item1;
    }).toList(growable: false);
    _size = _dragBoxData.length;
    _dragBoxData.shuffle();
    setState(() => _isLoading = false);
  }

  Widget dragBox(int index, String text) {
    return new MyButton(
      index: index,
      text: text,
      onDrag: () {
        setState(() {});
        _holdDragText = text;
        _indexOfDragText = _holdDataOfDragBox.indexOf(text);
      },
    );
  }

  Widget dropTarget(int index, String text) {
    return new MyButton(
      index: index,
      text: text,
      onAccepted: (data) {
        setState(() {});
        if (_dragTargetData[index] == '?' && index == _indexOfDragText) {
          _dragTargetData[index] = _holdDragText;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: new SizedBox(
          width: 20.0,
          height: 20.0,
          child: new CircularProgressIndicator(),
        ),
      );
    }
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = 0.0, maxHeight = 0.0;
      maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      maxHeight = (constraints.maxHeight - vPadding * 2) / _size;
      var j = 0, k = 100;
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);

      return Container(
        color: Colors.indigo[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Text(
                    'Sequence the number',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.indigo[900],
                  //   borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(25.0),
                  //       topRight: Radius.circular(25.0)),
                  // ),
                ),
                child: new ResponsiveGridView(
                  maxAspectRatio: 1.0,
                  rows: 1,
                  cols: _dragTargetData.length,
                  children: _dragTargetData
                      .map((e) => Padding(
                          padding: EdgeInsets.all(buttonPadding),
                          child: dropTarget(j++, e)))
                      .toList(growable: false),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.indigo[700],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                ),
                child: new ResponsiveGridView(
                  maxAspectRatio: 1.0,
                  rows: 1,
                  cols: _dragBoxData.length,
                  children: _dragBoxData
                      .map((e) => Padding(
                          padding: EdgeInsets.all(buttonPadding),
                          child: dragBox(k++, e)))
                      .toList(growable: false),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class MyButton extends StatefulWidget {
  final String text;
  final int index;
  final int length;
  final DragTargetAccept onAccepted;
  final VoidCallback onDrag;
  final DraggableCanceledCallback draggableCanceledCallback;

  const MyButton(
      {Key key,
      this.text,
      this.index,
      this.onAccepted,
      this.length,
      this.onDrag,
      this.draggableCanceledCallback})
      : super(key: key);

  @override
  MyButtonState createState() {
    return new MyButtonState();
  }
}

class MyButtonState extends State<MyButton> {
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    if (widget.index < 100) {
      return Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
        ),
        child: DragTarget(
          onAccept: (String data) => widget.onAccepted(data),
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return widget.text == '?'
                ? UnitButton(
                    text: '',
                  highlighted: true,
                  )
                : UnitButton(
                    dotFlag: false,
                    fontSize: buttonConfig.fontSize * 0.5,
                    text: widget.text,
                  );
          },
        ),
      );
    } else if (widget.index >= 100) {
      return Draggable(
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
        data: widget.text,
        child: UnitButton(
          fontSize: buttonConfig.fontSize * 0.5,
          dotFlag: false,
          text: widget.text,
        ),
        feedback: UnitButton(
          dotFlag: false,
          maxHeight: buttonConfig.height,
          maxWidth: buttonConfig.width,
          fontSize: buttonConfig.fontSize * 0.5,
          text: widget.text,
        ),
      );
    }
  }
}
