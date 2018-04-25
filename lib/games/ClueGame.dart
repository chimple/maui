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
  List<String> _words = ['bu','wa','pl','io','t','ap','t','s','tz','e','no','is','tm','er','kl','hk','ko','ca','ko','aw'];
  List<String> _category = ['Red Fruit', 'Travel', 'Drink', 'Black Pet'];

  Widget _builtWord(int index, String text) {
    return new MyButton(
      key: new ValueKey<int>(index),
      text: text,
      onPress: () {
        text = text + '1';
      },
    );
  }

  Widget answer(String output,) {
    return new Padding(
      padding: new EdgeInsets.only(left: 1.0),
      child: new Container(
        height: 50.0,
        width: 250.0,
        alignment: Alignment.bottomRight,
        decoration: new BoxDecoration(
          border: new Border.all(width: 1.0),
          color: Colors.red,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int j = 0;
    return Container(
      color: Colors.cyan[600],
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: new Center(
                child: new ResponsiveGridView(
                  rows: 2,
                  cols: 2,
                  maxAspectRatio: 1.5,
                  children: _category
                      .map((f) => _builtWord(j++, f))
                      .toList(growable: false),
                ),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                answer('output'),
                new Container(
                    height: 50.0,
                    width: 100.0,
                    margin: new EdgeInsets.all(1.0),
                    child: new RaisedButton(
                      onPressed: null,
                      shape: new RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(8.0))),
                      child: new Text(
                        'submit',
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ))
              ],
            ),
            new Center(
              child: new ResponsiveGridView(
                rows: 4,
                cols: 5,
                maxAspectRatio: 1.4,
                children: _words
                    .map((f) => _builtWord(j++, f))
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);

  final String text;
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
    print("_MyButtonState.initState: ${widget.text}");
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
    return new ScaleTransition(
      scale: animation,
      child: new GestureDetector(
        child: new RaisedButton(
          onPressed: () => widget.onPress(),
          splashColor: Colors.green,
          shape: new RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
          child: new Text(
            _displayText,
            style: new TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}
