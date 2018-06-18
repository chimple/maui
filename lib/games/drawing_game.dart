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
  bool visibilityColor = false;
  bool visibilityWidth = false;

  _changed(bool visibility, String field) {
    setState(() {
      if (field == "colr") {
        visibilityColor = visibility;
      }
      if (field == "widt") {
        visibilityWidth = visibility;
      }
    });
  }

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
      0xff000000,
      0xffd50000,
      0xff00e676,
      0xffffd75f,
      0xff2962ff,
      0xffd50670,
      0xff00e876,
      0xffffe67f,
      0xff29624f,
      0xffd53450,
      0xff00e676,
      0xffffd54f,
      0xff2962ff,
      0xffd50760,
      0xff00e676,
      0xffffd68f,
      0xff000000,
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
          // new Expanded(
          // flex: 1,
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Container(
                    width: constraints.maxWidth * 0.2,
                    height: constraints.maxWidth * 0.07,
                    child: new RaisedButton(
                      child: new Text("Clear"),
                      color: Colors.blue,
                      onPressed: _onClear,
                    )),
                new Container(
                    width: constraints.maxWidth * 0.2,
                    height: constraints.maxWidth * 0.07,
                    child: new RaisedButton(
                      child: new Text("Undo"),
                      color: Colors.blue,
                      onPressed: _onUndo,
                    )),
                new Container(
                    width: constraints.maxWidth * 0.2,
                    height: constraints.maxWidth * 0.07,
                    child: new RaisedButton(
                      child: new Text("Send"),
                      color: Colors.blue,
                      onPressed: _onSend,
                    )),
              ]),
          // ),
          //),
          new FittedBox(
            child: new FittedBox(
              fit: BoxFit.fill,
              child: new Container(
                color: Colors.grey,
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.5,
                margin: EdgeInsets.only(top: 5.0),
                child: new MyDrawPage(_padController,
                    key: new GlobalObjectKey('MyDrawPage')),
                key: new Key('draw_screen'),
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new InkWell(
                  onTap: () {
                    visibilityColor
                        ? _changed(false, "colr")
                        : _changed(true, "colr");
                    _changed(false, "widt");
                  },
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        new Icon(Icons.comment,
                            color: visibilityColor
                                ? Colors.grey[400]
                                : Colors.grey[800],
                            size: constraints.maxWidth * 0.1),
                        new Container(
                          // margin: const EdgeInsets.only(top: 8.0),
                          child: new Text(
                            "Colors",
                            style: new TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: visibilityColor
                                  ? Colors.grey[400]
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              new InkWell(
                  onTap: () {
                    visibilityWidth
                        ? _changed(false, "widt")
                        : _changed(true, "widt");
                    _changed(false, "colr");
                  },
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        new Icon(Icons.local_offer,
                            color: visibilityWidth
                                ? Colors.grey[400]
                                : Colors.grey[800],
                            size: constraints.maxWidth * 0.1),
                        new Container(
                          child: new Text(
                            "Width",
                            style: new TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: visibilityWidth
                                  ? Colors.grey[400]
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          visibilityColor
              ? new Expanded(
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: color_val
                        .map((colorValue) => Center(
                              child: new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                    color: new Color(colorValue),
                                    shape: BoxShape.circle),
                                margin: new EdgeInsets.all(5.0),
                                child: new FlatButton(
                                  onPressed: () => _multiColor(colorValue),
                                ),
                              ),
                            ))
                        .toList(growable: false),
                  ),
                )
              : new Container(),
          visibilityWidth
              ? new Expanded(
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: width_val
                        .map((widthValue) => Center(
                              child: new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        image: new AssetImage(
                                            'assets/dice_game/1.png')),
                                    color: Colors.white10,
                                    shape: BoxShape.circle),
                                margin: new EdgeInsets.all(5.0),
                                child: new FlatButton(
                                  onPressed: () => _multiWidth(widthValue),
                                ),
                              ),
                            ))
                        .toList(growable: false),
                  ),
                )
              : new Container(),
        ]);
      });
    } else {
      print({'landscape mode ....': ""});

      return new LayoutBuilder(builder: (context, constraints) {
        print({"this is constraints": constraints});

        return new Flex(direction: Axis.horizontal, children: <Widget>[
          new Expanded(
              flex: 2,
              child: new Column(children: <Widget>[
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
                                fontWeight: FontWeight.bold)))),
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
              child: new Column(children: <Widget>[
                //  new Expanded(
                // flex: 4,
                new FittedBox(
                  fit: BoxFit.contain,
                  child: new Container(
                    margin: EdgeInsets.only(top: 5.0),
                    color: Colors.grey,
                    width: constraints.maxWidth * .6,
                    height: constraints.maxHeight * 0.75,

                    // otherwise the logo will be tiny
                    child: new MyDrawPage(_padController,
                        key: new GlobalObjectKey('MyDrawPage')),
                    key: new Key('draw_screen'),
                  ),
                ),
                // ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new InkWell(
                        onTap: () {
                          visibilityColor
                              ? _changed(false, "colr")
                              : _changed(true, "colr");
                          _changed(false, "widt");
                        },
                        child: new Container(
                          margin: new EdgeInsets.only(top: 8.0),
                          child: new Column(
                            children: <Widget>[
                              new Icon(Icons.comment,
                                  color: visibilityColor
                                      ? Colors.grey[400]
                                      : Colors.grey[800],
                                  size: constraints.maxHeight * 0.08),
                              new Container(
                                // padding: new EdgeInsets.only(top: 10.0),
                                // margin: const EdgeInsets.only(top: 8.0),
                                child: new Text(
                                  "Colors",
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: visibilityColor
                                        ? Colors.grey[400]
                                        : Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    new SizedBox(
                      width: constraints.maxHeight * 0.06,
                    ),
                    new InkWell(
                        onTap: () {
                          visibilityWidth
                              ? _changed(false, "widt")
                              : _changed(true, "widt");
                          _changed(false, "colr");
                        },
                        child: new Container(
                          margin: new EdgeInsets.only(top: 8.0),
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                Icons.local_offer,
                                color: visibilityWidth
                                    ? Colors.grey[400]
                                    : Colors.grey[800],
                                size: constraints.maxHeight * 0.08,
                              ),
                              new Container(
                                // padding: new EdgeInsets.only(top: 10.0),
                                // margin: const EdgeInsets.only(top: 8.0),
                                child: new Text(
                                  "Width",
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: visibilityWidth
                                        ? Colors.grey[400]
                                        : Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                visibilityColor
                    ? new Expanded(
                        // flex: 1,
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: color_val
                              .map((colorValue) => Center(
                                    child: new Container(
                                      width: 40.0,
                                      height: 40.0,
                                      // key: new Key('Green'),
                                      decoration: new BoxDecoration(
                                          color: new Color(colorValue),
                                          shape: BoxShape.circle),
                                      // child: new Text("$width_val"),
                                      margin: new EdgeInsets.all(5.0),
                                      child: new FlatButton(
                                        onPressed: () =>
                                            _multiColor(colorValue),
                                      ),
                                    ),
                                  ))
                              .toList(growable: false),
                        ),
                      )
                    : Container(),
                visibilityWidth
                    ? new Expanded(
                        // flex: 1,
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: width_val
                              .map((widthValue) => Center(
                                    child: new Container(
                                      width: 40.0,
                                      height: 40.0,
                                      key: new Key('Green'),
                                      decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                              image: new AssetImage(
                                                  'assets/dice_game/1.png')),
                                          color: Colors.white10,
                                          shape: BoxShape.circle),
                                      // child: new Text("$width_val"),
                                      margin: new EdgeInsets.all(5.0),
                                      child: new FlatButton(
                                        onPressed: () =>
                                            _multiWidth(widthValue),
                                      ),
                                    ),
                                  ))
                              .toList(growable: false),
                        ),
                      )
                    : Container(),
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
    _changed(false, "colr");
    print({"this is _multiColor methode": colorValue});
  }

  void _multiWidth(widthValue) {
    _padController.multiWidth(widthValue);
    _changed(false, "widt");
    print({"this is _multiWidth methode": widthValue});
  }
}
