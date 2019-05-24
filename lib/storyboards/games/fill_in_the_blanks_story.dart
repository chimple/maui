import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/fill_in_the_blanks_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';
import 'package:tuple/tuple.dart';

class FillInTheBlanksGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: FillInTheBlanksGame(
              question: ' Mount Everest is the highest 1_ in the 2_ .',
              choices: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = "mountain"
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = "earth"
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = "chair"
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = "ball"
                    ..displayType = DisplayTypeEnum.word,
                ),

                // 'mountain', 'earth', 'chair', 'ball'
              ]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
            body: SafeArea(
                child: FillInTheBlanksGame(
          question:
              ' The fact is Mount Everest is the highest 1_ in the earth followed by K2,located in the Himalayas.',
          choices: BuiltList<DisplayItem>([
            DisplayItem(
              (d) => d
                ..item = "mountain"
                ..displayType = DisplayTypeEnum.word,
            ),
            DisplayItem(
              (d) => d
                ..item = "earth"
                ..displayType = DisplayTypeEnum.word,
            ),
            DisplayItem(
              (d) => d
                ..item = "chair"
                ..displayType = DisplayTypeEnum.word,
            ),
            DisplayItem(
              (d) => d
                ..item = "ball"
                ..displayType = DisplayTypeEnum.word,
            ),
            // 'mountain', 'earth', 'chair', 'ball'
          ]),
          onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
        ))),
        Scaffold(
            body: SafeArea(
                child: FillInTheBlanksGame(
          question: 'Lion is the king of the 1_ .',
          choices: BuiltList<DisplayItem>([
            DisplayItem(
              (d) => d
                ..item = "jungle"
                ..displayType = DisplayTypeEnum.word,
            ),
            DisplayItem(
              (d) => d
                ..item = "earth"
                ..displayType = DisplayTypeEnum.word,
            ),
            DisplayItem(
              (d) => d
                ..item = "chair"
                ..displayType = DisplayTypeEnum.word,
            ),
            DisplayItem(
              (d) => d
                ..item = "ball"
                ..displayType = DisplayTypeEnum.word,
            ),
            // 'jungle', 'earth', 'chair', 'ball'
          ]),
          onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
        )))
      ];
}
