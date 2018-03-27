
import 'package:flutter/material.dart';

class FillInTheBlanks extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  FillInTheBlanks({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FillInTheBlanksState();
}

class _FillInTheBlanksState extends State<FillInTheBlanks> {
  Color caughtcolor = Colors.grey;
  Text text;

  @override
  Widget build(BuildContext context) {

    return new Expanded(
      child: new Stack(
        children: <Widget>[
          new DragBox(new Offset(70.0, 300.0), 'P', Colors.red),
          new DragBox(new Offset(140.0, 300.0), 'B', Colors.green),
          new DragBox(new Offset(210.0, 300.0), 'T', Colors.yellow),
          new DragBox(new Offset(280.0, 300.0), 'L', Colors.pink),
          new Positioned(           //   First position
            top: 150.0,
            left: 30.0,
            child: new DragTarget(
              onAccept: (Text t) {
                text = text;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  )
              {
                return new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: accepted.isEmpty ? caughtcolor : Colors.grey.shade200,
                  ),
                  child: new Center(
                    child: new Text("A"),
                  ),
                );
              },
            ),
          ),
          new Positioned(
            top: 150.0,
            left: 100.0,
            child: new DragTarget(

              onAccept: (Text t) {
                text = text;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  )
              {
                return new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: accepted.isEmpty ? caughtcolor : Colors.grey.shade200,
                  ),
                  child: new Center(
                    child: new Text("_"),
                  ),
                );
              },
            ),
          ),
          new Positioned(
            top: 150.0,
            left: 170.0,
            child: new DragTarget(
              onAccept: (Text t) {
                text = text;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  )
              {
                return new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: accepted.isEmpty ? caughtcolor : Colors.grey.shade200,
                  ),
                  child: new Center(
                    child: new Text("P"),
                  ),
                );
              },
            ),
          ),
          new Positioned(
            top: 150.0,
            left: 240.0,
            child: new DragTarget(
              onAccept: (Text t) {
                text = text;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  )
              {
                return new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: accepted.isEmpty ? caughtcolor : Colors.grey.shade200,
                  ),
                  child: new Center(
                    child: new Text("_"),
                  ),
                );
              },
            ),
          ),
          new Positioned(
            top: 150.0,
            left: 310.0,
            child: new DragTarget(

              onAccept: (Text t) {
                text = text;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  )
              {
                return new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    color: accepted.isEmpty ? caughtcolor : Colors.grey.shade200,
                  ),
                  child: new Center(
                    child: new Text("E"),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}


class DragBox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemcolor;

  DragBox(this.initPos,this.label,this.itemcolor);
  @override
  _DragBoxState createState() => new _DragBoxState();
}

class _DragBoxState extends State<DragBox> {
  Offset position = new Offset(0.0,0.0);
  @override
  void initState() {
    // TODO: implement initState
    position= widget.initPos;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx,
      top: position.dy,
      child: new Draggable(
        data: widget.itemcolor,
        child: new Container(
          width: 60.0,
          height: 60.0,
          color: widget.itemcolor,
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
        onDraggableCanceled: (velocity,offset) {
          setState((){
            //  position=offset;
          });
        },
        feedback: new Container(
          width: 60.0,
          height: 60.0,
          color: widget.itemcolor.withOpacity(0.8),
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
