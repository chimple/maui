import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/repos/game_data.dart';

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

  List<String> _category;
  List<String> _categoryup;
  List<String> _categorydown;
  List<String> _holdwords;
  List<String> _redfruit;
  List<String> _travel;
  List<String> _drink;
  List<String> _blackpet;
  List<String> categoryName = [];
  List<String> listOfThings = [];
  List<String> listOfSyllables =[];
   bool _isLoading = true;
  Map<String, List<String>> data1;
  Map<String, Map<String, List<String>>> data;
  

  void _initClueGame() async{
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
     print('categoryName is $categoryName');
    print('listOfThings is $listOfThings');
    print('listOfSyllables is $listOfSyllables');
    setState(() => _isLoading = false);
  }

  var keys = 0;
  String _result = '';
  String word = '';

  void _validate() {
    // setState(()  {
    if (_result == _redfruit[0] ||
        (_result == _redfruit[1]) ||
        (_result == _redfruit[2]) ||
        (_result == _redfruit[3])) {
      setState(() {
        _result = 'you Type Red Fruit';
      });

      new Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          _flag = 0;
          _result = '';
        });

        controller.stop();
      });
    } else if (_result == _travel[0] ||
        (_result == _travel[1]) ||
        (_result == _travel[2]) ||
        (_result == _travel[3])) {
      _result = 'you Type Travel';
      new Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _flag = 0;
          _result = '';
        });
        controller.stop();
      });
    } else if (_result == _drink[0] ||
        (_result == _drink[1]) ||
        (_result == _drink[2]) ||
        (_result == _drink[3])) {
      _result = 'you Type Drink';
      new Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _flag = 0;
          _result = '';
        });
        controller.stop();
      });
    } else if (_result == _blackpet[0] ||
        (_result == _blackpet[1]) ||
        (_result == _blackpet[2]) ||
        (_result == _blackpet[3])) {
      _result = 'you Type black Pet';
      new Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _flag = 0;
          _result = '';
        });
        controller.stop();
      });
    } else {
      toAnimateFunction();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _flag = 0;
          _result = '';
        });
        controller.stop();
      });
    }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
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
      key: new ValueKey<int>(index),
      text: text,
      keys: keys++,
    );
  }

  Widget answer(String output) {
    void remove() {
      setState(() {
        if (_result.length > 0)
          _result = _result.substring(0, _result.length - 1);
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
            : _width * 0.25,
        alignment: Alignment.bottomRight,
        decoration: new BoxDecoration(
          border: new Border.all(width: 1.0),
          color: Colors.blue[200],
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
        ),
        child: new Center(
            child: new Text(_result,
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
          onPressed: () => _validate(),
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
  //  Orientation orientation = MediaQuery.of(context).orientation;
    keys = 0;
   // if (orientation == Orientation.portrait) {
      return new LayoutBuilder(builder: (context, constraints) {
        final hPadding = pow(constraints.maxWidth / 150.0, 2);
        final vPadding = pow(constraints.maxHeight / 150.0, 2);
        double maxWidth = 0.0, maxHeight = 0.0;
        final maxChars = (_category != null
            ? _category.fold(
                1,
                (prev, element) =>
                    element.length > prev ? element.length : prev)
            : 1);

        maxWidth = (constraints.maxWidth - hPadding * 2) / 3.7;
        maxHeight = (constraints.maxHeight - vPadding * 2) / 3.7;
        double buttonPadding = sqrt(min(maxWidth, maxHeight));
        UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
        AppState state = AppStateContainer.of(context).state;
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
            child: new ResponsiveGridView(
              rows: 1,
              cols: 1,
              children: _words
                  .map((e) =>buildCircle(context, e, j,maxWidth,maxHeight))
                  .toList(growable: false),
            ),
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
                new Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Shake(
                        animation: (_flag == 0) ? animation : noanimation,
                        child: answer(_result),
                      ),
                      submit(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: new ResponsiveGridView(
              rows: 1,
              cols: 1,
              children: _words
                  .map((e) => buildCircle(context, e, j,maxWidth,maxHeight))
                  .toList(growable: false),
            ),
          ),
        ]);
    }
      });
    }
  

  //int j = 0;
  Widget buildCircle(BuildContext context, String text, int index, double maxW,double maxH) {
    return new Circle(
        text: text,
         maxwidth:maxW,
        maxheight:maxH,
      //  key: new ValueKey<int>(index),
        onPress: () {
          setData(text);
          print("asdd");
        });
  }

  void setData(String a) {
    print("call here comming");
    setState(() {
      _result = _result + a;
    });
  }

  List _words = [
      'ea','ar', 'pa', 'nd','aw', 'co', 'wa','pl', 'bu', 'sa', 'ra', 'ap', 'ch','st', 'wa', 're', 'to','ot', 'do',  ];
    int wordsIndex = 0;
  int j = 0;
}

class Circle extends StatefulWidget {
  String text;
  double maxwidth;
  double maxheight;
  Circle({Key key, this.text, this.onPress,this.maxheight,this.maxwidth}) : super();
  VoidCallback onPress;
  @override
  _CircleState createState() => new _CircleState();
}

class _CircleState extends State<Circle> {
  String _text = '';
  int wordsIndex = 0;
  void initState() {
    super.initState();
    setState(() {
      _text = widget.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    // double circleSize = orientation == Orientation.portrait
    //     ? MediaQuery.of(context).size.width * 0.7
    //     : MediaQuery.of(context).size.height * 0.7;
    double ht =widget.maxheight;
    double wd = widget.maxwidth;
    double circleSize = ht+wd;   
    double bigRadius = circleSize / 2;
    double smallRadius = (bigRadius) * 0.15;
    MediaQueryData media = MediaQuery.of(context);
    // List _words = [
    //   'ea','ar', 'pa', 'nd','aw', 'co', 'wa','pl', 'bu', 'sa', 'ra', 'ap', 'ch','st', 'wa', 're', 'to','ot', 'do',  ];
    // int wordsIndex = 0;
    List<Widget> widgets = new List();
    widgets.add(new Container(
        width: circleSize,
        height: circleSize,
        decoration:
            new BoxDecoration(color: Colors.green, shape: BoxShape.circle)));

    Offset circleCenter = new Offset(bigRadius, bigRadius);

    List<Offset> offsets;
    offsets = calculateOffsets(bigRadius * 0.8, circleCenter, 12);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i], _text, Colors.orange[300], smallRadius, widget.onPress));
    }
    offsets = calculateOffsets(bigRadius * 0.4, circleCenter, 6);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i], _text, Colors.orange[300], smallRadius, widget.onPress));
    }

    offsets = calculateOffsets(bigRadius * 0.0, circleCenter, 1);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i], _text, Colors.orange[300], smallRadius, widget.onPress));
    }

    return new Center(child: new Stack(children: widgets));
  }

  //it calculates points on circle
  //these points are centers for small circles
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
        onPressed: () => widget.onPress(),
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
  BuildCategory({Key key, this.keys, this.text}) : super(key: key);
  final String text;
  int keys;
  @override
  _BuildCategoryState createState() => new _BuildCategoryState();
}

class _BuildCategoryState extends State<BuildCategory> {
  @override
  Widget build(BuildContext context) {
    widget.keys++;
    return new UnitButton(
      text: widget.text,
      disabled: true,
      key: new Key("A${widget.keys}"),
    );
  }
}
