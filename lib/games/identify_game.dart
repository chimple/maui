import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

String test = '';

class IdentifyGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  IdentifyGame(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _IdentifyGameState();
}

class _IdentifyGameState extends State<IdentifyGame> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new DropTarget(new Offset(0.0, 0.0)),
        new DragBox(new Offset(38.0, 500.0), 'face', Colors.red),
        new DragBox(new Offset(126.0, 500.0), 'cap', Colors.orange),
        new DragBox(new Offset(214.0, 500.0), 'hand', Colors.lightBlue),
        new DragBox(new Offset(303.0, 500.0), 'body', Colors.green),
      ],
    );
    // return new Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: <Widget>[
    //     new Padding(
    //       padding: new EdgeInsets.only(top: 30.0),
    //     ),
    //     // new Expanded(
    //     //   flex: 1,
    //     //   child: new Padding(
    //     //     padding: new EdgeInsets.only(top: 5.0)
    //     //   ),
    //     // ),
    //     new Expanded(
    //       flex: 3,
    //       child: new DropTarget(),
    //       // child: new Row(
    //       // mainAxisAlignment: MainAxisAlignment.center,
    //       // children: <Widget>[
    //       //   new Expanded(
    //       //     flex:1,
    //       //     child: new DropTarget(),
    //       //   ),
    //       //   // new Expanded(
    //       //   //   flex: 1,
    //       //   //   child:  new DropTarget('hand', Colors.red),
    //       //   // ),
    //       //   // new Expanded(
    //       //   //   flex: 1,
    //       //   //   child: new DropTarget('head', Colors.orange),
    //       //   // ),
    //       //   // new Expanded(
    //       //   //   flex: 1,
    //       //   //   child: new DropTarget('body', Colors.green),
    //       //   // )
    //       //   // new DropTarget('leg', Colors.lightBlue),
    //       //   // new DropTarget('hand', Colors.red),
    //       //   // new DropTarget('head', Colors.orange),
    //       //   // new DropTarget('body', Colors.green),
    //       //   ],
    //       // ),
    //     ),
    //     new Expanded(
    //       flex: 1,
    //       child: new Row(
    //         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: <Widget>[
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('face', Colors.red),
    //           ),
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('cap', Colors.orange),
    //           ),
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('hand', Colors.lightBlue),
    //           ),
    //           new Expanded(
    //             flex: 1,
    //             child: new DragBox('body', Colors.green),
    //           ),
    //           // new DragBox('a', Colors.red),
    //           // new DragBox('b', Colors.orange),
    //           // new DragBox('c', Colors.lightBlue),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}

class DragBoxCopy extends StatefulWidget {
  final Offset initpos;
  final String label;
  final Color itemColor;
  DragBoxCopy(this.initpos, this.label, this.itemColor);

  @override
  DragBoxCopyState createState() => new DragBoxCopyState();
}

class DragBoxCopyState extends State<DragBoxCopy> {
  Offset position = new Offset(0.0, 0.0);
  Color draggedBoxColor;
  String draggedText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    position = widget.initpos;
    draggedBoxColor = widget.itemColor;
    draggedText = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        left: position.dx,
        top: position.dy,
        child: new Container(
          height: 50.0,
          width: 50.0,
          color: draggedBoxColor.withOpacity(0.5),
          child: new Center(
            child: new Text(
              draggedText,
              style: new TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 15.0,
              ),
            ),
          ),
        ));
  }
}

class DropTarget extends StatefulWidget {
  final Offset intipos;
  // final String expectedLabel;
  // final Color dropColor;

  // DropTarget(this.expectedLabel, this.dropColor);
  DropTarget(this.intipos);

  @override
  DropTargetState createState() => new DropTargetState();
}

class DropTargetState extends State<DropTarget> {
  Offset position = new Offset(0.0, 0.0);
  // String caughtText = '';
  // String expectedText = '';
  // Color targetColor = Colors.cyan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    position = widget.intipos;
    // expectedText = widget.expectedLabel;
    // targetColor = widget.dropColor;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return new Positioned(
      left: position.dx,
      right: position.dy,
      child: new Image(
        image: new AssetImage('assets/Boy.png'),
        height: height * 0.7,
        width: width * 0.6,
      ),
      // child: new Container(
      //   decoration: new BoxDecoration(
      //     image: new DecorationImage(
      //       image: new AssetImage('assets/Boy.png'),
      //       fit: BoxFit.contain,
      //     ),
      //   ),
      // ),
    );
    // return new DragTarget(
    //   // onAccept: (String text) {
    //   //   if (text == expectedText) {
    //   //     caughtText = text;
    //   //     test = caughtText;
    //   //   } else {
    //   //     caughtText = '';
    //   //     test = '';
    //   //   }
    //   // },
    //   builder: (
    //     BuildContext context,
    //     List<dynamic> accepted,
    //     List<dynamic> rejected,
    //   ) {
    //     return new Container(
    //       decoration: new BoxDecoration(
    //         image: new DecorationImage(
    //           image: new AssetImage('assets/Boy.png'),
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //     );
    //     // return new Container(
    //     //   width: 120.0,
    //     //   height: 120.0,
    //     //   decoration: new BoxDecoration(
    //     //     // color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
    //     //     color: targetColor,
    //     //   ),
    //     //   child: new Center(
    //     //     child: new Text(
    //     //       accepted.isEmpty ? caughtText : '',
    //     //     ),
    //     //   ),
    //     // );
    //   },
    // );
  }
}

