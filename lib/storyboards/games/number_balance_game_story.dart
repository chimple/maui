import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/number_balance_game.dart';
import 'package:storyboard/storyboard.dart';
import 'package:tuple/tuple.dart';

class NumberBalanceGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: NumberBalanceGame(
              leftExpression: Tuple3('6', null, null),
              rightExpression: Tuple3('9', '-', '?'),
              choices: BuiltList<int>([2, 4, 3, 1]),
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: NumberBalanceGame(
              leftExpression: Tuple3('6', null, null),
              rightExpression: Tuple3('4', '+', '?'),
              choices: BuiltList<int>([2, 4, 3, 1]),
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: NumberBalanceGame(
              leftExpression: Tuple3('12', '-', '?'),
              rightExpression: Tuple3('9', '+', '?'),
              choices: BuiltList<int>([2, 6, 7, 1]),
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: NumberBalanceGame(
              leftExpression: Tuple3('2', '+', '?'),
              rightExpression: Tuple3('9', '-', '?'),
              choices: BuiltList<int>([2, 6, 7, 0]),
              onGameOver: (_) {},
            ),
          ),
        ),
      ];
}
