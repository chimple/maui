import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/game_score.dart';
import 'package:storyboard/storyboard.dart';

class GameScoreStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          backgroundColor: Colors.purple,
          body: SafeArea(
            child: GameScore(),
          ),
        )
      ];
}
