import 'package:built_collection/built_collection.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:data/models/game_config.dart';
import 'package:maui/jamaica/screens/game_level.dart';
import 'package:storyboard/storyboard.dart';

class GameLevelStory extends FullScreenStory {
  final Map<String, List<GameConfig>> games;
  final BuiltMap<String, GameStatus> gameStatuses;

  GameLevelStory({Key key, this.games, this.gameStatuses});

  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: GameLevel(
              gameName: 'Match the shape',
              levelList: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
              gameImage: 'match_the_shape.svg',
            ),
          ),
        ),
      ];
}
