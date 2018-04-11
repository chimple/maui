import 'package:flutter/material.dart';
import '../components/drawing.dart';
import 'dart:ui' as ui;

class Drawing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  Drawing({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.isRotated})
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
    MediaQueryData media = MediaQuery.of(context);
    print({"this is mediaaa:": media.size});
    var assetsImage = new AssetImage('assets/apple.png');
    var image = new Image(image: assetsImage, width: media.size.width, height: media.size.height*0.2);

    return new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Column(children: <Widget>[
            image,
            new Text("APPLE",
                key: new Key('imgtext'),
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
                    onPressed: _onUndo,
                  ),
                  new RaisedButton(
                    child: new Text("Send"),
                    color: Colors.blue,
                    onPressed: null,
                  ),
                ]),
          ]),
          new Column(
            children: <Widget>[
              new FittedBox(
                fit: BoxFit.fill,
                child: new Container(
                  width: media.size.width, height: media.size.height*0.4,

                // otherwise the logo will be tiny
                child: new MyDrawPage(_padController,),
                key: new Key('draw_screen'),
                ),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () => _multiColor(0xff00e676),
                      child:  new Container(
                              width: 30.0, height: 30.0,
                              key: new Key('Green'),
                              decoration: new BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle
                              ),
                              margin: new EdgeInsets.all(5.0),
                              ),
                    ),
                    new FlatButton(
                      onPressed: () => _multiColor(0xffffea00),
                      child:  new Container(
                        width: 30.0, height: 30.0,
                        key: new Key('Yellow'),
                        decoration: new BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),
                    new FlatButton(
                      onPressed: () => _multiColor(0xff2962ff),
                      child:  new Container(
                        width: 30.0, height: 30.0,
                        key: new Key('Blue'),
                        decoration: new BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),
                    new FlatButton(
                      onPressed: () => _multiColor(0xffc51162),
                      child:  new Container(
                        width: 30.0, height: 30.0,
                        key: new Key('Red'),
                        decoration: new BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),

                  ]),


              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () => _multiWidth(5.0),
                      child:  new Container(
                        width: 15.0, height: 15.0,
                        key: new Key('s'),
                        decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),
                    new FlatButton(
                      onPressed: () => _multiWidth(8.0),
                      child:  new Container(
                        width: 19.0, height: 19.0,
                        key: new Key('m'),
                        decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),
                    new FlatButton(
                      onPressed: () => _multiWidth(10.0),
                      child:  new Container(
                        width: 21.0, height: 21.0,
                        key: new Key('l'),
                        decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),
                    new FlatButton(
                      onPressed: () => _multiWidth(15.0),
                      child:  new Container(
                        width: 24.0, height: 24.0,
                        key: new Key('xl'),
                        decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle
                        ),
                        margin: new EdgeInsets.all(5.0),
                      ),
                    ),

                  ]),
            ],
          ),
//                    ),
        ]));
  }
  void _onClear() {
    _padController.clear();
    print("this is clear methode");
  }

  void _onUndo() {
    _padController.undo();
    print("this is undo methode");
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
