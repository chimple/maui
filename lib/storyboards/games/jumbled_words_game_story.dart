import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/jumbled_words_game.dart';
import 'package:storyboard/storyboard.dart';

class JumbledWordsGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: JumbledWordsGame(
              answer: 'A',
              choices: BuiltList<String>(['A', 'B', 'C', 'D', 'E', 'F', 'H']),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: JumbledWordsGame(
              answer: 'A',
              choices: BuiltList<String>(['A', 'B', 'C', 'D']),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
