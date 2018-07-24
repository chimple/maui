import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/gameaudio.dart';

class ClueGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  bool isRotated;
  int iteration;
  int gameCategoryId;
  ClueGame(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  _ClueGameState createState() => new _ClueGameState();
}

class _ClueGameState extends State<ClueGame> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation, noanimation;
  int _flag = 0;
  void toAnimateFunction() {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  var keys = 0;
  String _result = '';
  String word = '';
  int count = 0;
  Key key;
  int flag;
  List<String> _categoryup = [];
  List<String> _categorydown = [];
  List<String> categoryName = [];
  List<String> listOfThings = [];
  List<String> listOfThingscopy = [];
  List<String> listOfSyllables = [];
  List<String> listOfSyllablescopy = [];
  List<String> dummylist = [
    'eq',
    'ag',
    'fg',
    'cv',
    'bn',
    'mk',
    'lk',
    'asd',
    'po',
    'qw',
    'tyu',
    'uy',
    'cb',
    'ni',
    'oiu',
    'kjh',
    'ko',
    'za',
    'aq'
  ];
  bool _isLoading = true;
  Map<String, List<String>> data1;
  Map<String, Map<String, List<String>>> data;
  void _initClueGame() async {
    listOfSyllables.clear();
    listOfThings.clear();
    categoryName.clear();
    listOfThingscopy.clear();
    setState(() => _isLoading = true);
    data = await fetchClueGame(widget.gameCategoryId);
    data.forEach((k, data1) {
      categoryName.add(k);
      data1.forEach((a, list) {
        listOfThings.add(a);
        list.forEach((c) {
          listOfSyllables.add(c);
        });
      });
    });
    reset(word);
    flag = 0;
    listOfThingscopy.addAll(listOfThings);
    _categoryup = categoryName.sublist(0, 2);
    _categorydown = categoryName.sublist(2, 4);
    setState(() => _isLoading = false);
  }

  void reset(String name) {
    flag = 0;
    listOfSyllables.clear();
    listOfThings.clear();
    data.forEach((k, data1) {
      categoryName.add(k);
      data1.remove(name);
      data1.forEach((a, list) {
        listOfThings.add(a);
        listOfThings.remove(name);
        list.forEach((c) {
          listOfSyllables.add(c);
        });
      });
    });
    listOfSyllables.addAll(dummylist);
    listOfSyllablescopy = listOfSyllables.sublist(0, 19);
    listOfSyllablescopy.shuffle();
  }

  void _validate() {
    String word = _result;
    if (word == '') {
    } else if (listOfThingscopy.sublist(0, 3).contains(_result)) {
      setState(() {
        _result = 'you Type Drink';
        count++;
        flag = 1;
        widget.onScore(4);
        widget.onProgress(count / 12);
        if (count == 12) {
          new Future.delayed(const Duration(seconds: 2), () {
            widget.onEnd();
          });
        }
        GlobalKey key = new GlobalObjectKey(categoryName[0]);
        if (key.currentState != null) {
          (key.currentState as _BuildCategoryState).showImage(word);
        }
      });
      new Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _flag = 0;
          _result = '';
          reset(word);
        });
        controller.stop();
      });
    } else if (listOfThingscopy.sublist(3, 6).contains(_result)) {
      setState(() {
        _result = 'you Type Travel';
        count++;
        flag = 1;
        widget.onScore(4);
        widget.onProgress(count / 12);
        if (count == 12) {
          new Future.delayed(const Duration(seconds: 2), () {
            widget.onEnd();
          });
        }
        GlobalKey key = new GlobalObjectKey(categoryName[1]);
        if (key.currentState != null) {
          (key.currentState as _BuildCategoryState).showImage(word);
        }
      });
      new Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _flag = 0;
          _result = '';
          reset(word);
        });
        controller.stop();
      });
    } else if (listOfThingscopy.sublist(6, 9).contains(_result)) {
      setState(() {
        _result = 'you Type Red Fruit';
        count++;
        flag = 1;
        widget.onScore(4);
        widget.onProgress(count / 12);
        if (count == 12) {
          new Future.delayed(const Duration(seconds: 2), () {
            widget.onEnd();
          });
        }
        GlobalKey key = new GlobalObjectKey(categoryName[2]);
        if (key.currentState != null) {
          (key.currentState as _BuildCategoryState).showImage(word);
        }
      });
      new Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _flag = 0;
          _result = '';
          reset(word);
        });
        controller.stop();
      });
    } else if (listOfThingscopy.sublist(9, 12).contains(_result)) {
      setState(() {
        _result = 'you Type black Pet';
        count++;
        flag = 1;
        widget.onScore(4);
        widget.onProgress(count / 12);
        if (count == 12) {
          new Future.delayed(const Duration(seconds: 2), () {
            widget.onEnd();
          });
        }
        GlobalKey key = new GlobalObjectKey(categoryName[3]);
        if (key.currentState != null) {
          (key.currentState as _BuildCategoryState).showImage(word);
        }
      });
      new Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _flag = 0;
          _result = '';
          reset(word);
        });
        controller.stop();
      });
    } else {
      setState(() {
        flag = 1;
      });
      toAnimateFunction();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _flag = 0;
          _result = '';
          widget.onScore(-1);
        });
        controller.stop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: -4.0, end: 4.0).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(controller);
    this._initClueGame();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _builtCategory(int index, String text) {
    return new BuildCategory(
      key: new GlobalObjectKey(text),
      unitMode: UnitMode.text,
      text: text,
      keys: keys++,
    );
  }

  int len;
  Widget answer(String output) {
    void remove() {
      setState(() {
        if (_result.length > 0)
          _result = _result.substring(0, _result.length - lengthofwords.last);
        lengthofwords.removeLast();
      });
    }

    MediaQueryData media = MediaQuery.of(context);
    double _height = media.size.height;
    double _width = media.size.width;
    return new GestureDetector(
      onTap: remove,
      child: new Container(
        height: media.orientation == Orientation.portrait
            ? _height * 0.06
            : _height * 0.09,
        width: media.orientation == Orientation.portrait
            ? _width * 0.5
            : _width * 0.32,
        alignment: Alignment.bottomRight,
        decoration: new BoxDecoration(
          color: new Color(0xffff77DB65),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
        ),
        child: new Center(
            child: new Text(_result,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                ))),
      ),
    );
  }

  Widget submit() {
    MediaQueryData media = MediaQuery.of(context);
    double _height = media.size.height;
    double _width = media.size.width;
    return new Container(
        height: media.orientation == Orientation.portrait
            ? _height * 0.06
            : _height * 0.08,
        width: media.orientation == Orientation.portrait
            ? _width * 0.15
            : _width * 0.1,
        child: new RaisedButton(
          onPressed: () => flag == 0 ? _validate() : null,
          shape: new RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
          child: new Text(
            '✔',
            style: new TextStyle(
              color: Colors.black,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.left,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    keys = 0;
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = 0.0, maxHeight = 0.0;
      final maxChars = (categoryName != null
          ? categoryName.fold(1,
              (prev, element) => element.length > prev ? element.length : prev)
          : 1);
      maxWidth = (constraints.maxWidth - hPadding * 2) / 3.7;
      maxHeight = (constraints.maxHeight - vPadding * 2) / 3.7;
      double buttonPadding = sqrt(min(maxWidth, maxHeight));
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      var k = 0;
      if (maxHeight + maxHeight * 0.1 > maxWidth) {
        return new Flex(direction: Axis.vertical, children: <Widget>[
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new ResponsiveGridView(
                  rows: 2,
                  cols: 1,
                  maxAspectRatio: 1.0,
                  children: _categorydown
                      .map((e) => new Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _builtCategory(k++, e),
                          ))
                      .toList(growable: false),
                ),
                new ResponsiveGridView(
                  rows: 2,
                  cols: 1,
                  maxAspectRatio: 1.0,
                  children: _categoryup
                      .map((e) => new Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _builtCategory(k++, e),
                          ))
                      .toList(growable: false),
                ),
              ],
            ),
          ),
          new Expanded(
            flex: 1,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Shake(
                  animation: (_flag == 0) ? animation : noanimation,
                  child: answer(_result),
                ),
                submit(),
              ],
            ),
          ),
          new Expanded(
            flex: 5,
            child: buildCircle(
                context, listOfSyllablescopy, j, maxWidth, maxHeight),
          ),
        ]);
      } else {
        //landscape mode
        return new Flex(direction: Axis.horizontal, children: <Widget>[
          new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new ResponsiveGridView(
                  rows: 1,
                  cols: 2,
                  maxAspectRatio: 1.0,
                  children: _categorydown
                      .map((e) => new Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _builtCategory(k++, e),
                          ))
                      .toList(growable: false),
                ),
                new ResponsiveGridView(
                  rows: 1,
                  cols: 2,
                  maxAspectRatio: 1.0,
                  children: _categoryup
                      .map((e) => new Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _builtCategory(k++, e),
                          ))
                      .toList(growable: false),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Shake(
                      animation: (_flag == 0) ? animation : noanimation,
                      child: answer(_result),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: submit(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: buildCircle(
                context, listOfSyllablescopy, j, maxWidth, maxHeight),
          ),
        ]);
      }
    });
  }

  Widget buildCircle(BuildContext context, List<String> syllables, int index,
      double maxW, double maxH) {
    return new Circle(
        listOfSyllablescopy: syllables,
        maxwidth: maxW,
        maxheight: maxH,
        onPress: setData);
  }

  List<int> lengthofwords = [];
  void setData(String a) {
    setState(() {
      len = a.length;
      lengthofwords.add(len);
      _result = _result + a;
    });
  }

  int j = 0;
}

