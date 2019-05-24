import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/finger_game.dart';
import 'package:maui/games/true_false_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class TrueFalseGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: TrueFalseGame(
              question: DisplayItem(
                (d) => d
                  ..item = 'Pin'
                  ..displayType = DisplayTypeEnum.word,
              ),
              answer: DisplayItem(
                (d) => d
                  ..item = 'win'
                  ..displayType = DisplayTypeEnum.word,
              ),
              right_or_wrong: false,
            ),
          ),
        ),
      ];
}
