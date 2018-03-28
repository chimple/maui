
import 'draggable_text.dart';
import 'package:flutter/material.dart';

typedef void DropItemSelector(Letters item, DropTarget target);

class SelectionNotification extends Notification {
  final int dropIndex;
  final Letters item;
  final bool cancel;

  SelectionNotification(this.dropIndex, this.item, {this.cancel: false});
}

class DropTarget extends StatefulWidget {
  final Letters item;

  final Size size;
  final Size itemSize;

  Letters _selection;

  Letters get selection => _selection;

  get id => item.id;

  set selection(Letters value) {
    clearSelection();
    _selection = value;
  }

  DropTarget(this.item, {this.size, Letters selectedItem, this.itemSize}) {
    _selection = selectedItem;
  }
  @override
  _DropTargetState createState() => new _DropTargetState();

  void clearSelection() {
    if (_selection != null) _selection.selected = false;
  }
}

class _DropTargetState extends State<DropTarget> {
  //static const double kFingerSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: new EdgeInsets.only(top: 70.0),    //adjust the size of APPLe
        child:
            widget.selection != null ? addDraggable(getTarget()) : getTarget());
  }

  Widget addDraggable(DragTarget target) => new Draggable<Letters>(
      data: widget.selection,
      dragAnchor: DragAnchor.pointer,
      onDraggableCanceled: onDragCancelled,
      feedback: getCenteredAvatar(),
      child: target);

  DragTarget getTarget() => new DragTarget<Letters>(
      onWillAccept: (item) => widget.selection != item,
      onAccept: (value) {
        new SelectionNotification(widget.item.id, value).dispatch(context);
      },
      builder: (BuildContext context, List<Letters> accepted,
          List<dynamic> rejected) {
        return new SizedBox(
            child: new Container(
                width: widget.size.width,
                height: widget.size.height,
                decoration: new BoxDecoration(
                    color: accepted.isEmpty
                        ? (widget.selection != null
                            ? getDropBorderColor(widget.selection.status)
                            : Colors.green[100])
                        : Colors.cyan[100],
                    border: new Border.all(
                        width: 3.0,
                        color:
                            accepted.isEmpty ? Colors.grey : Colors.cyan[300])
                            ),
                child: widget.selection != null
                    ? new Column(children: [
//                         new Padding(
//                             padding: new EdgeInsets.symmetric(vertical: 16.0),
//                             child: new Text(widget.item.country)),
                        new Center(
                            child: new SizedBox(
                                 width: 54.0,
                                 height: 54.0,
                                 child:  new Center(
                                      child: new Text(
                                        widget.selection.city,
                                      ),
                                    ))),
                      ])
                    : 
                    new Center(child: new Text(widget.item.country))));
      });

  void onDragCancelled(Velocity velocity, Offset offset) {
    setState(() {
      widget.selection = null;
      new SelectionNotification(widget.item.id, widget.selection, cancel: true)
          .dispatch(context);
    });
  }

  Widget getCenteredAvatar() =>  new DragAvatarBorder(
        new Text(widget.selection?.city,
            style: new TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                decoration: TextDecoration.none)),
        size: widget.itemSize,
        color: Colors.cyan,
      );
}
