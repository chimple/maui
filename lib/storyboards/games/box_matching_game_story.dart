import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/box_matching_game.dart';
import 'package:storyboard/storyboard.dart';

class BoxMatchingGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: BoxMatchingGame(
              choices: BuiltList<String>(
                  ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B']),
              answers: BuiltList<String>(['A', 'B', 'C', 'D']),
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
