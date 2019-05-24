import 'package:flutter/material.dart';
import 'package:maui/games/tapping_game.dart';
import 'package:storyboard/storyboard.dart';

class TappingGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: TappingGame(
              choice: 8,
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
         Scaffold(
          body: SafeArea(
            child: TappingGame(
              choice: 5,
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
