import 'dart:async';

import 'package:flutter/material.dart';

class IdentifyGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  IdentifyGame({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _IdentifyGameState();
}

class _IdentifyGameState extends State<IdentifyGame> {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new DropTarget('c', Colors.lightBlue),
              new DropTarget('a', Colors.red),
              new DropTarget('b', Colors.orange),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new DragBox('a', Colors.red),
              new DragBox('b', Colors.orange),
              new DragBox('c', Colors.lightBlue),
            ],
          )
        ],
      ),
    );
  }
}

class DropTarget extends StatefulWidget {
  final String expectedLabel;
  final Color dropColor;

  DropTarget(this.expectedLabel, this.dropColor);

  @override
  DropTargetState createState() => new DropTargetState();
}

class DropTargetState extends State<DropTarget> {
  String caughtText = '';
  String expectedText = '';
  Color targetColor = Colors.cyan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expectedText = widget.expectedLabel;
    targetColor = widget.dropColor;
  }

  @override
  Widget build(BuildContext context) {
    return new DragTarget(
      onAccept: (String text) {
        if (text == expectedText) {
          caughtText = text;
        } else {
          caughtText = '';
        }
      },
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return new Container(
          width: 120.0,
          height: 120.0,
          decoration: new BoxDecoration(
            // color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
            color: targetColor,
          ),
          child: new Center(
            child: new Text(
              accepted.isEmpty ? caughtText : '',
            ),
          ),
        );
      },
    );
  }
}

class DragBox extends StatefulWidget {
  final String label;
  final Color itemColor;

  DragBox(this.label, this.itemColor);

  @override
  DragBoxState createState() => new DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Color draggableColor;
  String draggableText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    draggableColor = widget.itemColor;
    draggableText = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return new Draggable(
      data: draggableText,
      child: new Container(
        width: 100.0,
        height: 100.0,
        color: draggableColor,
        child: new Center(
          child: new Text(
            draggableText,
            style: new TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      // onDraggableCanceled: (velocity, offset) {
      //   setState(() {
      //     //position = offset;
      //   });
      // },
      feedback: new Container(
        width: 120.0,
        height: 120.0,
        color: draggableColor.withOpacity(0.5),
        child: new Center(
          child: new Text(
            draggableText,
            style: new TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