typedef void VoidCallback(String text);

class Circle extends StatefulWidget {
  List<String> listOfSyllablescopy;
  String text;
  double maxwidth;
  double maxheight;
  Circle(
      {Key key,
      this.text,
      this.listOfSyllablescopy,
      this.onPress,
      this.maxheight,
      this.maxwidth})
      : super();
  VoidCallback onPress;
  @override
  _CircleState createState() => new _CircleState();
}

class _CircleState extends State<Circle> {
  String _text = '';
  void initState() {
    super.initState();
    setState(() {
      _text = widget.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    double ht = widget.maxheight;
    double wd = widget.maxwidth;
    double circleSize = ht + wd;
    double bigRadius = circleSize / 2;
    double smallRadius = (bigRadius) * 0.15;
    List<Widget> widgets = new List();
    widgets.add(new Container(
        width: circleSize,
        height: circleSize,
        decoration: new BoxDecoration(
            color: new Color(0xffff77DB65), shape: BoxShape.circle)));

    Offset circleCenter = new Offset(bigRadius, bigRadius);
    List<Offset> offsets;
    int syllableIndex = 0;
    offsets = calculateOffsets(bigRadius * 0.8, circleCenter, 12);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i],
          widget.listOfSyllablescopy[syllableIndex++],
          Colors.orange[300],
          smallRadius,
          widget.onPress));
    }
    offsets = calculateOffsets(bigRadius * 0.4, circleCenter, 6);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i],
          widget.listOfSyllablescopy[syllableIndex++],
          Colors.orange[300],
          smallRadius,
          widget.onPress));
    }

    offsets = calculateOffsets(bigRadius * 0.0, circleCenter, 1);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i],
          widget.listOfSyllablescopy[syllableIndex++],
          Colors.orange[300],
          smallRadius,
          widget.onPress));
    }

    return new Center(child: new Stack(children: widgets));
  }

  List<Offset> calculateOffsets(
      double circleRadii, Offset circleCenter, int amount) {
    double angle = 2 * pi / amount;
    double alpha = 300.0;
    double x0 = circleCenter.dx;
    double y0 = circleCenter.dy;
    List<Offset> offsets = new List(amount);
    for (int i = 0; i < amount; i++) {
      double x = x0 + circleRadii * cos(alpha);
      double y = y0 + circleRadii * sin(alpha);
      offsets[i] = new Offset(x, y);
      alpha += angle;
    }
    return offsets;
  }
}

