import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopicButton extends StatelessWidget {
  final String text;
  final int color;
  final String image;
  final VoidCallback onPress;
  TopicButton({
    Key key,
    @required this.text,
    this.color,
    this.image,
    this.onPress,
//      this.sizeHieght,
//      this.sizeWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("hello Topic button $image and $text");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Material(
        elevation: 8.0,
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
        child: new Container(
          color: Colors.brown,
          child: new InkWell(
            onTap: onPress,
            child: new Stack(children: [
              new Column(
                children: <Widget>[
                  image == null
                      ? new Expanded(
                          child: Container(color: Colors.red),
                        )
                      : image.endsWith(".svg")
                          ? new Expanded(
                              child: new Container(
                                color: Colors.red,
                                child: new AspectRatio(
                                  aspectRatio: 2.0,
                                  child: new SvgPicture.asset(
                                    image,
                                    allowDrawingOutsideViewBox: false,
                                  ),
                                ),
                              ),
                            )
                          : new Expanded(
                              child: Container(
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: new AssetImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Colors.red),
                              ),
                            ),
                  Container(
                    child: new Text(
                      text,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
