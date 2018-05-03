import 'package:flutter/material.dart';

class Sticker extends StatefulWidget {
  final String title;
  // final Offset initpos;
  final double x, y;
  Sticker({Key key, this.title, this.x, this.y}) : super(key: key);

  @override
  _StickerState createState() => new _StickerState();
}

class _StickerState extends State<Sticker> {
  String guess;
  // Offset position = new Offset(0.0, 0.0);

  @override
  void initState() {
    // TODO: implement initState
    guess = widget.title;
    // position = widget.initpos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: widget.x,
      top: widget.y,
      child: new Text(
          guess,
          style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      ),
    );
  }
}
