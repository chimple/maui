import 'package:flutter/material.dart';
import 'dart:math';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/gameaudio.dart';

class FirstWord extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  FirstWord(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new FirstWordState();
}

enum Statuses { right, wrong }

class FirstWordState extends State<FirstWord> {
  final TextEditingController _textController = new TextEditingController();
  Tuple2<List<String>, String> data;
  String _dispText = '';
  String _dispText1 = '';
  bool _isLoading = true;
  String _category = ''; //['sports'];
  List<String> _catList =
      []; //['cricket','football','tennis','golf','basketball'];
  var rand = new Random();
  int randNum;
  String randomWord = '';
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    print("hello data is not comming here");
    _dispText1 = '';
    _category = '';
    _catList = [];
    setState(() => _isLoading = true);
    data = await fetchFirstWordData(widget.gameConfig.gameCategoryId);
    print('nikkk   ${data.item1}   ${data.item2}');
    _category = data.item2;
    _catList = data.item1;
    randNum = rand.nextInt(_catList.length);
    randomWord = _catList[randNum];
    setState(() => _isLoading = false);
  }

  void submit(text) {
    // print('testing cases     ${text.toLowerCase()}');
    if (text.toLowerCase() == randomWord) {
      _dispText1 = 'CORRECT';
      _textController.clear();
      widget.onScore(5);
      new Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _dispText1 = '';
        });
      });
      widget.onEnd();
    } else {
      _dispText1 = 'WRONG';
    }
  }

  @override
  void didUpdateWidget(FirstWord oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    Size size = MediaQuery.of(context).size;
    print('width      ${size.width}');
    int j = 0;
    int i = 0;

    return new Column(children: <Widget>[
      new Container(
          padding: new EdgeInsets.all(size.width / 10),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: new Container(
                    //   width: 200.0,
                    height: 40.0,
                    color: Colors.brown[300],
                    child: new Text(
                      _category,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  )),
              new Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: new Container(
                    height: 40.0,
                    color: Colors.brown[50],
                    child: new Text(randomWord[0],
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 24.0)),
                  ))
            ],
          )),
      new Container(
        child: new Text(_dispText.toUpperCase(),
            style: new TextStyle(fontSize: 20.0, color: Colors.red)),
      ),
      new Container(
          padding: new EdgeInsets.all(size.width / 10),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: new Container(
                    //   width: 200.0,
                    height: 40.0,
                    color: Colors.brown[300],
                    child: new TextField(
                      controller: _textController,
                      decoration: new InputDecoration(border: InputBorder.none),
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 22.0),
                      textAlign: TextAlign.center,
                      onChanged: (text) {
                        setState(() {
                          _dispText = text;
                        });
                      },
                      onSubmitted: (text) {
                        submit(text);
                      },
                    ),
                  )),
              new Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: new Container(
                    //   width: 100.0,
                    height: 40.0,
                    color: Colors.brown[50],
                    child: new Text(_dispText1,
                        textAlign: TextAlign.center,
                        style:
                            new TextStyle(fontSize: 18.0, color: Colors.blue)),
                  ))
            ],
          )),
    ]);
  }
}
