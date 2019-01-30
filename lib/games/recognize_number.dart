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
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:simple_permissions/simple_permissions.dart';

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
  bool _isListening = false;
  String result = '';
  String newResult;
  bool _speechRecognitionAvailable = false;
  Tuple2<List<String>, List<String>> recognizeData;
  SpeechRecognition _speech;

  @override
  void initState() {
    super.initState();
    print("this are my game basic");
    _initBoard();
    _statuses = _question.map((e) => Status.active).toList(growable: false);
  }

  void _initBoard() async {
    setState(() {
      _isLoading = true;
    });
    SimplePermissions.requestPermission(Permission.RecordAudio);

    print('_SpeechRecognitionState.initialize... ');
    _speech = new SpeechRecognition();
    _speech.setSpeechRecognitionAvailableHandler(onSpeechRecognitionAvailable);
    _speech.setSpeechCurrentLocaleHandler(onSpeechCurrentLocaleSelected);
    _speech.setSpeechRecognitionResultHandler(onSpeechRecognitionResult);
    _speech.setSpeechRecognitionOnErrorHandler(onSpeechRecognitionError);
    _speech
        .initialize()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
    recognizeData =
        await fetchRecognizeNumberData(widget.gameConfig.gameCategoryId);
    recognizeData.item1.forEach((e) {
      _question.add(e);
    });
    recognizeData.item2.forEach((e) {
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
          print("this is my result $result");
          // if (text == result) {
          //   _statuses[index] = Status.visible;
          //   setState(() {
          //     print("success");
          //     widget.onEnd();
          //     _answer = [];
          //     _question = [];
          //     _statuses = [];
          //     result = "";
          //   });
          // }
          // if (code == Code.answer) {
          //   print("this is text $text");
          //   print("this is answer $result");
          //   // if ( text == result.toString()) {
          //   //   _statuses[index] = Status.visible;
          //   //   setState(() {
          //   //     print("success");
          //   //     widget.onEnd();
          // _answer = [];
          // _question = [];
          // _statuses = [];
          // result = "";
          //   //     //  Future.delayed(new Duration(seconds: 50), () {
          //   //     //    setState(() {
          //   //     //      stopListening();
          //   //     //    });
          //   //     //  });

          //   //     // AppStateContainer.of(context).playWord(_question[index]);
          //   //   });
          //   // }
          // }
          if (_speechRecognitionAvailable && !_isListening) {
            print("hello i am coming $result");

            setState(() {
              newResult = result;

              print("this is the case with $_question[0]");
              // stopListening();

              print("hey this mee$newResult");
              if (code == Code.question) {
                print("this is my new text $text");

                // widget.onEnd();
                // _answer = [];
                // _question = [];
                // _statuses = [];
                // result = "";
                if (newResult == text) {
                  print("on end yes $newResult");
                }
              }
            });

            // AppStateContainer.of(context).playWord(text.toLowerCase());
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
    print("this is my result and data $result");

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: new RaisedButton(
                          onPressed:
                              _speechRecognitionAvailable && !_isListening
                                  ? () => startListening()
                                  : null,
                          child: Text("$_question"),
                        ),
                      ),
                      SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: new RaisedButton(
                          onPressed:
                              _isListening ? () => stopListening() : null,
                          child: Text("Close"),
                        ),
                      ),
                    ],
                  )
                  //  new ResponsiveGridView(
                  //   rows: 1,
                  //   cols: 1,
                  //   children: _question
                  //       .map((e) => Padding(
                  //           padding: EdgeInsets.all(buttonPadding),
                  //           child: _buildItem(j, e, _statuses[j++], maxChars,
                  //               maxWidth, maxHeight, Code.question)))
                  //       .toList(growable: false),
                  // )
                  ),
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
            Container(
              width: 300.0,
              height: 100.00,
              child: Center(
                  child: new Text(
                result,
                style: new TextStyle(fontSize: 30.0),
              )),
              color: Colors.red,
            ),
          ],
        ),
      );
    });
  }

  void startListening() => _speech.listen('en', 'US').then((resultSpeech) {
        print(
            '_SpeechRecognitionAppState.start => hey i am here result $resultSpeech');
        result = "";
        setState(() => _isListening = true);
      });

  void stopListening() => _speech.stop().then((resultSpeech) {
        print("this is cool");
        setState(() => _isListening = !resultSpeech);
      });
  void onSpeechRecognitionAvailable(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onSpeechCurrentLocaleSelected(Map<String, String> currentLocale) {
    String lang = currentLocale['lang'];
    String country = currentLocale['country'];
    print(
        '_SpeechRecognitionAppState.onSpeechCurrentLocaleSelected lang $lang and country $country');
    setState(() => 'en' == lang && 'US' == country);
  }

  void onSpeechRecognitionResult(String text) {
    print('_SpeechRecognitionAppState.onSpeechRecognitionResult -> $text}');
    setState(() => result = result + " " + text);
    print("this is my result and data $result");
  }

  void onSpeechRecognitionError(bool res) {
    print('_SpeechRecognitionAppState.onSpeechRecognitionError -> $res}');
    setState(() => _isListening = false);
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
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
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
      return widget.code == Code.question
          ? UnitButton(
              text: widget.text,
              primary: true,
              onPress: widget.onPress,
              unitMode: UnitMode.audio,
            )
          : UnitButton(
              dotFlag: true,
              text: widget.text,
              onPress: widget.onPress,
              unitMode: UnitMode.text,
            );
    }
  }
}
