import 'package:flutter/material.dart';

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
    return new Container(
      color: Colors.brown,
      child: new InkWell(
        onTap: onPress,
        child: new Stack(children: [
          new Column(
            children: <Widget>[
              new Expanded(
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
          ),
        ]),
      ),
    );
  }
}
