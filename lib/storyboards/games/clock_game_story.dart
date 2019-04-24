import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/clock_game.dart';
import 'package:storyboard/storyboard.dart';
import 'package:built_collection/built_collection.dart';

class ClockGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: ClockGame(
              hour: 10,
              minute: 50,
              choices: BuiltList<int>([
                12,
                10,
                50,
                15
              ]),
            ),
          ),
        ),
      ];
}
