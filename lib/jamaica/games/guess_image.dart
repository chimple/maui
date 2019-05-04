import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/models/image_label_data.dart';

class GuessImage extends StatefulWidget {
  final String imageName;
  final OnGameOver onGameOver;
  final BuiltList<ImageItemDetail> imageItemDetails;

  const GuessImage(
      {Key key, this.imageName, this.imageItemDetails, this.onGameOver})
      : super(key: key);
  @override
  _GuessImageState createState() => _GuessImageState();
}

class _GuessImageState extends State<GuessImage> {
  List<String> label = [];
  double textSize;
  @override
  void initState() {
    super.initState();
    widget.imageItemDetails.map((f) {
      label.add(f.itemName);
    }).toList();
    label.sort((a, b) => a.length.compareTo(b.length));
  }

  @override
  Widget build(BuildContext context) {
    textSize = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width * .065
        : MediaQuery.of(context).size.height * .065;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(widget.imageName),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Drag and drop the text to their relevant image',
              style: TextStyle(fontSize: 23),
            ),
          ),
          Wrap(
              runAlignment: WrapAlignment.center,
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: label
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
        ],
      ),
    );
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
}
