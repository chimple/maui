import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/ruler_game.dart';
import 'package:storyboard/storyboard.dart';

class RulerNumbersGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Center(
              child: RulerGame(
                  sequence: ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
                  blankPosition: [6, 8],
                  answer: [7, 12, 9, 10]),
            ),
          ),
        ),
      ];
}
