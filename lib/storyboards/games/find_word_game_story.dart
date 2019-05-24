import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/find_word_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class FindWordGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: FindWordGame(
              image: 'assets/accessories/apple.png',
              answer: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'P'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'P'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'L'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'E'
                    ..displayType = DisplayTypeEnum.letter,
                ),

                // 'A', 'P', 'P', 'L', 'E'
              ]),
              choices: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'X'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Y'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'P'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'E'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'B'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'L'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'W'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                // 'A', 'X', 'Y', 'P', 'E', 'B', 'L', 'W'
              ]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
