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
  String caughtText = '';

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Stack(
        children: <Widget>[
          new DragBox(new Offset(0.0, 400.0), 'a', Colors.red),
          new DragBox(new Offset(150.0, 400.0), 'b', Colors.orange),
          new DragBox(new Offset(300.0, 400.0), 'c', Colors.lightBlue),
          new DropTarget(new Offset(0.0, 0.0), 'c'),
          new DropTarget(new Offset(150.0, 0.0), 'a'),
          new DropTarget(new Offset(300.0, 0.0), 'b'),
        ],
      ),
    );
  }
}

class DropTarget extends StatefulWidget {
  final Offset initPos;
  final String label;

  DropTarget(this.initPos, this.label);

  @override
  DropTargetState createState() => new DropTargetState();
}

class DropTargetState extends State<DropTarget> {
  String caughtText = '';
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
                    color: Colors.green,
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
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position = offset;
          });
        },
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
