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

class _ClueGameState extends State<ClueGame> {
  List<String> _words = [
    'bu',
    'wa',
    'pl',
    'io',
    't',
    'ap',
    't',
    's',
    'tz',
    'e',
    'no',
    'is',
    'tm',
    'er',
    'kl',
    'hk',
    'ko',
    'ca',
    'ko',
    'aw'
  ];
  List<String> _category = ['Red Fruit', 'Travel', 'Drink', 'Black Pet'];
  var keys = 0;
  Widget _builtWord(int index, String text, double _height) {
    return new MyButton(
      key: new ValueKey<int>(index),
      text: text,
      keys: keys++,
      height: _height,
      onPress: () {
        text = text + '1';
      },
    );
  }

  Widget _builtCategory(int index, String text, double _height) {
    return new BuildCategory(
      key: new ValueKey<int>(index),
      text: text,
      keys: keys++,
      height: _height,
    );
  }

  Widget answer(
    String output,
  ) {
    MediaQueryData media = MediaQuery.of(context);
    double _height = media.size.height;
    double _width = media.size.width;
    return new Container(
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
      //  alignment: Alignment.topLeft,
      child: new Center(
          child: new Text(output,
              style: new TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ))),
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
            ? _width * 0.24
            : _width * 0.13,
        //margin: new EdgeInsets.all(1.0),
        child: new RaisedButton(
          onPressed: null,
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
    keys=0;
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
                answer('output'),
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
  MyButton({Key key, this.text,this.keys, this.height, this.onPress}) : super(key: key);

  final String text;
  final double height;
  int keys;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();

    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
//        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    return new TableCell(
      child: new Padding(
        padding: new EdgeInsets.all(widget.height * 0.001),
        child: new ScaleTransition(
          scale: animation,
          child: new RaisedButton(
            onPressed: () => widget.onPress(),
            padding: new EdgeInsets.all(widget.height * 0.02),
            splashColor: Colors.green,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0))),
            child: new Text(
              _displayText,
              key: new Key("A${widget.keys}"),
              style: new TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildCategory extends StatefulWidget {
  BuildCategory({Key key, this.height,this.keys, this.text}) : super(key: key);
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
