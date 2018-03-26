import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../components/drawing.dart';

class Drawing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Drawing({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DrawScreen();
}

class DrawScreen extends State<Drawing> {
  DrawPadController _padController;
  void initState() {
    _padController = new DrawPadController();
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/apple.png');
    var image = new Image(image: assetsImage, width: 150.0, height: 150.0);

    return new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Column(children: <Widget>[
            image,
            new Text("APPLE",
                style:
                    new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                    child: new Text("Clear"),
                    color: Colors.blue,
                    onPressed: _onClear,
                  ),
                  new RaisedButton(
                      child: new Text("Undo"),
                      color: Colors.blue,
                      onPressed: null),
                  new RaisedButton(
                    child: new Text("Send"),
                    color: Colors.blue,
                    onPressed: null,
                  ),
                ]),
          ]),
          new Column(
//                      child:  new Container(
//                        color: Colors.red,

//                          height: 200.0,
//                          width: 200.0,
            children: <Widget>[
              new FittedBox(
                fit: BoxFit.fill,
                // otherwise the logo will be tiny
                child: new MyDrawPage(_padController,),
              ),
            ],
          ),
//                    ),
        ]));
  }
  void _onClear() {
    _padController.clear();
    print("this is clear methode");
  }

}

