import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/models/image_label_data.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';

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
  int score = 0;
  int max = 0;
  double dy;
  List<Widget> displayTextList = [];
  @override
  void initState() {
    super.initState();
    widget.imageItemDetails.map((f) {
      label.add(f.itemName);
    }).toList();
    label.sort((a, b) => a.length.compareTo(b.length));
    max = label.length * 2;
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image(
                      image: assestImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                  flag == 1
                      ? displayText(centerX, centerY, dragText)
                      : Container()
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: BentoBox(
              dragConfig: DragConfig.draggableBounceBack,
              calculateLayout: BentoBox.calculateVerticalLayout,
              rows: 2,
              cols: 4,
              children: label.map((s) {
                return CuteButton(
                  cuteButtonType: CuteButtonType.text,
                  key: Key('$s'),
                  child: Material(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2.0,
                          )),
                      child: Text(
                        s,
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                  onDragStarted: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => setState(() {
                              RenderBox getBox = context.findRenderObject();
                              deviceHeight = getBox.size.height;
                              deviceWidth = getBox.size.width;
                              dragText = s;
                            }));
                  },
                );
              }).toList(),
              onDragEnd: (d) {
                print('details in DragEnd is ${d.offset}');
                dx = (d.offset.dx / deviceWidth) * _imageInfo.image.width;
                dy = ((d.offset.dy) / deviceWidth) * _imageInfo.image.height;
                print('image dx and dy  is $dx and $dy ');
                dragEnd(dx, dy);
              },
            ),
          ),
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
          double tempX = (c.x + c.x + c.width) / 2;
          double tempY = (c.y + c.y + c.height) / 2;
          centerX = ((tempX / _imageInfo.image.height) * deviceWidth);
          centerY = ((tempY / _imageInfo.image.height) * deviceWidth);
          if (c.itemName == dragText) {
            displayTextList.add(Positioned(
              child: Text(
                c.itemName,
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
              left: centerX,
              top: centerY,
            ));
            flag = 1;
            setState(() {
              label.remove(c.itemName);
              score += 2;
              widget.onGameUpdate(
                  score: score, max: max, gameOver: false, star: true);
              if (label.isEmpty) {
                widget.onGameUpdate(
                    score: score, max: max, gameOver: true, star: true);
              }
            });
          } else {
            score -= 1;
            widget.onGameUpdate(
                score: score, max: max, gameOver: false, star: false);
          }
        }
      });
    }
  }
}
