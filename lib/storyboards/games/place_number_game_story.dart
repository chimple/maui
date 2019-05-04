import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/place_number_game.dart';
import 'package:storyboard/storyboard.dart';

class PlaceTheNumberStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: PlaceTheNumber(
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
              answer: 55,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: PlaceTheNumber(
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
              answer: 2,
            ),
          ),
        )
      ];
}
