import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/models/image_label_data.dart';

class GuessImage extends StatefulWidget {
  final String imageName;
  final OnGameUpdate onGameUpdate;
  final BuiltList<ImageItemDetail> imageItemDetails;
  const GuessImage(
      {Key key, this.imageName, this.imageItemDetails, this.onGameUpdate})
      : super(key: key);
  @override
  _GuessImageState createState() => _GuessImageState();
}

class _GuessImageState extends State<GuessImage> {
  List<String> label = [];
  int flag = 0;
  String dragText;
  double textSize;
  double centerX;
  double centerY;
  ImageInfo _imageInfo;
  AssetImage assestImage;
  double deviceHeight;
  double deviceWidth;
  double dx;
  double dy;
  int itemCount = 0;
  List<Widget> displayTextList = [];
  @override
  void initState() {
    super.initState();
    widget.imageItemDetails.map((f) {
      label.add(f.itemName);
    }).toList();
    label.sort((a, b) => a.length.compareTo(b.length));

    assestImage = AssetImage(widget.imageName);
    WidgetsBinding.instance.addPostFrameCallback((a) => _getImageInfo());
  }

  void _getImageInfo() async {
    Image image = new Image.asset(widget.imageName);
    image.image
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) {
      _imageInfo = info;
    });
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
          Expanded(
            child: Stack(
              children: <Widget>[
                Image(
                  image: assestImage,
                ),
                flag == 1
                    ? displayText(centerX, centerY, dragText)
                    : Container()
              ],
            ),
          ),
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
                        dragAnchor: DragAnchor.pointer,
                        onDragStarted: () {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(() {
                                    RenderBox getBox =
                                        context.findRenderObject();
                                    deviceHeight = getBox.size.height;
                                    deviceWidth = getBox.size.width;
                                    dragText = s;
                                  }));
                        },
                        onDragEnd: (details) {
                          dx = (details.offset.dx / deviceWidth) *
                              _imageInfo.image.width;
                          dy = ((details.offset.dy) / deviceWidth) *
                              _imageInfo.image.height;
                          setState(() {
                            dragEnd(dx, dy);
                          });
                        },
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

  Widget displayText(double x, double y, String s) {
    return Stack(children: displayTextList);
  }

  void dragEnd(double dx, double dy) {
    if (_imageInfo != null) {
      widget.imageItemDetails.forEach((c) {
        if ((c.x <= dx && dx <= c.x + c.width) &&
            (c.y <= dy && dy <= c.y + c.height)) {
          setState(() {
            double tempX = (c.x + c.x + c.width) / 2;
            double tempY = (c.y + c.y + c.height) / 2;
            centerX = ((tempX / _imageInfo.image.width) * deviceWidth);
            centerY = ((tempY / _imageInfo.image.width) * deviceWidth);
            if (c.itemName == dragText && itemCount < label.length) {
              displayTextList.add(Positioned(
                child: Text(
                  c.itemName,
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                ),
                left: centerX,
                top: centerY,
              ));
              flag = 1;
              itemCount++;
            }
          });
        }
      });
    }
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
