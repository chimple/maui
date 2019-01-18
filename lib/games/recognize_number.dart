import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/flip_animator.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:tuple/tuple.dart';

class RecognizeNumber extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  RecognizeNumber(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.onTurn,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new RecognizeNumberState();
}

enum Status { active, visible }

enum Code { question, answer }

class RecognizeNumberState extends State<RecognizeNumber>
    with SingleTickerProviderStateMixin {
  int _size = 2;

  List<Status> _statuses = [];
  static int _maxSize = 2;
  List<String> _answer = [];
  List<String> _question = [];
  bool _isLoading = true;
 Tuple2<List<String>, List<String>> recognizeData;

  @override
  void initState() {
    super.initState();
    print("this are my game basic");
    _initBoard();
    _statuses = _question.map((e) => Status.active).toList(growable: false);
  }
 void _initBoard() async{
    setState(() {
       _isLoading = true;
        });
    recognizeData = await fetchRecognizeNumberData(widget.gameConfig.gameCategoryId);
    recognizeData.item1.forEach((e){
      _question.add(e);

    });
    recognizeData.item2.forEach((e){
      _answer.add(e);
    });
     _statuses = _question.map((e) => Status.active).toList(growable: false);
        _statuses = _answer.map((e) => Status.active).toList(growable: false);

    print("this is al ieierjierl $_question");
    print("this is a answer $_answer");
    setState(() => _isLoading = false);

 }

   @override
  void didUpdateWidget(RecognizeNumber oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      _answer = [];
      _question = [];
      _statuses = [];
      _initBoard();
    }
  }

  Widget _buildItem(int index, String text, Status status, maxChars,
      double maxWidth, double maxHeight, code) {
    print("clicking button calling again and again we have fix");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        code: code,

        //question unit mode
        status: status,
        onPress: () {
          if (code == Code.answer) {
            print("this is text $text");
            print("this is answer ${_answer[0]}");
            if (_question[0] == text) {
             
              _statuses[index] = Status.visible;
              setState(() {
                 print("success");
              widget.onEnd();
              _answer = [];
              _question = [];
              _statuses = [];
           AppStateContainer.of(context).playWord(_question[index]);

            });
            }
          }
          if(code == Code.question){
            print("hello i am coming");
              AppStateContainer.of(context).playWord(text.toLowerCase());
          }
          print(" staus is.......::$_statuses");

          print("this is my new index of text $text");
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    print("this is my letters $_answer");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    print("this is after random $_question");

    return new LayoutBuilder(builder: (context, constraints) {
      if (_isLoading) {
      return new SizedBox(
          width: 20.0, height: 20.0, child: new CircularProgressIndicator());
    }
      
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      final maxChars = (_question != null
          ? _question.fold(1,
              (prev, element) => element.length > prev ? element.length : prev)
          : 1);
      print("$maxChars");
      double maxWidth = (constraints.maxWidth - hPadding * 2) / _maxSize;
      double maxHeight =
          (constraints.maxHeight - vPadding * 2) / (_maxSize + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
      print("this is my new $_answer");
      var j = 0, k = 0;
      return Container(
        child: new Column(
          children: <Widget>[
            new Expanded(
                child: Container(
              color: Colors.amberAccent,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: 1,
                    cols: 1,
                    children: _question
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(j, e, _statuses[j++], maxChars,
                                maxWidth, maxHeight, Code.question)))
                        .toList(growable: false),
                  )),
            )),
            new Expanded(
                child: Container(
              // color: Colors.lightBlue,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: 1,
                    cols: 2,
                    children: _answer
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(k, e, _statuses[k++], maxChars,
                                maxWidth, maxHeight, Code.answer)))
                        .toList(growable: false),
                  )),
            )),
          ],
        ),
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.onPress,
      this.status,
      this.maxChars,
      this.maxWidth,
      this.maxHeight,
      this.code})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
  final Status status;
  UnitMode unitMode; //question unit mode
  final int maxChars;
  final double maxWidth;
  final double maxHeight;
  final Code code;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
 AnimationController controller;
 
  @override
  void didUpdateWidget(MyButton oldWidget) {
    print({"oldwidget data ": oldWidget.text});
  }
@override
 void initState() { 
  super.initState();
 controller = AnimationController(
        duration: Duration(milliseconds: 500), vsync:this);
        controller.addStatusListener((state) {
            // print("$state:${animation.value}");
            if (state == AnimationStatus.dismissed) {
              print('dismissed');
              if (widget.text != null) {
                // setState(() => _displayText = widget.text);
                controller.forward();
              }
            }
            controller.reverse();
          });

}
  @override
  void dispose() {
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
// print({"this is 123 kiran data": widget.Rtile});
    print({"this is 123 kiran column": widget.text});
    if (ButtonStateContainer.of(context) != null) {
    return  widget.code == Code.question
          ? UnitButton(
              text: widget.text,
              primary: true,
              onPress: widget.onPress,
              unitMode: UnitMode.audio,
            )
          : UnitButton(
              text: widget.text,
              onPress: widget.onPress,
              unitMode: UnitMode.text,
            );  }
}
}
