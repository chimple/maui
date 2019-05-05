import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/models/sentence_data.dart';

class MadSentenceGame extends StatefulWidget {
  final SentenceData sentenceData;
  final OnGameUpdate onGameUpdate;
  const MadSentenceGame({Key key, this.sentenceData, this.onGameUpdate})
      : super(key: key);
  @override
  _MadSentenceGameState createState() => new _MadSentenceGameState();
}

class _MadSentenceGameState extends State<MadSentenceGame> {
  int _buttonKey = 0;
  int _wordNum = 0;
  int score = 0;
  String sentence = '';
  Map<int, WordWithImage> _wordPos = Map();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.sentenceData.wordWithImages.length; i++) {
      _wordPos[i] = widget.sentenceData.wordWithImages[i][0];
    }
  }

  Widget _scrollTiles(
      BuildContext context, BuiltList<WordWithImage> words, int button) {
    final buttonConfig = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: CupertinoPicker(
          looping: true,
          // magnification: 1.3,
          backgroundColor: Colors.black87,
          diameterRatio: 2.0,
          itemExtent: buttonConfig.height * 0.1,
          onSelectedItemChanged: (i) {
            _wordPos[button] = widget.sentenceData.wordWithImages[button][i];
          },
          children: words.map((w) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(w.image),
                Text(
                  w.word,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            );
          }).toList(growable: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: FadeAnimatedTextKit(
            text: [sentence],
            textStyle: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent),
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.purpleAccent,
            child: GridView.count(
              shrinkWrap: true,
              mainAxisSpacing: 5.0,
              crossAxisCount: 3,
              children: widget.sentenceData.wordWithImages.map((s) {
                return Column(
                  children: <Widget>[
                    _buttonKey < widget.sentenceData.wordWithImages.length
                        ? Text(widget.sentenceData.headers[_buttonKey],
                            style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent))
                        : Text(""),
                    Expanded(
                      child: _scrollTiles(context, s, _buttonKey++),
                    ),
                  ],
                );
              }).toList(growable: false),
            ),
          ),
        ),
        FloatingActionButton.extended(
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            setState(() {
              widget.sentenceData.wordWithImages.forEach((f) {
                sentence = sentence + " " + _wordPos[_wordNum++].word;
              });
              score++;
              FlutterTts().speak(sentence);
              Future.delayed(
                  const Duration(milliseconds: 700),
                  () => widget.onGameUpdate(
                      score: score, max: score, gameOver: true, star: true));
              _buttonKey = 0;
            });
          },
          icon: Icon(
            Icons.done,
            size: 40.0,
          ),
          label: Text(
            "Done",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
