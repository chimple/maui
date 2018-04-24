import 'package:flutter/material.dart';
import '../components/drawing.dart';
import 'dart:ui' as ui;

class Draw_Challenge extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  Draw_Challenge({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.isRotated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new Draw_Challenge_Screen();
}

class Draw_Challenge_Screen extends State<Draw_Challenge> {
  DrawPadController _padController;
  void initState() {
    _padController = new DrawPadController();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    MediaQueryData media = MediaQuery.of(context);
    print({"this is mediaaa:": media.size});
    final height = media.size.height;
    final width = media.size.width;

    var assetsImage = new AssetImage('assets/apple.png');

    if (orientation == Orientation.portrait) {
      return new Container(
          width: width, height: height,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Column(children: <Widget>[
                new Image(image: assetsImage, width: width*0.5, height: height*0.13),
                  new Container(
                    width: width, height: height*0.05,
                    child : new Text("APPLE",
                        key: new Key('imgtext'),
                        textAlign: TextAlign.center,
                        style:
                        new TextStyle(
                            fontSize: height*0.04, fontWeight: FontWeight.bold))
                  ),


                  new Container(
                    width: width, height: height*0.08,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new RaisedButton(
                            child: new Text("Send"),
                            color: Colors.blue,
                            onPressed: _onSend,
                          ),
                        ]
                    )
                  ),


                  new FittedBox(
                    fit: BoxFit.fill,
                    child: new Container(
                      width: width, height: height*0.44,

                      // otherwise the logo will be tiny
                      child: new MyDrawPage(_padController, key: new GlobalObjectKey('MyDrawPage')),
                      key: new Key('draw_screen'),
                    ),
                  ),

                ])
              ]
          )
      );
    }

    else {

      return new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
    child: new Row(
    children: <Widget>[
      new Column(
    children: <Widget>[
      new Image(image: assetsImage, width: width*0.25, height: height*0.35),
      new Container(
          width: width*0.2, height: height*0.1,
          child : new Text("APPLE",
              key: new Key('imgtext'),
              textAlign: TextAlign.center,
              style:
              new TextStyle(
                  fontSize: height*0.08, fontWeight: FontWeight.bold))
      ),
      new Container(
          width: width*0.2, height: height*0.3,
     child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RaisedButton(
              child: new Text("Send"),
              color: Colors.blue,
              onPressed: _onSend,
            )
          ])
      )
    ]
      ),


      new Column(
      children: <Widget>[
      new FittedBox(
        fit: BoxFit.fill,
        child: new Container(
          width: width*0.7, height: height*0.69,

          // otherwise the logo will be tiny
          child: new MyDrawPage(_padController, key: new GlobalObjectKey('MyDrawPage')),
          key: new Key('draw_screen'),
        ),
      ),
        ]
      )


      ]
    )
      );
    }
  }
  void _onClear() {
    _padController.clear();

  }

  void _onUndo() {
    _padController.undo();
    print("this is undo methode");
  }
  void _onSend() {
    _padController.send();
  }

  void _multiColor(colorValue) {
    _padController.multiColor(colorValue);
    print({"this is _multiColor methode" : colorValue});
  }
  void _multiWidth(widthValue) {
    _padController.multiWidth(widthValue);
    print({"this is _multiWidth methode" : widthValue});
  }
}
