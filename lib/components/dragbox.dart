
import 'draggable_text.dart';
import 'drop_target.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  List<Letters> items;

  GameView(this.items);

  @override
  _GameViewState createState() => new _GameViewState();
}


class _GameViewState extends State<GameView> {
  final _gap = 8.0;
  final _margin = 10.0;
  Map<int, Letters> pairs = {};
  bool validated = false;
  int score = 0;

  Size getDraggableSize({Size areaSize, int numItems}) {
  //   final landScape = areaSize.width > areaSize.height;
  //   final targetWidth =
  //       (areaSize.width - (2 * _margin) - (_gap * (numItems - 1))) / numItems;
  //  return new Size(targetWidth, areaSize.height * (landScape ? 0.25 : 0.2));
    return new Size.square(60.0);
  }

  Size getTargetSize({Size areaSize, int numItems}) {
    // final landScape = areaSize.width > areaSize.height;
    // final targetWidth =
    //     (areaSize.width - (2 * _margin) - (_gap * (numItems - 1))) / numItems;
    // return new Size(targetWidth, areaSize.height * (landScape ? 0.45 : 0.3));
    return new Size.square(60.0);
  }

  // Widget _buildButton(IconData icon, VoidCallback onPress) => new Padding(
  //     padding: new EdgeInsets.all(20.0),
  //     child: new FloatingActionButton(
  //         backgroundColor: Colors.green,
  //         child: new Icon(icon),
  //         onPressed: onPress));

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final size = mq.size;
    final numItems = widget.items.length;
    final draggableSize = getDraggableSize(areaSize: size, numItems: numItems);
    final targetSize = getTargetSize(areaSize: size, numItems: numItems);
    return new Column(
        mainAxisAlignment: mq.orientation == Orientation.landscape
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceEvenly,
        children: [
        //    _buildValidateButton(),
          new Expanded( child: _buildTargetRow(targetSize, draggableSize)),
             new Expanded(child:
           _buildDraggableList(draggableSize)
           ),
        ]);
  }

  // Widget _buildValidateButton() => new Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           new Text('Score : $score / ${widget.items.length}'),
  //           _buildButton(validated ? Icons.refresh : Icons.check,
  //               validated ? _onClear : _onValidate)
  //         ]);

  Widget _buildDraggableList(Size itemSize) => new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: widget.items
          .where((item) => !item.selected)
          .map((item) => new DraggableLetter(item, size: itemSize))
          .toList());

  Widget _buildTargetRow(Size targetSize, Size itemSize) =>
      new NotificationListener<SelectionNotification>(
          onNotification: _onSelection,
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: widget.items
                  .map((item) => new DropTarget(item,
                      selectedItem: pairs[item.id],
                      size: targetSize,
                      itemSize: itemSize
                      ))
                  .toList()));

  bool _onSelection(SelectionNotification notif) {
    setState(() {
      // on de-selection
      if (notif.cancel) {
        if (notif.item != null) notif.item.selected = false;
        pairs.remove(notif.dropIndex);
      } else {
        // if target was associated with other country
        if (pairs[notif.dropIndex] != null)
          pairs[notif.dropIndex].selected = false;

        // if country was associated with other dropTarget
        if (pairs.containsValue(notif.item))
          pairs.remove(pairs.keys.firstWhere((k) => pairs[k] == notif.item));
        _onItemSelection(notif.item, notif.dropIndex);
      }
    });
    return false;
  }

  void _onItemSelection(Letters selectedItem, int targetId) {
    setState(() {
      if (selectedItem != null) {
        selectedItem.selected = true;
        selectedItem.status = Status.none;
      }

      pairs[targetId] = selectedItem;
    });
  }

  void _onValidate() {
    setState(() {
      score = 0;
      pairs.forEach((index, item) {
        if (item.id == index) {
          item.status = Status.correct;
          score++;
        } else
          item.status = Status.wrong;
      });
      validated = true;
    });
  }

  void _onClear() {
    setState(() {
      pairs.forEach((index, item) {
        item.status = Status.none;
        item.selected = false;
      });
      pairs.clear();
      validated = false;
    });
  }
}
