import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/tap_home_game.dart';
import 'package:storyboard/storyboard.dart';

class TapHomeStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: TapHome(
              answer: "2",
              choices: ["1", "2", "3", "4", "5", "6", "7"],
              onGameOver: (_) {},
            ),
          ),
        ),
      ];
}
