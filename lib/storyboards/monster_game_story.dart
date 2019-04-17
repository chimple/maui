import 'package:flutter/material.dart';
import 'package:storyboard/storyboard.dart';
import 'package:tahiti/activity_board.dart';

class MonsterGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: ActivityBoard(
              drawText: "A",
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: ActivityBoard(
              drawText: "Z",
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: ActivityBoard(),
          ),
        )
      ];
}
