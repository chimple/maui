import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class DragText extends StatefulWidget {
  final BuiltList<String> data;
  DragText({this.data});
  @override
  _DragTextState createState() => new _DragTextState();
}

class _DragTextState extends State<DragText> {
  final List<String> list = [
    "tiger",
    "cloud",
    "building",
    "tree",
    "hospital",
    "building",
    "tree",
    "hospital"
  ];
  double textSize;
  @override
  initState() {
    super.initState();
    if (widget.data != null) if (widget.data.isNotEmpty) {
      list.clear();
      list.addAll(widget.data);
    }
    list.sort((a, b) => a.length.compareTo(b.length));
    print('list $list');
  }

  Widget _build(String s) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(12)),
      height: textSize + 10,
      width: s.length.toDouble() * textSize * .6,
      child: Center(
        child: Text(
          s,
          style: TextStyle(fontSize: textSize),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textSize = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width * .065
        : MediaQuery.of(context).size.height * .065;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Drag and drop the text to their relevant image',
              style: TextStyle(fontSize: 23),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.orange),
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/stories/images/001page1.jpg'),
                    )),
              ),
            ),
            Expanded(
              flex: 6,
              child: Wrap(
                  runAlignment: WrapAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: list
                      .map((s) => Draggable(
                            feedback: Material(
                              color: Colors.transparent,
                              child: _build(s),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: _build(s),
                            ),
                            childWhenDragging: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _build(s),
                            ),
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
