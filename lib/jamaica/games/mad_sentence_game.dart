import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/models/sentence_data.dart';

class MadSentenceGame extends StatefulWidget {
  final SentenceData sentenceData;
  final OnGameOver onGameOver;
  const MadSentenceGame({Key key, this.sentenceData, this.onGameOver})
      : super(key: key);
  @override
  _MadSentenceGameState createState() => new _MadSentenceGameState();
}

class _MadSentenceGameState extends State<MadSentenceGame> {
  int _buttonKey = 0;
  String sentence = '';
  int score = 0;
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
        child:
            // Flex(
            //   direction: Axis.vertical,
            //   children: <Widget>[
            //     Text(
            //       widget.header[button],
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         color: Colors.red,
            //         fontSize: 40.0,
            //       ),
            //     ),
            CupertinoPicker(
          looping: true,
          // magnification: 1.5,
          backgroundColor: Colors.blueGrey,
          diameterRatio: 1.5,
          itemExtent: buttonConfig.height * 0.10,
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
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            );
          }).toList(growable: false),
        )
        //     ],
        //   ),
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
            text: [
              _wordPos[0].word +
                  " " +
                  _wordPos[1].word +
                  " " +
                  _wordPos[2].word,
            ],
            textStyle: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent),
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart,
          ),
        ),
        Flexible(
          flex: 2,
          child: GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 5.0,
            crossAxisCount: 3,
            children: widget.sentenceData.wordWithImages.map((s) {
              return _scrollTiles(context, s, _buttonKey++);
            }).toList(growable: false),
          ),
        ),
        FloatingActionButton.extended(
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            setState(() {
              sentence = _wordPos[0].word +
                  " " +
                  _wordPos[1].word +
                  " " +
                  _wordPos[2].word;
              score++;
              FlutterTts().speak(sentence);
              Future.delayed(const Duration(milliseconds: 700),
                  () => widget.onGameOver(score));
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
