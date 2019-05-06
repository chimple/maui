import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/finger_game.dart';
import 'package:maui/games/rhyme_words_game.dart';
import 'package:storyboard/storyboard.dart';

class RhymeWordsGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: RhymeWordsGame(
              questions: BuiltList<String>([
                'Pin',
                'Pet',
                'Me',
                'Bee',
              ]),
              answers: BuiltList<String>([
                'Win',
                'Wet',
                'We',
                'See',
              ]),
            ),
          ),
        ),
      ];
}
