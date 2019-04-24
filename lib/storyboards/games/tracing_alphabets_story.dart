import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/tracing_alphabet_game.dart';
import 'package:storyboard/storyboard.dart';

class TracingAlphabetStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: TracingAlphabetGame(
            alphabets: [
            'A',
            'B',
            'C',
            'D',
          ]),
        )
      ];
}
