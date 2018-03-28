
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class DraggableLetter extends StatefulWidget {
  final Letters item;
   Size size;

  bool enabled = true;
  DraggableLetter(this.item, {this.size});

  @override
  _DraggableLetterState createState() => new _DraggableLetterState();
}

class _DraggableLetterState extends State<DraggableLetter> {
  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: new EdgeInsets.all(4.0),
        child: new Draggable<Letters>(
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                widget.item.selected = false;
                widget.item.status = Status.none;
              });
            },
            childWhenDragging: new DragAvatarBorder(new Text(widget.item.city),
                color: Colors.grey[200], size: widget.size),
            child: new Container(
                width: widget.size.width,
                height: widget.size.height,
                color: widget.item.selected ? Colors.grey : Colors.cyan,
                child: new Center(
                  child: new Text(widget.item.city,
                      style: new TextStyle(color: Colors.black)),
                )),
            data: widget.item,
            feedback: new DragAvatarBorder(
              new Text(widget.item.city,
                  style: new TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      decoration: TextDecoration.none)),
              size: widget.size,
              color: Colors.orangeAccent,
            )));
  }
}

class DragAvatarBorder extends StatelessWidget {

  final Color color;
  final double scale;
  final double opacity;
  final Widget child;
  final Size size;

  DragAvatarBorder(this.child,
      {this.color, this.scale: 1.0, this.opacity: 1.0, @required this.size});

  @override
  Widget build(BuildContext context)  =>
      new Opacity(
          opacity: opacity,
          child: new Container(
            transform: new Matrix4.identity()..scale(scale),
            width: size.width,
            height: size.height,
            color: color ?? Colors.grey.shade400,
            child: new Center(child: child),
          ));
}

enum Status { none, correct, wrong }

class Letters {
  final int id;
  final String city;
  final String country;
  bool _selected = false;

  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
    if( _selected == false )
      status = Status.none;
  }
  Status status;

  Letters(this.id, this.city, this.country, {this.status: Status.none});

  @override
  String toString() {
    return 'Item{id: $id, city: $city, country: $country,'
        ' selected: $selected, status: $status}';
  }
}

Color getDropBorderColor(Status status) {
  Color c;
  switch (status) {
    case Status.none:
      c = Colors.grey[300];
      break;
    case Status.correct:
      c = Colors.lime;
      break;
    case Status.wrong:
      c = Colors.orange;
      break;
  }
  return c;
}