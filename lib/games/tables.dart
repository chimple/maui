import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/flash_card.dart';

class Tables extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Tables({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId, this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _TablesState();
}

class _TablesState extends State<Tables> with SingleTickerProviderStateMixin {
  final int _size = 3;
  String _question = "";
  String _result = "";
  int count = 0;
  int _wrong = 0;
  int _answer;
  bool _isLoading = true;
  List<Tuple4<int, String, int, int>> _tableData;
  List<Tuple4<int, String, int, int>> _tableShuffledData = [];
  Animation animation;
  AnimationController animationController;
  bool _isShowingFlashCard = false;

  final List<String> _allLetters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'clear',
    '0',
    'submit',
  ];

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    animationController =new AnimationController(duration: new Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 20.0).animate(animationController);

    setState(()=>_isLoading=true);
    _tableData = await fetchTablesData(widget.gameCategoryId);
    _tableShuffledData = [];

    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _tableShuffledData.addAll(
          _tableData.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }

    int temp1 = _tableShuffledData[count].item1;
    String temp2 = _tableShuffledData[count].item2;
    int temp3 = _tableShuffledData[count].item3;
    _question= "$temp1 $temp2 $temp3";
    _answer=  _tableShuffledData[count].item4;
    setState(()=>_isLoading=false);
  }

  void _myAnim() {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
    print('Pushed the Button');
  }


  Widget _buildItem(int index, String text, double _height) {
    print('_buildItem: $text');
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        height: _height,
        onPress: () {
          if(text=='clear') {
            setState(() {
              _result = _result.substring(0, _result.length - 1);
            });
          }
          else if(text == 'submit') {
            if( count > 7) {
              print("coming.........");
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
            }
            if(int.parse(_result) == _answer) {
              widget.onScore(1);
              widget.onProgress((count + 2) / 6.5);
              setState(() {
                count = count + 1 ;
                print(count);
                int temp1 = _tableShuffledData[count].item1;
                String temp2 = _tableShuffledData[count].item2;
                int temp3 = _tableShuffledData[count].item3;
                _question= "$temp1 $temp2 $temp3";
                _answer= _tableShuffledData[count].item4;;
                _result = "";
              });
            }
            else{
              _myAnim();
              new Future.delayed(const Duration(milliseconds: 700), () {
                setState((){
                  _wrong = _wrong + 1;
                  _result = "";
                });
                animationController.stop();
                if(_wrong == 2){
                  setState(() {
                    _isShowingFlashCard = true;
                    _wrong = 0;
                  });
                }
              });
            }
          }
          else {
            setState(() {
              if (_result.length < 3) {
                _result = _result + text;
              }
            });
          }});
  }


  @override
  void didUpdateWidget(Tables oldWidget) {
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print("anuj data");
    print(media.size);
    if(_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    if (_isShowingFlashCard) {
      return new FlashCard(text: _answer.toString(), onChecked: () {
        setState(() {
          _isShowingFlashCard = false;
          this.count = this.count + 1;
          int temp1 = _tableShuffledData[count].item1;
          String temp2 = _tableShuffledData[count].item2;
          int temp3 = _tableShuffledData[count].item3;
          _question= "$temp1 $temp2 $temp3";
          _answer = _tableShuffledData[count].item4;
        });
      });
    }
    return new LayoutBuilder(builder: (context, constraints)
    {
        print("this is  data");
        print(constraints.maxHeight);
        print(constraints.maxWidth);
        double _height, _width;
        _height = constraints.maxHeight;
        _width = constraints.maxWidth;
      List<TableRow> rows = new List<TableRow>();
      var j = 0;
      for (var i = 0; i < _size + 1; ++i) {
        List<Widget> cells = _allLetters
            .skip(i * _size)
            .take(_size)
            .map((e) => _buildItem(j++, e, _height))
            .toList();
        rows.add(new TableRow(children: cells));

      }
      return new Center(
          child: new Container(
              color: new Color(0XFFF39B6D),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Container (
                      margin: new EdgeInsets.only(bottom: _height * 0.1),
                      alignment: Alignment.center,
                      color: new Color(0X00000000),
                      child: new Text(
                        '$_question',
                        key: new Key('question'),
                        style: new TextStyle(
                          fontSize: _height * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    new TextAnimation(
                        animation: animation,
                        text: _result,
                        height: _height,
                        width: _width,
                    ),
                    new Container(
                      child: new Center(
                        child: new Table(children: rows),
                      ),
                    )
                  ]),
            ));
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.height, this.onPress}) : super(key: key);

  final String text;
  final double height;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;
  int _count = 0;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text.isEmpty && widget.text.isNotEmpty) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new TableCell(
        child: new Padding(
            padding: new EdgeInsets.all(widget.height * 0.001),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: new EdgeInsets.all(widget.height * 0.02),
                    color: new Color(0XFFFED2B7),
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                        new BorderRadius.all(new Radius.circular(widget.height * 0.09))),
                    child: new Text(_displayText,
                        key: new Key('keyPad$_count'),
                        style: new TextStyle(
                            color: Colors.black, fontSize: widget.height * 0.05))))));
  }
}

class TextAnimation extends AnimatedWidget {
  TextAnimation({Key key, Animation animation, this.text, this.height, this.width})
      : super(key: key, listenable: animation);
  final String text;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return new LayoutBuilder(builder: (context, constraints) {
      return new Center(
        child: new Container(
          height: height * 0.12,
          width: width / 3.0,
          alignment: Alignment.center,
          color: new Color(0XFF734052),
          margin: new EdgeInsets.only(
              left: animation.value ?? 0, bottom: height * 0.09),
          child: new Text(text,
              style: new TextStyle(
                color: Colors.black,
                fontSize: height * 0.1,
                fontWeight: FontWeight.bold,))));
    });
  }
}

