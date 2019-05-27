import 'package:flutter/material.dart';
import 'package:maui/games/matching.dart';
import 'package:storyboard/storyboard.dart';

class MatchingStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Matching(
               key: Key('MatchingGame'),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
