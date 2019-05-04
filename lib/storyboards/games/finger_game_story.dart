import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/finger_game.dart';
import 'package:storyboard/storyboard.dart';

class FingerGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: FingerGame(
              answer: 3,
              choices: BuiltList<int>([2, 3]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: FingerGame(
              answer: 7,
              choices: BuiltList<int>([6, 7, 8]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        )
      ];
}
