import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/tracing_alphabet_game.dart';
import 'package:storyboard/storyboard.dart';

class TracingAlphabetStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: Center(
            child: TracingAlphabetGame(
                alphabets: BuiltList<String>([
              'A',
              'B',
              'C',
              'D',
            ])),
          ),
        )
      ];
}
