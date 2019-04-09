import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/score.dart';
import 'package:storyboard/storyboard.dart';

class ScoreStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          backgroundColor: Colors.purple,
          body: SafeArea(
            child: Score(
              starCount: 3,
              score: 3,
              coinsCount: 4,
              updateCoins: (coins) => print(coins),
            ),
          ),
        )
      ];
}
