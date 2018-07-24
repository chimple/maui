import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:tuple/tuple.dart';
import '../components/drawing.dart';
import 'package:maui/repos/game_data.dart';
import '../components/SecondScreen.dart';
import 'dart:math';
import 'package:maui/components/flash_card.dart';

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
  bool visibilityColor = true;
  bool visibilityWidth = false;
  bool _isLoading = true;
  int navVal = 0;
  List<String> choice = [];
  Tuple3<String, String, List<String>> drawingData;
  //  int _size = 2;
  String questionImg;
  String ans;
  List<String> ch;
  var ansimage;
  int selectedColor = 0xff000000;
  double selectedWidth = 2.0;
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
    // navVal=0;
    setState(() => _isLoading = true);
    
    print('score data manuuuuuuuuuu : ${widget.gameConfig.gameData}');
    if (widget.gameConfig.gameData != null) {
      fromJsonMap(widget.gameConfig.gameData);
    } else {
      DrawData = [drawJson];
      ReceiveData = [];
    }
    choice = [];
    drawingData =
        await fetchMultipleChoiceData(widget.gameConfig.gameCategoryId, 3);
    questionImg = drawingData.item1;
    ans = drawingData.item2;
    ch = drawingData.item3;
    for (var x = 0; x < ch.length; x++) {
      choice.add(ch[x]);
    }
    choice.add(ans);
    print("My Choices - $choice");

    choice.shuffle();
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Drawing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      print(
          "both the iterartin is old...${oldWidget.iteration}.........new ${widget.iteration}");
      if (navVal == 0) {
        navVal = widget.iteration;
      } else {
        navVal = 0;
        _initBoard();
      }
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
    // var assetsImage = new AssetImage('assets/dict/${questionImg}.png');
    List<int> color_val = [
      0xff76ff03,
      0xffffff00,
      0xffd50000,
      0xffe65100,
      0xff00bcd4,
      0xffd500f9,
      0xff1b5e20,
      0xff000000,
      0xffc62828
    ];
    int roundColor;
    final maxChars = (choice != null
        ? choice.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);

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
              final hPadding = pow(constraints.maxWidth / 150.0, 2);
              final vPadding = pow(constraints.maxHeight / 150.0, 2);
              double maxWidth = (constraints.maxWidth - hPadding * 2) / 2;
              double maxHeight =
                  (constraints.maxHeight - vPadding * 2) / (2 + 1);
              final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
              maxWidth -= buttonPadding * 2;
              maxHeight -= buttonPadding * 2;
              UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
              final buttonConfig =
                  ButtonStateContainer.of(context).buttonConfig;
              print({"this is constraints": "potrait"});
              print("unit image issss: ${questionImg}");

              print("the data of image is....");
              return new Flex(direction: Axis.vertical, children: <Widget>[
                new LimitedBox(
                //   maxHeight: maxHeight,
                // maxWidth: maxWidth,
                  child: new Container(
                      padding: EdgeInsets.all(2.0),
                      child: Center(
                        child: UnitButton(
                          maxWidth: constraints.maxWidth * 0.5,
                          maxHeight: constraints.maxHeight * 0.2,
                          text: '${questionImg}',
                          primary: true,
                          // bgImage: '${questionImg}',
                          unitMode: UnitMode.image,
                        ),
                      )),
                ),
                new FittedBox(
                  child: new Container(
                      // width: constraints.maxWidth,
                      // height: constraints.maxHeight * 0.08,
                      child: new Text('${questionImg}',
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
                      new InkWell(
                        onTap: _onClear,
                        child: new Container(
                            child: Image(
                                height: constraints.maxWidth * .08,
                                width: constraints.maxWidth * .08,
                                image: new AssetImage(
                                    'assets/dice_game/clear.png'))),
                      ),
                      new InkWell(
                          onTap: _onUndo,
                          child: new Container(
                              child: Image(
                                  height: constraints.maxWidth * .08,
                                  width: constraints.maxWidth * .08,
                                  image: new AssetImage(
                                      'assets/dice_game/undo.png')))),
                      new InkWell(
                        onTap: _onSend,
                        child: new Container(
                            child: Image(
                                height: constraints.maxWidth * .08,
                                width: constraints.maxWidth * .08,
                                image: new AssetImage(
                                    'assets/dice_game/send.png'))),
                      ),
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
                                              'assets/dice_game/paint.png')),
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
                                              'assets/dice_game/brush.png')),
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
                          // scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () => _multiWidth(2.0),
                              constraints: new BoxConstraints.tightFor(
                                width: constraints.maxWidth * .03,
                                height: constraints.maxHeight * .07,
                              ),
                              fillColor: new Color(0xf0000000),
                              shape: new CircleBorder(
                                side: new BorderSide(
                                  color: 2.0 == selectedWidth
                                      ? Color(0xff76ff03)
                                      : const Color(0xFFD5D7DA),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () => _multiWidth(4.0),
                              constraints: new BoxConstraints.tightFor(
                                width: constraints.maxWidth * .04,
                                height: constraints.maxHeight * .07,
                              ),
                              fillColor: new Color(0xf0000000),
                              shape: new CircleBorder(
                                side: new BorderSide(
                                  color: 4.0 == selectedWidth
                                      ? Color(0xff76ff03)
                                      : const Color(0xFFD5D7DA),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () => _multiWidth(6.0),
                              constraints: new BoxConstraints.tightFor(
                                width: constraints.maxWidth * .048,
                                height: constraints.maxHeight * .07,
                              ),
                              fillColor: new Color(0xf0000000),
                              shape: new CircleBorder(
                                side: new BorderSide(
                                  color: 6.0 == selectedWidth
                                      ? Color(0xff76ff03)
                                      : const Color(0xFFD5D7DA),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () => _multiWidth(8.0),
                              constraints: new BoxConstraints.tightFor(
                                width: constraints.maxWidth * .055,
                                height: constraints.maxHeight * .07,
                              ),
                              fillColor: new Color(0xf0000000),
                              shape: new CircleBorder(
                                side: new BorderSide(
                                  color: 8.0 == selectedWidth
                                      ? Color(0xff76ff03)
                                      : const Color(0xFFD5D7DA),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
              ]);
            })
          : new SecondScreen(
              ans,
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
              final hPadding = pow(constraints.maxWidth / 150.0, 2);
              final vPadding = pow(constraints.maxHeight / 150.0, 2);

              double maxWidth = (constraints.maxWidth - hPadding * 2) / 2;
              double maxHeight =
                  (constraints.maxHeight - vPadding * 2) / (2 + 1);

              final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

              maxWidth -= buttonPadding * 2;
              maxHeight -= buttonPadding * 2;
              UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
              final buttonConfig =
                  ButtonStateContainer.of(context).buttonConfig;

              return new Flex(direction: Axis.horizontal, children: <Widget>[
                new Expanded(
                    flex: 2,
                    child: new Column(children: <Widget>[
                      new LimitedBox(
                        // flex: 2,
                        child: new Container(
                          padding: EdgeInsets.only(top: 3.0,left: 3.0),
                            child: UnitButton(
                              text: '$questionImg',
                              primary: true,
                              unitMode: UnitMode.image,
                            )
                            ),
                      ),
                      new FittedBox(
                          child: new Container(
                              width: constraints.maxWidth * 0.3,
                              height: constraints.maxHeight * 0.1,
                              child: new Text("${questionImg}",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontSize: constraints.maxHeight * 0.1,
                                      fontWeight: FontWeight.bold)))),
                      new Expanded(
                        flex: 2,
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new InkWell(
                                onTap: _onClear,
                                child: new Container(
                                    child: Image(
                                        width: constraints.maxHeight * 0.1,
                                        height: constraints.maxHeight * 0.1,
                                        image: new AssetImage(
                                            'assets/dice_game/clear.png'))),
                              ),
                              new InkWell(
                                onTap: _onUndo,
                                child: new Container(
                                    child: Image(
                                        width: constraints.maxHeight * 0.1,
                                        height: constraints.maxHeight * 0.1,
                                        image: new AssetImage(
                                            'assets/dice_game/undo.png'))),
                              ),
                              new InkWell(
                                onTap: _onSend,
                                child: new Container(
                                    child: Image(
                                        width: constraints.maxHeight * 0.1,
                                        height: constraints.maxHeight * 0.1,
                                        image: new AssetImage(
                                            'assets/dice_game/send.png'))),
                              ),
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
                                // margin: new EdgeInsets.only(top: 8.0),
                                child: new Column(
                                  children: <Widget>[
                                    new Container(
                                        height: constraints.maxHeight * 0.1,
                                        width: constraints.maxWidth * 0.1,
                                        decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                image: new AssetImage(
                                                    'assets/dice_game/paint.png')),
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
                                margin: new EdgeInsets.only(top: 5.0),
                                child: new Column(
                                  children: <Widget>[
                                    new Container(
                                        height: constraints.maxHeight * 0.1,
                                        width: constraints.maxWidth * 0.1,
                                        decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                image: new AssetImage(
                                                    'assets/dice_game/brush.png')),
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
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  RawMaterialButton(
                                    onPressed: () => _multiWidth(2.0),
                                    constraints: new BoxConstraints.tightFor(
                                      width: constraints.maxWidth * .04,
                                      height: constraints.maxHeight * .035,
                                    ),
                                    fillColor: new Color(0xf0000000),
                                    shape: new CircleBorder(
                                      side: new BorderSide(
                                        color: 2.0 == selectedWidth
                                            ? Color(0xff76ff03)
                                            : const Color(0xFFD5D7DA),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () => _multiWidth(4.0),
                                    constraints: new BoxConstraints.tightFor(
                                      width: constraints.maxWidth * .04,
                                      height: constraints.maxHeight * .04,
                                    ),
                                    fillColor: new Color(0xf0000000),
                                    shape: new CircleBorder(
                                      side: new BorderSide(
                                        color: 4.0 == selectedWidth
                                            ? Color(0xff76ff03)
                                            : const Color(0xFFD5D7DA),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () => _multiWidth(6.0),
                                    constraints: new BoxConstraints.tightFor(
                                      width: constraints.maxWidth * .04,
                                      height: constraints.maxHeight * .045,
                                    ),
                                    fillColor: new Color(0xf0000000),
                                    shape: new CircleBorder(
                                      side: new BorderSide(
                                        color: 6.0 == selectedWidth
                                            ? Color(0xff76ff03)
                                            : const Color(0xFFD5D7DA),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () => _multiWidth(8.0),
                                    constraints: new BoxConstraints.tightFor(
                                      width: constraints.maxWidth * .04,
                                      height: constraints.maxHeight * .05,
                                    ),
                                    fillColor: new Color(0xf0000000),
                                    shape: new CircleBorder(
                                      side: new BorderSide(
                                        color: 8.0 == selectedWidth
                                            ? Color(0xff76ff03)
                                            : const Color(0xFFD5D7DA),
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ]))
              ]);
            })
          : new SecondScreen(
              ans,
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
    if (jsonData != null) {
      setState(() {
        widget.onEnd(toJsonMap(), false);
        widget.onScore(10);
        widget.onProgress(1.0);
      });
    }
    // setState(() {
    //   navVal = 1;
    // });
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
    setState(() {
      selectedWidth = widthValue;
    });
    // _changed(false, "widt");
    print({"this is _multiWidth methode": widthValue});
  }
}
