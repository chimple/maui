import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/order_it_game.dart';
import 'package:storyboard/storyboard.dart';

class OrderItGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: OrderItGame(
              answers: ['A', 'P', 'P', 'L', 'E'],
            ),
          ),
        ),
      ];
}
