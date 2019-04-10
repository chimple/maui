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
              question: 4,
              answerPosition: 1,
              choices: BuiltList<int>([1, 4, 5, 8]),
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
