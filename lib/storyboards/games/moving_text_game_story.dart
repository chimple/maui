import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/moving_text_game.dart';
import 'package:storyboard/storyboard.dart';

class MovingTextGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MovingTextGame(
              answers: BuiltList(['A', 'B', 'C', 'D']),
              choices: BuiltList<String>(['A', 'B', 'C', 'D', 'E', 'F', 'H']),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: MovingTextGame(
              answers: BuiltList(['क', 'ख' 'ग', 'घ' 'ङ']),
              choices: BuiltList<String>(['क', 'ख' 'ग', 'घ' 'ङ', 'च', 'छ']),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
