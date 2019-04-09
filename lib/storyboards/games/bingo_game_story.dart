import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/bingo_game.dart';
import 'package:storyboard/storyboard.dart';

class BingoGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: BingoGame(
              choices: {
                'A': 'A',
                'B': 'B',
                'C': 'C',
                'D': 'D',
              },
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: BingoGame(
              choices: {
                'A': 'A',
                'B': 'B',
                'C': 'C',
                'D': 'D',
                'E': 'E',
                'F': 'F',
                'G': 'G',
                'H': 'H',
                'I': 'I',
                'J': 'J',
                'K': 'K'
              },
            ),
          ),
        ),
      ];
}
