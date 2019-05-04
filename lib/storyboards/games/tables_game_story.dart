import 'package:flutter/material.dart';
import 'package:maui/games/tables_game.dart';
import 'package:storyboard/storyboard.dart';

class TablesGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: TablesGame(
              question1: 1,
              question2: 2, 
              answer: 2,
            ),
          ),
        ),
      ];
}
