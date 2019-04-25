import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/unit_game.dart';
import 'package:storyboard/storyboard.dart';

class UnitGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: UnitGame(
              question: 165,
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: UnitGame(
              question: 909,
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
