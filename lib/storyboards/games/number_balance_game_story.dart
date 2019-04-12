import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/number_balance_game.dart';
import 'package:storyboard/storyboard.dart';

class NumberBalanceGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: NumberBalanceGame(
              question: 6,
              answerPosition: 1,
              choices: BuiltList<int>([2, 4, 3, 1]),
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
