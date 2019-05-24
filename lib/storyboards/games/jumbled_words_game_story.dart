import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/jumbled_words_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class JumbledWordsGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: JumbledWordsGame(
              answer: DisplayItem(
                (d) => d
                  ..item = 'A'
                  ..displayType = DisplayTypeEnum.letter,
              ),
              choices: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'B'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'C'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'D'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'E'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'F'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'H'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                // 'A', 'B', 'C', 'D', 'E', 'F', 'H'
              ]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: JumbledWordsGame(
              answer: DisplayItem(
                  (d) => d
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
              choices: BuiltList<DisplayItem>([
                 DisplayItem(
                  (d) => d
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'B'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'C'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'D'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                // 'A', 'B', 'C', 'D'
                ]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
