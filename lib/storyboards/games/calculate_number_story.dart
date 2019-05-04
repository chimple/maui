import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/calculate_number.dart';
import 'package:storyboard/storyboard.dart';

class CalculateTheNumberStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        _CalculateWrapper1(),
        _CalculateWrapper2(),
      ];
}

class _CalculateWrapper1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalculateTheNumbers(
          onGameUpdate: ({int score, int max, bool gameOver, bool star}) {
            if (gameOver) {
              Navigator.of(context).pop();
            }
          },
          first: 11,
          second: 5,
          op: '+',
          answer: 16,
        ),
      ),
    );
  }
}

class _CalculateWrapper2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalculateTheNumbers(
          onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
          first: 3,
          second: 5,
          op: '+',
          answer: 8,
        ),
      ),
    );
  }
}
