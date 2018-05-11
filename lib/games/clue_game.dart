import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/flash_card.dart';

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
      'ap',
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
  Widget _builtWord(int index, String text, double _height) {
    return new MyButton(
      key: new ValueKey<int>(index),
      text: text,
      keys: keys++,
      height: _height,
      onPress: () {
        setState(() {
          _result = _result + text;
        });
      },
    );
  }

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

  Widget _builtCategory(int index, String text, double _height) {
    return new BuildCategory(
      key: new ValueKey<int>(index),
      text: text,
      keys: keys++,
      height: _height,
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
      double _height, _width;
      _height = constraints.maxHeight;
      _width = constraints.maxWidth;
      List<TableRow> rows = new List<TableRow>();
      List<TableRow> rows1 = new List<TableRow>();
      var j = 0;
      for (var i = 0; i < 4; i++) {
        List<Widget> cells = _words
            .skip(i * 5)
            .take(5)
            .map((e) => _builtWord(j++, e, _height))
            .toList();
        rows.add(new TableRow(children: cells));
      }
      var k = 0;
      for (var i = 0; i < 2; i++) {
        List<Widget> cells = _category
            .skip(i * 2)
            .take(2)
            .map((e) => _builtCategory(k++, e, _height))
            .toList();
        rows1.add(new TableRow(children: cells));
      }
      return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Table(children: rows1),
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
            new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Table(children: rows),
            ),
          ]);
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.keys, this.height, this.onPress})
      : super(key: key);

  final String text;
  final double height;
  int keys;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;

  initState() {
    super.initState();
    setState(() {
      _displayText = widget.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    return new TableCell(
      child: new Padding(
        padding: new EdgeInsets.all(widget.height * 0.001),
        child: new RaisedButton(
          onPressed: () => widget.onPress(),
          padding: new EdgeInsets.all(widget.height * 0.02),
          splashColor: Colors.green,
          shape: new RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
          child: new Text(
            _displayText,
            key: new Key("A${widget.keys}"),
            style: new TextStyle(color: Colors.deepPurple, fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}

class BuildCategory extends StatefulWidget {
  BuildCategory({Key key, this.height, this.keys, this.text}) : super(key: key);
  final String text;
  final double height;
  int keys;
  @override
  _BuildCategoryState createState() => new _BuildCategoryState();
}

class _BuildCategoryState extends State<BuildCategory> {
  @override
  Widget build(BuildContext context) {
    widget.keys++;
    return new Padding(
      padding: new EdgeInsets.all(5.0),
      child: new Container(
        height: widget.height * 0.13,
        width: widget.height * 0.12,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
        ),
        child: new Center(
          child: new Text(
            widget.text,
            key: new Key("A${widget.keys}"),
            style: new TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}
