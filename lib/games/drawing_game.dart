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
    print({"init State - in drawScreen": "line 22"});
    _padController = new DrawPadController();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    MediaQueryData media = MediaQuery.of(context);
//    print({"this is mediaaa1:": media.size});
//    final height = media.size.height;
//    final width = media.size.width;
    var assetsImage = new AssetImage('assets/apple.png');

//    if (orientation == Orientation.portrait) {
    if(media.size.height > media.size.width){
    return new LayoutBuilder(builder: (context, constraints)
    {
      print({"this is constraints":"potrait"});
        return new Container(
            width: constraints.maxWidth, height: constraints.maxHeight,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Column(children: <Widget>[
                    new Image(image: assetsImage,
                        width: constraints.maxWidth * 0.5,
                        height: constraints.maxHeight * 0.18),
                    new Container(
                        width: constraints.maxWidth, height: constraints.maxHeight * 0.08,
                        child: new Text("APPLE",
                            key: new Key('imgtext'),
                            textAlign: TextAlign.center,
                            style:
                            new TextStyle(
                                fontSize: constraints.maxHeight * 0.05,
                                fontWeight: FontWeight.bold))
                    ),
                    new Container(
                        width: constraints.maxWidth, height: constraints.maxHeight * 0.1,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                onPressed: _onSend,
                              ),
                            ]
                        )
                    ),
                    new FittedBox(
                      fit: BoxFit.fill,
                      child: new Container(
                        width: constraints.maxWidth, height: constraints.maxHeight * 0.5,

                        // otherwise the logo will be tiny
                        child: new MyDrawPage(_padController,
                            key: new GlobalObjectKey('MyDrawPage')),
                        key: new Key('draw_screen'),
                      ),
                    ),

                    new FittedBox(
                      child: new Column(
                        children: <Widget>[
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new FlatButton(
                                  onPressed: () => _multiColor(0xff00e676),
                                  child: new Container(
                                    width: constraints.maxWidth * 0.06,
                                    height: constraints.maxWidth * 0.06,
                                    key: new Key('Green'),
                                    decoration: new BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle
                                    ),
                                    margin: new EdgeInsets.all(5.0),
                                  ),
                                ),
                                new FlatButton(
                                  onPressed: () => _multiColor(0xffffd54f),
                                  child: new Container(
                                    width: constraints.maxWidth * 0.06,
                                    height: constraints.maxWidth * 0.06,
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
                                  child: new Container(
                                    width: constraints.maxWidth * 0.06,
                                    height: constraints.maxWidth * 0.06,
                                    key: new Key('Blue'),
                                    decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle
                                    ),
                                    margin: new EdgeInsets.all(5.0),
                                  ),
                                ),
                                new FlatButton(
                                  onPressed: () => _multiColor(0xffd50000),
                                  child: new Container(
                                    width: constraints.maxWidth * 0.06,
                                    height: constraints.maxWidth * 0.06,
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
                                  child: new Container(
                                    width: constraints.maxWidth * 0.035,
                                    height: constraints.maxWidth * 0.035,
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
                                  child: new Container(
                                    width: constraints.maxWidth * 0.044,
                                    height: constraints.maxWidth * 0.044,
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
                                  child: new Container(
                                    width: constraints.maxWidth * 0.054,
                                    height: constraints.maxWidth * 0.054,
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
                                    child: new Container(
                                        width: constraints.maxWidth * 0.06,
                                        height: constraints.maxWidth * 0.06,
                                        key: new Key('xl'),
                                        decoration: new BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.rectangle
                                        ),
                                        margin: new EdgeInsets.all(5.0)
                                    )
                                )
                              ])
                        ],
                      ),
                    )
                  ])
                ]
            )
        );
      }
    );
    }
    else {
      print({'landscape mode ....': ""});
      return new LayoutBuilder(builder: (context, constraints)
      {
        print({"this is constraints": constraints});

        return new Padding(
            padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: new Row(
                children: <Widget>[
                  new Column(
                      children: <Widget>[
                        new Image(image: assetsImage,
                            width: constraints.maxWidth * 0.3,
                            height: constraints.maxHeight * 0.45),
                        new Container(
                            width: constraints.maxWidth * 0.2, height: constraints.maxHeight * 0.1,
                            child: new Text("APPLE",
                                key: new Key('imgtext'),
                                textAlign: TextAlign.center,
                                style:
                                new TextStyle(
                                    fontSize: constraints.maxHeight * 0.08,
                                    fontWeight: FontWeight.bold))
                        ),
                        new Container(
                            width: constraints.maxWidth * 0.2, height: constraints.maxHeight * 0.4,
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
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
                            width: constraints.maxWidth * 0.7, height: constraints.maxHeight * 0.75,

                            // otherwise the logo will be tiny
                            child: new MyDrawPage(_padController,
                                key: new GlobalObjectKey('MyDrawPage')),
                            key: new Key('draw_screen'),
                          ),
                        ),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new FlatButton(
                                onPressed: () => _multiColor(0xff00e676),
                                child: new Container(
                                  width: constraints.maxHeight * 0.06,
                                  height: constraints.maxHeight * 0.06,
                                  key: new Key('Green'),
                                  decoration: new BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle
                                  ),
                                  margin: new EdgeInsets.all(5.0),
                                ),
                              ),
                              new FlatButton(
                                onPressed: () => _multiColor(0xFFF1F8E9),
                                child: new Container(
                                  width: constraints.maxHeight * 0.06,
                                  height: constraints.maxHeight * 0.06,
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
                                child: new Container(
                                  width: constraints.maxHeight * 0.06,
                                  height: constraints.maxHeight * 0.06,
                                  key: new Key('Blue'),
                                  decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle
                                  ),
                                  margin: new EdgeInsets.all(5.0),
                                ),
                              ),
                              new FlatButton(
                                onPressed: () => _multiColor(0xffd50000),
                                child: new Container(
                                  width: constraints.maxHeight * 0.06,
                                  height: constraints.maxHeight * 0.06,
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
                                child: new Container(
                                  width: constraints.maxHeight * 0.02,
                                  height: constraints.maxHeight * 0.02,
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
                                child: new Container(
                                  width: constraints.maxHeight * 0.025,
                                  height: constraints.maxHeight * 0.025,
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
                                child: new Container(
                                  width: constraints.maxHeight * 0.03,
                                  height: constraints.maxHeight * 0.03,
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
                                child: new Container(
                                  width: constraints.maxHeight * 0.035,
                                  height: constraints.maxHeight * 0.035,
                                  key: new Key('xl'),
                                  decoration: new BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.rectangle
                                  ),
                                  margin: new EdgeInsets.all(5.0),
                                ),
                              ),

                            ]),
                      ]
                  )


                ]
            )
        );
      }
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
