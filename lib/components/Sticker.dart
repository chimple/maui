import 'package:flutter/material.dart';

class Sticker extends StatefulWidget {
  String title;
  Sticker(this.title);

  @override
  _StickerState createState() => new _StickerState();
}

class _StickerState extends State<Sticker> {
  String guess;

  @override
    void initState() {
      // TODO: implement initState
      guess = widget.title;
      super.initState();
    }


  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          new Positioned(
            left: 50.0,
            top: 100.0,
            child: new Text(guess, style: new TextStyle(fontSize: 150.0, fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }
}