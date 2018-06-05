import 'package:flutter/material.dart';
import '../components/drawing.dart';
import 'dart:ui' as ui;

class Drawing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  Drawing(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DrawScreen();
}

class DrawScreen extends State<Drawing> {
  DrawPadController _padController = new DrawPadController();
//  void initState() {
//    print({"init State - in drawScreen": "line 22"});
//    _padController = new DrawPadController();
//  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    MediaQueryData media = MediaQuery.of(context);
//    print({"this is mediaaa1:": media.size});
//    final height = media.size.height;
//    final width = media.size.width;
    var assetsImage = new AssetImage('assets/apple.png');
    List<int> color_val = [
      0xff00e676,
      0xffffd54f,
      0xff2962ff,
      0xffd50760,
      0xff00e676,
      0xffffd68f,
      0xff2962ff,
      0xffd50000,
      0xff00e676,
      0xffffd75f,
      0xff2962ff,
      0xffd50670,
      0xff00e876,
      0xffffe67f,
      0xff29624f,
      0xffd53450,
    ];
    List<double> width_val = [
      2.0,
      5.0,
      8.0,
      10.0,
      12.0,
      15.0,
      18.0,
      20.0,
      22.0,
      25.0,
      28.0,
      30.0,
    ];
    // var X = color_val;

   if (orientation == Orientation.portrait) {
    // if (media.size.height > media.size.width) {
      return new LayoutBuilder(builder: (context, constraints) {
        print({"this is constraints": "potrait"});
        // return new Container(
        //     width: constraints.maxWidth, height: constraints.maxHeight,
        return new Flex(direction: Axis.vertical, children: <Widget>[
          new FittedBox(
            child: new Image(
                image: assetsImage,
                width: constraints.maxWidth * 0.5,
                height: constraints.maxHeight * 0.2),
          ),
          new FittedBox(
            child: new Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.08,
                child: new Text("APPLE",
                    key: new Key('imgtext'),
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: constraints.maxHeight * 0.05,
                        fontWeight: FontWeight.bold))),
          ),
          // new Container(
          //     width: constraints.maxWidth, height: constraints.maxHeight * 0.1,
          new Expanded(
            // flex: 1,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Container(
                      width: constraints.maxWidth * 0.2,
                      height: constraints.maxWidth * 0.1,
                      child: new RaisedButton(
                        child: new Text("Clear"),
                        color: Colors.blue,
                        onPressed: _onClear,
                      )),
                  new Container(
                      width: constraints.maxWidth * 0.2,
                      height: constraints.maxWidth * 0.1,
                      child: new RaisedButton(
                        child: new Text("Undo"),
                        color: Colors.blue,
                        onPressed: _onUndo,
                      )),
                  new Container(
                      width: constraints.maxWidth * 0.2,
                      height: constraints.maxWidth * 0.1,
                      child: new RaisedButton(
                        child: new Text("Send"),
                        color: Colors.blue,
                        onPressed: _onSend,
                      )),
                ]),
          ),
          //),
          new FittedBox(
            child: new FittedBox(
              fit: BoxFit.cover,
              child: new Container(
                color: Colors.grey,
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.5,
                margin: EdgeInsets.only(top: 5.0),

                // otherwise the logo will be tiny
                child: new MyDrawPage(
                  _padController,
                  key: new GlobalObjectKey('MyDrawPage')
                ),
                key: new Key('draw_screen'),
              ),
            ),
          ),

