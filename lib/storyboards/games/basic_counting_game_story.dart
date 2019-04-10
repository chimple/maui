import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/basic_counting_game.dart';
import 'package:storyboard/storyboard.dart';

class BasicCountingGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: BasicCountingGame(
              answer: 5,
              choices: BuiltList<int>([1, 2, 3, 4, 5, 6, 7, 8, 9]),
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
