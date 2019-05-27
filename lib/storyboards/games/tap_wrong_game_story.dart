import 'package:flutter/material.dart';
import 'package:maui/games/tap_wrong_game.dart';
import 'package:storyboard/storyboard.dart';

class TapWrongGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: TapWrongGame(
              image: 'assets/accessories/apple.png',
              wrongChoice: ['X', 'E'],
              answer: ['A', 'P', 'P', 'L', 'E'],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: TapWrongGame(
              image: 'assets/accessories/mic.png',
              wrongChoice: ['K'],
              answer: ['M', 'I', 'C'],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: TapWrongGame(
              image: 'assets/accessories/text.png',
              wrongChoice: ['O', 'O', 'O', 'O'],
              answer: ['T', 'E', 'X', 'T'],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        )
      ];
}