class DragBox extends StatefulWidget {
  final Offset intipos;
  final String label;
  final Color itemColor;

  DragBox(this.intipos, this.label, this.itemColor);

  @override
  DragBoxState createState() => new DragBoxState();
}

class DragBoxState extends State<DragBox> with TickerProviderStateMixin {
  Offset position = new Offset(0.0, 0.0);
  AnimationController controller, controller1;
  Animation<double> animation, animation1, noanimation;

  Color draggableColor;
  String draggableText;
  int _flag = 0;

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

  void toAnimateButton() {
    // animation1.addStatusListener((AnimationStatus status) {
    //   if(status == AnimationStatus.completed){
    //     controller1.reverse();
    //   }else if (status == AnimationStatus.dismissed){
    //     controller1.forward();
    //   }
    // });
    controller1.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 800), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation = new Tween(begin: -3.0, end: 3.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    animation1 = new CurvedAnimation(parent: controller1, curve: Curves.easeOut);
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(controller1);
    position = widget.intipos;
    draggableColor = widget.itemColor;
    draggableText = widget.label;

    toAnimateButton();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx,
      top: position.dy,
      child: new ScaleTransition(
          scale: animation1,
          child: new Draggable(
              data: draggableText,
              child: new AnimatedDrag(
                  animation: (_flag == 0) ? noanimation : animation,
                  draggableColor: draggableColor,
                  draggableText: draggableText),
              feedback: new AnimatedFeedback(
                  animation: animation,
                  draggableColor: draggableColor,
                  draggableText: draggableText),
              onDraggableCanceled: (velocity, offset) {
                // if (test == draggableText) {
                //   controller.stop();
                // } else if (test == '') {
                //   toAnimateFunction();
                //   new Future.delayed(const Duration(milliseconds: 1000), () {
                //     controller.stop();
                //   });
                // }
                setState(() {
                  // new DragBoxCopy(new Offset(position.dx, position.dy),
                  //     draggableText, draggableColor);
                  if (draggableText == 'face' &&
                      (250.0 > offset.dx && 250 > offset.dy)) {
                    position = offset;
                  } else if (draggableText == 'cap' &&
                      (230 > offset.dx && 300 > offset.dy)) {
                    position = offset;
                  } else if (draggableText == 'hand' &&
                      (200 > offset.dx && 450 > offset.dy)) {
                    position = offset;
                  } else if (draggableText == 'body' &&
                      (250 > offset.dx && 400 > offset.dy)) {
                    position = offset;
                  } else {
                    _flag = 1;
                    toAnimateFunction();
                    new Future.delayed(const Duration(milliseconds: 1000), () {
                      setState((){_flag = 0;});
                      controller.stop();
                    });
                    
                  }
                });
              })),
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
    Size media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    final Animation<double> animation = listenable;
    return new Container(
      width: width * 0.2,
      height: height * 0.15,
      color: draggableColor.withOpacity(0.5),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontSize: 15.0,
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
    Size media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    final Animation<double> animation = listenable;
    double translateX = animation.value;
    print("value: $translateX");
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: new Container(
        width: width * 0.1,
        height: height * 0.08,
        color: draggableColor,
        // margin: new EdgeInsets.only(
        //     left: animation.value ?? 0, right: animation.value ?? 0),
        child: new Center(
          child: new Text(
            draggableText,
            style: new TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );
    // return new Container(
    //   width: width * 0.1,
    //   height: height * 0.08,
    //   color: draggableColor,
    //   margin: new EdgeInsets.only(
    //       left: animation.value ?? 0, right: animation.value ?? 0),
    //   child: new Center(
    //     child: new Text(
    //       draggableText,
    //       style: new TextStyle(
    //         color: Colors.white,
    //         decoration: TextDecoration.none,
    //         fontSize: 15.0,
    //       ),
    //     ),
    //   ),
    // );
  }
}
