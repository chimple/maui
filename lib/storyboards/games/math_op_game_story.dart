import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/math_op_game.dart';
import 'package:storyboard/storyboard.dart';

class MathOpGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MathOpGame(
              first: 3,
              second: 5,
              op: '+',
              answer: 8,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: MathOpGame(
              first: 7,
              second: 9,
              op: '+',
              answer: 16,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: MathOpGame(
              first: 9,
              second: 3,
              op: '-',
              answer: 6,
            ),
          ),
        )
      ];
}
