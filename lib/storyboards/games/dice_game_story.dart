import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/dice_game.dart';
import 'package:storyboard/storyboard.dart';

class DiceGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: DiceGame(
              choices: BuiltList<int>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        )
      ];
}
