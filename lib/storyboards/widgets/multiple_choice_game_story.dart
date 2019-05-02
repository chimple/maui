import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/storyboards/games/multiple_choice_game.dart';
import 'package:storyboard/storyboard.dart';

class MultipleChoiceGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MultipleChoiceGame(
              key: Key('MultipleChoiceGame'),
              question: 'The largest land animal is _________________?',
              answers: BuiltList(['African Bush Elephant',]),
              choices: BuiltList(['Lion', 'Whale','Panther']),
              onGameOver: (_){},
            ),
          ),
        ),
      ];
}
