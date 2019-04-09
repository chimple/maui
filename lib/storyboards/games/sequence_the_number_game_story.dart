import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/sequence_the_number_game.dart';
import 'package:storyboard/storyboard.dart';

class SequenceTheNumberGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: SequenceTheNumberGame(
              sequence: BuiltList<int>([1, 2, 3, 4]),
              choices: BuiltList<int>([3, 5, 6]),
              blankPosition: 2,
            ),
          ),
        )
      ];
}