class PositionCircle extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;
  final double radii;
  final VoidCallback onPress;

  PositionCircle(
      this.initPos, this.label, this.itemColor, this.radii, this.onPress);
  @override
  _PositionCircleState createState() => new _PositionCircleState();
}

class _PositionCircleState extends State<PositionCircle> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx - widget.radii,
      top: position.dy - widget.radii,
      width: widget.radii * 2,
      height: widget.radii * 2,
      child: new RawMaterialButton(
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () => widget.onPress(widget.label),
        fillColor: widget.itemColor,
        splashColor: Colors.green[900],
        child: new Text(
          widget.label,
          style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class BuildCategory extends StatefulWidget {
  BuildCategory({Key key, this.keys, this.text, this.unitMode})
      : super(key: key);
  String text;
  int keys;
  UnitMode unitMode;
  @override
  _BuildCategoryState createState() => new _BuildCategoryState(unitMode, text);
}

class _BuildCategoryState extends State<BuildCategory> {
  UnitMode unitMode;
  String text;
  _BuildCategoryState(this.unitMode, this.text);

  void showImage(String imageName) {
    String oldText = widget.text;
    setState(() {
      this.unitMode = UnitMode.image;
      this.text = imageName;
    });
    new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        this.unitMode = UnitMode.text;
        this.text = oldText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    if (unitMode == UnitMode.image) {
      return new UnitButton(
        unitMode: this.unitMode,
        text: this.text,
        showHelp: false,
        bgImage: this.text,
        forceUnitMode: true,
        key: new Key("A${widget.keys}"),
      );
    }
    return new UnitButton(
      unitMode: this.unitMode,
      text: this.text,
      forceUnitMode: true,
      showHelp: false,
      key: new Key("A${widget.keys}"),
    );
  }
}
