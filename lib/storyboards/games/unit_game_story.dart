import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/unit_game.dart';
import 'package:storyboard/storyboard.dart';

class UnitGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: UnitGame(
              question: {
                // have to follow same order while adding Hundreds,Tens & Units
                'H': 1,
                'T': 6,
                'U': 5,
              },
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: UnitGame(
              question: {
                'H': 9,
                'T': 0,
                'U': 9,
              },
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
