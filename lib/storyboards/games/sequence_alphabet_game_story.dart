import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/sequence_alphabet_game.dart';
import 'package:storyboard/storyboard.dart';

class SequenceAlphabetGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: SequenceAlphabetGame(
              answers: BuiltList<String>(['A', 'P', 'P', 'L', 'E']),
            ),
          ),
        ),
      ];
}
