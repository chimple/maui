import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Button extends StatelessWidget {
  final String text;
  final int color;
  final String image;
  final VoidCallback onPress;
  final double sizeHieght;
  final double sizeWidth;
  Button(
      {Key key,
      @required this.text,
      this.color,
      this.image,
      this.onPress,
      this.sizeHieght,
      this.sizeWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new InkWell(
        onTap: onPress,
        child: new Column(
          children: <Widget>[
            Container(
              height: sizeHieght,
              width: sizeWidth,
              decoration: new BoxDecoration(
                  color: Color(color),
                  image: image != null
                      ? new DecorationImage(image: new AssetImage(image))
                      : null),
            ),
            Container(
              color: Color(0xff3399ff),
//              width: 100.0,
              height: sizeHieght / 6,
              width: sizeWidth,
              child: new Text(
                text,
                style: new TextStyle(
                    color: Colors.white, fontSize: sizeHieght / 8),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
