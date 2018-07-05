import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:tuple/tuple.dart';
import '../components/drawing.dart';
import 'package:maui/repos/game_data.dart';
import '../components/SecondScreen.dart';

class Drawing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  GameConfig gameConfig;
  bool isRotated;

  Drawing(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DrawScreen();
}

class DrawScreen extends State<Drawing> {
  DrawPadController _padController = new DrawPadController();
  bool visibilityColor = false;
  bool visibilityWidth = false;
  bool _isLoading = true;
  int navVal = 0;
  List<String> choice = [];
  Tuple2<String, List<String>> drawingData;
  var ansimage;
  int selectedColor = 0xff000000;
  String drawJson;
  int count = 0;
  List<String> DrawData;
  List<String> ReceiveData;

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['myData'] = DrawData;
    data['otherData'] = ReceiveData;
    return data;
  }

  void fromJsonMap(Map<String, dynamic> data) {
    ReceiveData = data['myData'].cast<String>();
    DrawData = data['otherData'].cast<String>();
  }

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    navVal=0;
    setState(() => _isLoading = true);
    // print('gameData manuuuuuuuuuu : ${widget.gameConfig.gameData}');
    if (widget.gameConfig.gameData != null) {
      fromJsonMap(widget.gameConfig.gameData);
    } else {
      DrawData = [drawJson];
      ReceiveData = [];
    }
    drawingData = await fetchDrawingData(widget.gameCategoryId);
    choice = drawingData.item2;
    ansimage = choice[0];
    print('gameData: ${widget.gameConfig.gameData}');
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Drawing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      print(
          "both the iterartin is old...${oldWidget.iteration}.........new ${widget.iteration}");
      navVal = widget.iteration;

      print("navi value is... $navVal");
      // if (navVal == 0 && count == 0) {
      //   count++;
      //   navVal;
      // } else {
      //   count = 0;
      //   navVal = 1;
      // }

      _initBoard();
    }
  }

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
    var assetsImage = new AssetImage('assets/dict/${choice[1]}.png');
    List<int> color_val = [
      0xff00e676,
      0xffffd54f,
      0xff2962ff,
      0xffd50760,
      0xff00e376,
      0xffffd68f,
      0xff000000,
      0xffd50000,
      0xff00e356,
      0xffffd75f,
      0xff2332ff,
      0xffd50670,
      0xff00e876,
      0xffffe67f,
      0xff29624f
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
      30.0
    ];
    int roundColor;

    if (selectedColor == 0xff000000)
      roundColor = 0xff00e676;
    else
      roundColor = 0xff000000;

    if (orientation == Orientation.portrait) {
      // if (media.size.height > media.size.width) {
      print("draw json isss $drawJson");
      print("navigatin to $navVal");
      return navVal == 0
          ? new LayoutBuilder(builder: (context, constraints) {
              print({"this is constraints": "potrait"});
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
                      child: new Text('${choice[1].toUpperCase()}',
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
                            child: new Icon(Icons.clear,
                                color: Colors.black,
                                size: constraints.maxWidth * .07),
                            onPressed: _onClear,
                          )),
                      new Container(
                          width: constraints.maxWidth * 0.2,
                          height: constraints.maxWidth * 0.07,
                          child: new RaisedButton(
                            child: new Icon(Icons.undo,
                                color: Colors.black,
                                size: constraints.maxWidth * .07),
                            onPressed: _onUndo,
                          )),
                      new Container(
                          width: constraints.maxWidth * 0.2,
                          height: constraints.maxWidth * 0.07,
                          child: new RaisedButton(
                            child: new Icon(Icons.send,
                                color: Colors.black,
                                size: constraints.maxWidth * .07),
                            onPressed: _onSend,
                          )),
                    ]),
                // ),
                //),
                new FittedBox(
                  child: new Container(
                    color: Colors.grey,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.5,
                    margin: EdgeInsets.only(top: 5.0),
                    child: new MyDrawPage(
                      drawJson,
                      _padController,

                      // key: new GlobalObjectKey('MyDrawPage')
                    ),
                    // key: new Key('draw_screen'),
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
                              new Container(
                                  height: constraints.maxHeight * 0.1,
                                  width: constraints.maxWidth * 0.1,
                                  decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                          image: new AssetImage(
                                              'assets/dice_game/color_picker.png')),
                                      color: visibilityWidth
                                          ? Colors.grey[400]
                                          : Colors.grey[800],
                                      shape: BoxShape.circle)),
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
                              new Container(
                                  height: constraints.maxHeight * 0.1,
                                  width: constraints.maxWidth * 0.1,
                                  decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                          image: new AssetImage(
                                              'assets/dice_game/color_brush.png')),
                                      color: visibilityWidth
                                          ? Colors.grey[400]
                                          : Colors.grey[800],
                                      shape: BoxShape.circle)),
                            ],
                          ),
                        )),
                  ],
                ),
                visibilityColor
                    ? new Expanded(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // scrollDirection: Axis.horizontal,
                          children: color_val
                              .map((colorValue) => Center(
                                      child: RawMaterialButton(
                                    onPressed: () => _multiColor(colorValue),
                                    constraints: new BoxConstraints.tightFor(
                                      width: constraints.maxWidth * .05,
                                      height: constraints.maxHeight * .07,
                                    ),
                                    fillColor: new Color(colorValue),
                                    shape: new CircleBorder(
                                      side: new BorderSide(
                                        color: colorValue == selectedColor
                                            ? Color(roundColor)
                                            : const Color(0xFFD5D7DA),
                                        width: 2.0,
                                      ),
                                    ),
                                  )))
                              .toList(growable: false),
                        ),
                      )
                    : new Container(),
                visibilityWidth
                    ? new Expanded(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: width_val
                              .map((widthValue) => Center(
                                    child: new Container(
                                      width: constraints.maxWidth * .05,
                                      height: constraints.maxHeight * .07,
                                      decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                              image: new AssetImage(
                                                  'assets/dice_game/color_brush.png')),
                                          color: Colors.white10,
                                          shape: BoxShape.circle),
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
                    : new Container(),
              ]);
            })
          : new SecondScreen(
              navVal,
              choice,
              drawJson,
              widget.onScore,
              widget.onProgress,
              widget.onEnd,
              widget.iteration,
              widget.gameCategoryId,
              widget.gameConfig,
              widget.isRotated,
            );
    } else {
      print({'landscape mode ....': ""});
      return navVal == 0
          ? new LayoutBuilder(builder: (context, constraints) {
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
                              child: new Text("${choice[1].toUpperCase()}",
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
                                    child: new Icon(Icons.clear,
                                        color: Colors.black,
                                        size: constraints.maxWidth * .05),
                                    onPressed: _onClear,
                                  )),
                              new Container(
                                  width: constraints.maxHeight * 0.25,
                                  height: constraints.maxHeight * 0.1,
                                  child: new RaisedButton(
                                    child: new Icon(Icons.undo,
                                        color: Colors.black,
                                        size: constraints.maxWidth * .05),
                                    onPressed: _onUndo,
                                  )),
                              new Container(
                                  width: constraints.maxHeight * 0.25,
                                  height: constraints.maxHeight * 0.1,
                                  child: new RaisedButton(
                                    child: new Icon(Icons.send,
                                        color: Colors.black,
                                        size: constraints.maxWidth * .05),
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
                          child: new MyDrawPage(drawJson, _padController
                              // key: new GlobalObjectKey('MyDrawPage')
                              ),
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
                                    new Container(
                                        height: constraints.maxHeight * 0.1,
                                        width: constraints.maxWidth * 0.1,
                                        decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                image: new AssetImage(
                                                    'assets/dice_game/color_picker.png')),
                                            color: visibilityWidth
                                                ? Colors.grey[400]
                                                : Colors.grey[800],
                                            shape: BoxShape.circle)),
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
                                    new Container(
                                        height: constraints.maxHeight * 0.1,
                                        width: constraints.maxWidth * 0.1,
                                        decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                image: new AssetImage(
                                                    'assets/dice_game/color_brush.png')),
                                            color: visibilityWidth
                                                ? Colors.grey[400]
                                                : Colors.grey[800],
                                            shape: BoxShape.circle)),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      visibilityColor
                          ? new Expanded(
                              // flex: 1,
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // scrollDirection: Axis.horizontal,
                                children: color_val
                                    .map((colorValue) => Center(
                                            child: RawMaterialButton(
                                          onPressed: () =>
                                              _multiColor(colorValue),
                                          constraints:
                                              new BoxConstraints.tightFor(
                                            width: constraints.maxWidth * .04,
                                            height: constraints.maxHeight * .05,
                                          ),
                                          fillColor: new Color(colorValue),
                                          shape: new CircleBorder(
                                            side: new BorderSide(
                                              color: colorValue == selectedColor
                                                  ? Color(roundColor)
                                                  : const Color(0xFFD5D7DA),
                                              width: 2.0,
                                            ),
                                          ),
                                        )))
                                    .toList(growable: false),
                              ),
                            )
                          : Container(),
                      visibilityWidth
                          ? new Expanded(
                              // flex: 1,
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: width_val
                                    .map((widthValue) => Center(
                                          child: new Container(
                                            width: constraints.maxWidth * .04,
                                            height: constraints.maxHeight * .05,
                                            decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                    image: new AssetImage(
                                                        'assets/dice_game/color_brush.png')),
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
            })
          : new SecondScreen(
              navVal,
              choice,
              drawJson,
              widget.onScore,
              widget.onProgress,
              widget.onEnd,
              widget.iteration,
              widget.gameCategoryId,
              widget.gameConfig,
              widget.isRotated,
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
    var jsonData = _padController.send();
    print({"json data is : ": jsonData});
    drawJson = jsonData;
    // setState(() {
    //   widget.onEnd(toJsonMap(), false);
    // });

    setState(() {
      navVal = 1;
    });
  }

  void _multiColor(colorValue) {
    _padController.multiColor(colorValue);
    // _changed(false, "colr");
    setState(() {
      selectedColor = colorValue;
    });
    print({"this is _multiColor methode": colorValue});
  }

  void _multiWidth(widthValue) {
    _padController.multiWidth(widthValue);
    // _changed(false, "widt");
    print({"this is _multiWidth methode": widthValue});
  }
}
