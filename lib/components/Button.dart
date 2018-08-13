import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  int keys;

  MyButton(
      {Key key,
      this.text,
      this.keys,
      this.onPress})
      : super(key: key);
  
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton>{
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;

  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    print("_MyButtonState.build");

    double ht = MediaQuery.of(context).size.height;
    double wd = MediaQuery.of(context).size.width;

    return new GestureDetector(
                  child: new ButtonTheme(
                    minWidth: 150.0,
                    height: 150.0,
                    child: new RaisedButton(
                   onPressed: () => widget.onPress(),
                   color: const Color(0xFFffffff),
                   shape: new RoundedRectangleBorder(
                       borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                   child: _displayText.endsWith(".png")? new Image.asset("$_displayText", width: 150.0, height: 150.0,) : new Text(_displayText,
                       key: new Key("${widget.keys}"),
                       style: new TextStyle(color: Colors.black, fontSize: ht * 0.05))
      )),
    );
  }
}
