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
    print("hello here its comming ");
    return Scaffold(
      body: new QuizPager(
        onScore: _onScore,
        iteration: maxIterations,
        onProgress: _onProgress,
        onEnd: () => _onEnd(context),
      ),
    );
  }

  // void startQuiz() {
  //   String text =
  //       "This animal is a carnivorous reptile. ajhdiwdihdiuhd ohodihowijdoiw idjwdkjwkdnwkjndkwjd wdijwkjd wdijwdi hwidhwi dwiwdhiwh dowhdiwjhd owdhowihdwhdiuwiduh owhdiuhwoidu dwhdihwoidhu2oi dhwiudiwud";
  //   String image = "assets/focused.png";
  //   setState(() {
  //     Navigator.push(context,
  //         new MaterialPageRoute(builder: (context) => new Multiplechoice()));
  //   });
  // }

  _onScore(int incrementScore) {
    setState(() {
      maxIterations;
    });

    setState(() {
      score = max(0, score + incrementScore);
    });
    //for now we only pass myscore up to the head to head
    //if (widget.onScore != null) widget.onScore(widget.gameConfig.myScore);
  }

  _onProgress(double progress) {
    // setState(() {++maxIterations;});
  }
  _onEnd(BuildContext context,
      {Map<String, dynamic> gameData, bool end = false}) async {
    setState(() {
      ++maxIterations;
    });
  }
}
