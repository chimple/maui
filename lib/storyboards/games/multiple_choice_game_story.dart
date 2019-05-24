import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/multiple_choice_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class MultipleChoiceGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MultipleChoiceGame(
              key: Key('MultipleChoiceGame'),
              question: DisplayItem(
                (d) => d
                  ..item = 'The largest land animal is _________________?'
                  ..displayType = DisplayTypeEnum.sentence,
              ),
              //  'The largest land animal is _________________?',
              answers: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'African Bush Elephant'
                    ..displayType = DisplayTypeEnum.sentence,
                ),
                // 'African Bush Elephant',
              ]),
              choices: BuiltList<DisplayItem>([
                DisplayItem((d) => d
                  ..item = 'Lion'
                  ..displayType = DisplayTypeEnum.word),
                DisplayItem(
                  (d) => d
                    ..item = 'Whale'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Panther'
                    ..displayType = DisplayTypeEnum.word,
                ),
                // 'Lion', 'Whale', 'Panther'
              ]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
