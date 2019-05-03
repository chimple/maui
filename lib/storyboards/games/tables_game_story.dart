import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/tables_game.dart';
import 'package:storyboard/storyboard.dart';
import 'package:built_collection/built_collection.dart';

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
