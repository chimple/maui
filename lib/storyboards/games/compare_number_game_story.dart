import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/compare_number_game.dart';

import 'package:storyboard/storyboard.dart';

class CompareNumberGameStroy extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: CompareNumberGame(
              choices: ["6", "3"],
              answer: ">",
              image: 'assets/accessories/apple.png',
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CompareNumberGame(
              choices: ["5+8", "3"],
              answer: ">",
              image: 'assets/accessories/apple.png',
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CompareNumberGame(
              choices: ["5", "5"],
              answer: "=",
              image: 'assets/accessories/apple.png',
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CompareNumberGame(
              choices: ["2", "5"],
              answer: "<",
              image: 'assets/accessories/apple.png',
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
