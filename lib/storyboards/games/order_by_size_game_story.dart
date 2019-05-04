import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/order_by_size_game.dart';
import 'package:storyboard/storyboard.dart';

class OrderBySizeGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: OrderBySizeGame(
              answers: BuiltList<int>([1, 7]),
              choices: BuiltList<int>([2, 7, 3, 1]),
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        )
      ];
}
