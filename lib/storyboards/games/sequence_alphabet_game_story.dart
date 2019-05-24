import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/sequence_alphabet_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class SequenceAlphabetGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: SequenceAlphabetGame(
              answers: BuiltList<DisplayItem>([
                // 'A', 'P', 'P', 'L', 'E'
                DisplayItem(
                  (d) => d
                    ..item = 'A'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'p'
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
              ]),
            ),
          ),
        ),
      ];
}
