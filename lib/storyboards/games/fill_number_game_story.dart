import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/fill_number_game.dart';
import 'package:storyboard/storyboard.dart';

class FillNumberGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
              child: FillNumberGame(
            serialData: [
              1,
              2,
              3,
              4,
              5,
              2,
              4,
              1,
              1,
              1,
              2,
              3,
              4,
              4,
              3,
              2,
            ],
            onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
          )),
        ),
      ];
}
