import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'dart:async';
import 'package:maui/jamaica/state/game_utils.dart';

class CasinoGame extends StatefulWidget {
  final List<List<String>> letters;
  final OnGameOver onGameOver;
  CasinoGame({key, this.letters, this.onGameOver}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CasinoGameState();
}

class _CasinoGameState extends State<CasinoGame> {
  String givenWord = "";
  String word = "";
  Map<int, String> _wordPos = Map();
  int score = 0;
  int buttonKey = 0;

  @override
  void initState() {
    super.initState();
    _initLetters();
  }

  void _initLetters() {
    for (var i = 0; i < widget.letters.length; i++) {
      givenWord += widget.letters[i][0];
    }
  }

  Widget _buildScrollButton(
      BuildContext context, List<String> scrollingData, int buttonNumber) {
    var rndm = new Random();
    var random = rndm.nextInt(3);
    final buttonConfig = MediaQuery.of(context).size;

    _wordPos[buttonNumber] = widget.letters[buttonNumber][random];
    word += _wordPos[buttonNumber];
    return Container(
      height: buttonConfig.height * 0.18,
      width: buttonConfig.width * 0.15,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: random),
        looping: true,
        diameterRatio: 2.0,
        itemExtent: buttonConfig.height * 0.08,
        backgroundColor: Color(0xFF734052),
        onSelectedItemChanged: (index) {
          word = "";
          _wordPos[buttonNumber] = scrollingData[index];
          for (int i = 0; i < widget.letters.length; i++) {
            word += _wordPos[i];
          }
        },
        children: scrollingData.map((w) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                w,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
            ],
          );
        }).toList(growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Color(0xFF734052),
            child: Center(
              child: Text(
                givenWord,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 70.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ResponsiveGridView(
            cols: widget.letters.length,
            rows: 1,
            maxAspectRatio: 0.7,
            children: widget.letters.map((s) {
              return _buildScrollButton(context, s, buttonKey++);
            }).toList(growable: false),
          ),
        ),
        Expanded(
            flex: 1,
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  if (givenWord == word) {
                    score++;
                    Future.delayed(const Duration(milliseconds: 700),
                        () => widget.onGameOver(score));
                    Navigator.of(context).pop();
                  }
                },
                color: Color(0xFF734052),
                child: Icon(Icons.check_box,
                    size: 100.0 * 0.7, color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
              ),
            ))
      ],
    );
  }
}
