import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/box_matching_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class BoxMatchingGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: BoxMatchingGame(
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
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'B'
                    ..displayType = DisplayTypeEnum.letter,
                ),

                // 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B'
              ]),
              answers: BuiltList<DisplayItem>([
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
        )
      ];
}
