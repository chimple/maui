import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/models/game_status.dart';
import 'package:maui/jamaica/screens/user_progress_screen.dart';
import 'package:storyboard/storyboard.dart';

class UserProgressScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: UserProgressScreen(
                gameStatuses: BuiltMap<String, GameStatus>(
              {
                'Basic Addition': GameStatus((b) => b
                  ..currentLevel = 5
                  ..maxScore = 20
                  ..highestLevel = 10
                  ..open = true),
                'Memory match': GameStatus((b) => b
                  ..currentLevel = 3
                  ..maxScore = 30
                  ..highestLevel = 10
                  ..open = true),
              },
            )),
          ),
        )
      ];
}
