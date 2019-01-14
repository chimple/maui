import 'package:flutter/material.dart';
import 'dart:math';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/state/button_state_container.dart';

class SequenceTheNumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  bool isRotated;
  int iteration;
  int gameCategoryId;
  SequenceTheNumber(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  _SequenceTheNumberState createState() => _SequenceTheNumberState();
}

class _SequenceTheNumberState extends State<SequenceTheNumber> {
  List<String> dragBoxData = [];
  List<String> dropTargetData = [];
  String holdDragText;
  @override
  void initState() {
    super.initState();
    _sequenceTheNumber();
  }

  void _sequenceTheNumber() {
    dragBoxData = ['1', '2', '3', '4'];
    dropTargetData = [
      '4',
      '2',
      '1',
      '3',
    ];
  }

  Widget dragBox(int index, String text) {
    return new MyButton(
      index: index,
      text: text,
      onDrag: () {
        setState(() {});
        holdDragText = text;
      },
    );
  }

  Widget dropTarget(int index, String text) {
    return new MyButton(
      index: index,
      text: text,
      onAccepted: (data) {
        setState(() {
          dropTargetData[index] = holdDragText;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = 0.0, maxHeight = 0.0;
      maxWidth = (constraints.maxWidth - hPadding * 2) / 5;
      maxHeight = (constraints.maxHeight - vPadding * 2) / 5;
      var j = 0, k = 100;
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);

      return Container(
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
                        fontSize: 50.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new ResponsiveGridView(
                  maxAspectRatio: 1.0,
                  rows: 1,
                  cols: dropTargetData.length,
                  children: dropTargetData
                      .map((e) => Padding(
                          padding: EdgeInsets.all(10.0),
                          child: dropTarget(j++, e)))
                      .toList(growable: false),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.brown,
                    backgroundBlendMode: BlendMode.modulate,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0))),
                child: new ResponsiveGridView(
                  maxAspectRatio: 1.0,
                  rows: 1,
                  cols: dragBoxData.length,
                  children: dragBoxData
                      .map((e) => Padding(
                          padding: EdgeInsets.all(10.0),
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

class MyButton extends StatelessWidget {
  final String text;
  final int index;
  final DragTargetAccept onAccepted;
  final VoidCallback onDrag;
  final DraggableCanceledCallback draggableCanceledCallback;

  const MyButton(
      {Key key,
      this.text,
      this.index,
      this.onAccepted,
      this.onDrag,
      this.draggableCanceledCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    if (index < 100) {
      return DragTarget(
        onAccept: (String data) => onAccepted(data),
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return new UnitButton(
            text: text,
          );
        },
      );
    } else {
      return Draggable(
        maxSimultaneousDrags: 1,
        data: text,
        onDragStarted: () {
          onDrag();
        },
        child: UnitButton(
          text: text,
        ),
        feedback: UnitButton(
          maxHeight: buttonConfig.height,
          maxWidth: buttonConfig.width,
          fontSize: buttonConfig.fontSize,
          text: text,
        ),
      );
    }
  }
}
