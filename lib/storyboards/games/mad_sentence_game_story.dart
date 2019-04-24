import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/mad_sentence_game.dart';
import 'package:storyboard/storyboard.dart';

class DiceGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MadSentenceGame(
              header: ['Who', 'How', 'What'],
              words: [
                ['The Boy', 'The tiger', 'The Girl'],
                ['speaks', 'eat', 'laughs'],
                ['nicely', 'food', 'loudly']
              ],
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
