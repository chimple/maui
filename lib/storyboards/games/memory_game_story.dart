import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/memory_game.dart';
import 'package:storyboard/storyboard.dart';

class MemoryGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MemoryGame(
              first: BuiltList<String>(['1', '2', '3', '4','5','6','7','8']),
              second: BuiltList<String>(['1', '2', '3', '4','5','6','7','8']),
               onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ), Scaffold(
          body: SafeArea(
            child: MemoryGame(
              first: BuiltList<String>(['1', '2', '3', '4']),
              second: BuiltList<String>(['1', '2', '3', '4']),
               onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ), Scaffold(
          body: SafeArea(
            child: MemoryGame(
              first: BuiltList<String>(['1', '2', '3', '4','5','6']),
              second: BuiltList<String>(['1', '2', '3', '4','5','6']),
               onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),Scaffold(
          body: SafeArea(
            child: MemoryGame(
              first: BuiltList<String>(['APPLE','MANGO','GUAVA','PEACH','LICHI','GRAPES',]),
              second: BuiltList<String>(['Apple', 'Mange', 'Guava', 'Peach','Lichi','Grapes',]),
               onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
