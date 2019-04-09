import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/counting_game.dart';
import 'package:storyboard/storyboard.dart';

class CountingGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: CountingGame(
              onGameOver: (_) {},
              answer: 5,
              choices: BuiltList<int>([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CountingGame(
              onGameOver: (_) {},
              answer: 2,
              choices: BuiltList<int>([1, 2]),
            ),
          ),
        )
      ];
}
