import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/find_word_game.dart';
import 'package:storyboard/storyboard.dart';

class FindWordGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: FindWordGame(
              image: 'assets/accessories/apple.png',
              answer: BuiltList<String>(['A', 'P', 'P', 'L', 'E']),
              choices:
                  BuiltList<String>(['A', 'X', 'Y', 'P', 'E', 'B', 'L', 'W']),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
