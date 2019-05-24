import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/finger_game.dart';
import 'package:maui/games/rhyme_words_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class RhymeWordsGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: RhymeWordsGame(
              questions: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'Pin'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Pet'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Me'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Bee'
                    ..displayType = DisplayTypeEnum.word,
                ),
                // 'Pin',
                // 'Pet',
                // 'Me',
                // 'Bee',
              ]),
              answers: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'Win'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Wet'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'We'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'See'
                    ..displayType = DisplayTypeEnum.word,
                ),
                // 'Win',
                // 'Wet',
                // 'We',
                // 'See',
              ]),
            ),
          ),
        ),
      ];
}
