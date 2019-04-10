import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/memory_game.dart';
import 'package:storyboard/storyboard.dart';

class MemoryGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MemoryGame(
              first: BuiltList<String>(['1', '2', '3', '4']),
              second: BuiltList<String>(['1', '2', '3', '4']),
            ),
          ),
        ),
      ];
}
