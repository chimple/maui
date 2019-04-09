import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/score.dart';
import 'package:storyboard/storyboard.dart';

class ScoreScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Score(
              starCount: 1,
              coinsCount: 100,
              score: 121,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: Score(
              starCount: 2,
              coinsCount: 200,
              score: 122,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: Score(
              starCount: 3,
              coinsCount: 150,
              score: 123,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: Score(
              starCount: 4,
              coinsCount: 170,
              score: 180,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: Score(
              starCount: 5,
              coinsCount: 140,
              score: 360,
            ),
          ),
        ),
      ];
}