          new Expanded(
            // flex: 1,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: color_val
                  .map((colorValue) => Center(
                    child: new Container(
                            width: constraints.maxHeight * 0.06,
                            height: constraints.maxHeight * 0.06,
                            // key: new Key('Green'),
                            decoration: new BoxDecoration(
                                color: new Color(colorValue),
                                shape: BoxShape.circle),
                            // child: new Text("$width_val"),
                            margin: new EdgeInsets.all(5.0),
                        child: new FlatButton(
                          onPressed: () => _multiColor(colorValue),
                          
                          ),
                        ),
                      ))
                  .toList(growable: false),
            ),
          ),
          new Expanded(
            // flex: 1,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: width_val
                  .map((widthValue) => Center(
                    child: new Container(
                            width: constraints.maxHeight * 0.06,
                            height: constraints.maxHeight * 0.06,
                            decoration: new BoxDecoration(
                                color: new Color(0xff000000),
                                shape: BoxShape.circle),
                            // child: new Text("$width_val"),
                            margin: new EdgeInsets.all(5.0),
                        child: new FlatButton(
                          onPressed: () => _multiWidth(widthValue),
                          
                            
                          ),
                        ),
                      ))
                  .toList(growable: false),
            ),
          )
        ]);
      });
      
    } else {
      print({'landscape mode ....': ""});

      return new LayoutBuilder(builder: (context, constraints) {
        print({"this is constraints": constraints});

        return new Flex(direction: Axis.horizontal, children: <Widget>[
              new Expanded(
                flex: 2,
              child: new Column(
                children: <Widget>[
                new Expanded(
                flex: 2,
                child: new Image(
                    image: assetsImage,
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxHeight * 0.3),
              ),
                new FittedBox(
                  child: new Container(
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxHeight * 0.1,
                    child: new Text("APPLE",
                        key: new Key('imgtext'),
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: constraints.maxHeight * 0.1,
                            fontWeight: FontWeight.bold)))
                ),
                new Expanded(
                  flex: 2,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                      width: constraints.maxHeight * 0.25,
                      height: constraints.maxHeight * 0.1,
                      child: new RaisedButton(
                        child: new Text("Clear"),
                        color: Colors.blue,
                        onPressed: _onClear,
                      )),
                  new Container(
                      width: constraints.maxHeight * 0.25,
                      height: constraints.maxHeight * 0.1,
                      child: new RaisedButton(
                        child: new Text("Undo"),
                        color: Colors.blue,
                        onPressed: _onUndo,
                      )),
                  new Container(
                      width: constraints.maxHeight * 0.25,
                      height: constraints.maxHeight * 0.1,
                      child: new RaisedButton(
                        child: new Text("Send"),
                        color: Colors.blue,
                        onPressed: _onSend,
                      )),
                        ]),
              )
                ])),
                new Expanded(
                  flex: 5,
              child: new Column(
                children: <Widget>[
              //  new Expanded(
            // flex: 4,
             new FittedBox(
              fit: BoxFit.contain,
              child: new Container(
                color: Colors.grey,
                width: constraints.maxWidth* .6,
                height: constraints.maxHeight * 0.75,

                // otherwise the logo will be tiny
                child: new MyDrawPage(
                  _padController,
                  key: new GlobalObjectKey('MyDrawPage')
                ),
                key: new Key('draw_screen'),
              ),
            ),
          // ),
                new Expanded(
            // flex: 1,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: color_val
                  .map((colorValue) => Center(
                    child: new Container(
                            width: constraints.maxWidth * 0.06,
                            height: constraints.maxWidth * 0.06,
                            // key: new Key('Green'),
                            decoration: new BoxDecoration(
                                color: new Color(colorValue),
                                shape: BoxShape.circle),
                            // child: new Text("$width_val"),
                            margin: new EdgeInsets.all(5.0),
                        child: new FlatButton(
                          onPressed: () => _multiColor(colorValue),
                          
                          ),
                        ),
                      ))
                  .toList(growable: false),
            ),
          ),
          new Expanded(
            // flex: 1,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: width_val
                  .map((widthValue) => Center(
                    child: new Container(
                            width: constraints.maxWidth * 0.06,
                            height: constraints.maxWidth * 0.06,
                            key: new Key('Green'),
                            decoration: new BoxDecoration(
                                color: new Color(0xff000000),
                                shape: BoxShape.circle),
                            // child: new Text("$width_val"),
                            margin: new EdgeInsets.all(5.0),
                        child: new FlatButton(
                          onPressed: () => _multiWidth(widthValue),
                          
                          ),
                        ),
                      ))
                  .toList(growable: false),
            ),
          )
                ]))
              // ])
            // ])
        ]);
      });
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
    print({"this is _multiColor methode": colorValue});
  }

  void _multiWidth(widthValue) {
    _padController.multiWidth(widthValue);
    print({"this is _multiWidth methode": widthValue});
  }
}

