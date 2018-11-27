import 'package:flutter/material.dart';
import 'dart:math';
import 'package:maui/quiz/quiz_pager.dart';

class QuizGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new QuizGameState();
  }
}

class QuizGameState extends State<QuizGame> {
  int maxIterations = 1;
  int score = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new QuizPager(
        onScore: _onScore,
        iteration: maxIterations,
        onProgress: _onProgress,
        onEnd: () => _onEnd(context),
      ),
    );
  }

  _onScore(int incrementScore) {
    setState(() {
      score = max(0, score + incrementScore);
    });
  }

  _onProgress(double progress) {}
  _onEnd(BuildContext context,
      {Map<String, dynamic> gameData, bool end = false}) async {
    setState(() {
      ++maxIterations;
    });
  }
}
