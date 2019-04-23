import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/tracing_alphabet.dart';
import 'package:storyboard/storyboard.dart';

class TracingAlphabetStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: TracingAlphabet(alphabets: [
              'A',
              'B',
              'C',
              'D',
              'E',
              'F',
              'G',
              'H',
              'I',
            ]),
          ),
        )
      ];
}
