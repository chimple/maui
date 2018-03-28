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
      child: new Stack(
        children: <Widget>[
          new DragBox(new Offset(0.0, 400.0), 'a', Colors.red),
          new DragBox(new Offset(150.0, 400.0), 'b', Colors.orange),
          new DragBox(new Offset(300.0, 400.0), 'c', Colors.lightBlue),
          new DropTarget(new Offset(0.0, 0.0), 'c', Colors.lightBlue),
          new DropTarget(new Offset(150.0, 0.0), 'a', Colors.red),
          new DropTarget(new Offset(300.0, 0.0), 'b', Colors.orange),
        ],
      ),
    );
  }
}

class DropTarget extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color dropColor;

  DropTarget(this.initPos, this.label, this.dropColor);

  @override
  DropTargetState createState() => new DropTargetState();
}

class DropTargetState extends State<DropTarget> {
  String caughtText = '';
  Offset position = new Offset(0.0, 0.0);
  String expectedText = '';
  Color targetColor = Colors.cyan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    position = widget.initPos;
    expectedText = widget.label;
    targetColor = widget.dropColor;

  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
            left: position.dx,
            top: position.dy,
            child: new DragTarget(
              onAccept: (String text) {
                caughtText = text;
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
            ),
          );
  }
}

class DragBox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  DragBox(this.initPos, this.label, this.itemColor);

  @override
  DragBoxState createState() => new DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = new Offset(0.0, 0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx,
      top: position.dy,
      child: new Draggable(
        data: widget.label,
        child: new Container(
          width: 100.0,
          height: 100.0,
          color: widget.itemColor,
          child: new Center(
            child: new Text(
              widget.label,
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
          color: widget.itemColor.withOpacity(0.5),
          child: new Center(
            child: new Text(
              widget.label,
              style: new TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
