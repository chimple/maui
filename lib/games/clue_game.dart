import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'dart:math';
import 'dart:async';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

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
  List<String> _words;
  List<String> _holdwords;
  List<String> _redfruit;
  List<String> _travel;
  List<String> _drink;
  List<String> _blackpet;

  void _initClueGame() {
    _words = [
      'e',
      'ery',
      'pa',
      'nd',
      'a',
      'co',
      'w',
      'pl',
      'bu',
      's',
      'r',
      'e',
      'ch',
      'sta',
      'war',
      'rey',
      'tom',
      'oto',
      'do',
      'g',
      'ca',
      'ne',
      'er',
      'wi',
      'be',
      'ter',
      'wa',
      'lk',
      'mi',
    ];
    _holdwords = _words;
    _category = ['Red Fruit', 'Travel', 'Drink', 'Black Pet'];
    _redfruit = ['apple', 'cheery', 'stawarrey', 'tomoto'];
    _travel = ['bus', 'car', 'train', 'aeroplane'];
    _drink = ['milk', 'water', 'beer', 'wine'];
    _blackpet = ['cat', 'dog', 'panda', 'cow'];
    _words.shuffle();
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
            ? _height * 0.07
            : _height * 0.1,
        width: media.orientation == Orientation.portrait
            ? _width * 0.6
            : _width * 0.32,
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
            ? _height * 0.07
            : _height * 0.1,
        width: media.orientation == Orientation.portrait
            ? _width * 0.25
            : _width * 0.14,
        child: new RaisedButton(
          onPressed: () => _validate(),
          shape: new RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
          child: new Text(
            'submit',
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
      final maxChars = (_category != null
          ? _category.fold(1,
              (prev, element) => element.length > prev ? element.length : prev)
          : 1);

      maxWidth = (constraints.maxWidth - hPadding * 2) / 2.6;
      maxHeight = (constraints.maxHeight - vPadding * 2) / 2.6;
      double buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      var k = 0;

      return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new ResponsiveGridView(
              rows: 2,
              cols: 2,
              maxAspectRatio: 1.0,
              children: _category
                  .map((e) => new Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: _builtCategory(k++, e),
                      ))
                  .toList(growable: false),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Shake(
                  animation: (_flag == 0) ? animation : noanimation,
                  child: answer(_result),
                ),
                submit(),
              ],
            ),
            new Circle(),
          ]);
    });
  }
}

class Circle extends StatefulWidget {
  @override
  _CircleState createState() => new _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    double circleSize = 260.0;

    List<Widget> widgets = new List();
    widgets.add(new Container(
        width: circleSize,
        height: circleSize,
        decoration:
            new BoxDecoration(color: Colors.green, shape: BoxShape.circle)));

    Offset circleCenter = new Offset(circleSize / 2, circleSize / 2);

    List<Offset> offsets = calculateOffsets(100.0, circleCenter, 12);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i], i.toString(), Colors.orange[300], 23.0));
    }
    offsets = calculateOffsets(50.0, circleCenter, 6);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i], i.toString(), Colors.orange[300], 23.0));
    }

    offsets = calculateOffsets(0.0, circleCenter, 1);
    for (int i = 0; i < offsets.length; i++) {
      widgets.add(new PositionCircle(
          offsets[i], i.toString(), Colors.orange[300], 23.0));
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

  PositionCircle(this.initPos, this.label, this.itemColor, this.radii);
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
        onPressed: () {},
        fillColor: widget.itemColor,
        splashColor: Colors.yellow,
        child: new Text(
          widget.label,
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
