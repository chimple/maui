import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

String test= '';


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
    return new Column(
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
          test = caughtText;
        } else {
          caughtText = '';
          test = '';
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

class DragBoxState extends State<DragBox> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  Color draggableColor;
  String draggableText;

  void toAnimateFunction() {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = new AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 3.0, end: 8.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });

    draggableColor = widget.itemColor;
    draggableText = widget.label;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Draggable(
      data: draggableText,
      child: new AnimatedDrag(
          animation: animation,
          draggableColor: draggableColor,
          draggableText: draggableText),
      feedback: new AnimatedFeedback(
          animation: animation,
          draggableColor: draggableColor,
          draggableText: draggableText),
      onDragCompleted: () {
        if (test == draggableText){
          controller.stop();
        } else if (test == ''){
          toAnimateFunction();
          new Future.delayed(const Duration(milliseconds: 1000), () {
                controller.stop();
              });
        }
        
      },
    );
  }
}

class AnimatedFeedback extends AnimatedWidget {
  AnimatedFeedback(
      {Key key,
      Animation<double> animation,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
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
    );
  }
}

class AnimatedDrag extends AnimatedWidget {
  AnimatedDrag(
      {Key key,
      Animation<double> animation,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      width: 100.0,
      height: 100.0,
      color: draggableColor,
      margin: new EdgeInsets.only(left: animation.value  ?? 0),
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
    );
  }
}
