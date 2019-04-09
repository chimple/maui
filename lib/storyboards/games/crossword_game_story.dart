import 'package:built_collection/built_collection.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/crossword_game.dart';
import 'package:storyboard/storyboard.dart';

class CrosswordGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: CrosswordGame(
              data: BuiltList<BuiltList<String>>([
                BuiltList<String>(['E', '', '', '', '']),
                BuiltList<String>(['A', '', '', '', '']),
                BuiltList<String>(['T', 'I', 'G', 'E', 'R']),
                BuiltList<String>(['', '', '', '', 'A']),
                BuiltList<String>(['', '', '', '', 'T'])
              ]),
              images: BuiltList<ImageData>([
                ImageData((b) => b
                  ..image = 'assets/accessories/apple.png'
                  ..x = 0
                  ..y = 0),
                ImageData((b) => b
                  ..image = 'assets/accessories/camera.png'
                  ..x = 2
                  ..y = 0),
                ImageData((b) => b
                  ..image = 'assets/accessories/fruit.png'
                  ..x = 2
                  ..y = 4),
              ]),
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CrosswordGame(
              data: BuiltList<BuiltList<String>>([
                BuiltList<String>(['T', 'E', 'X', 'T']),
                BuiltList<String>(['', '', 'M', '']),
                BuiltList<String>(['J', 'O', 'I', 'N']),
                BuiltList<String>(['', '', 'C', '']),
              ]),
              images: BuiltList<ImageData>([
                ImageData((b) => b
                  ..image = 'assets/accessories/join.png'
                  ..x = 2
                  ..y = 0),
                ImageData((b) => b
                  ..image = 'assets/accessories/text.png'
                  ..x = 0
                  ..y = 0),
                ImageData((b) => b
                  ..image = 'assets/accessories/mic.png'
                  ..x = 1
                  ..y = 2),
              ]),
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CrosswordGame(
              data: BuiltList<BuiltList<String>>([
                BuiltList<String>(['', 'A', '', 'T', '', 'G']),
                BuiltList<String>(['M', 'P', '', 'E', '', 'R']),
                BuiltList<String>(['I', 'P', '', 'X', '', 'A']),
                BuiltList<String>(['C', 'L', 'O', 'T', 'H', 'I']),
                BuiltList<String>(['', 'E', 'J', 'O', 'I', 'N']),
                BuiltList<String>(['', '', '', '', '', 'S']),
              ]),
              images: BuiltList<ImageData>([
                ImageData((b) => b
                  ..image = 'assets/accessories/apple.png'
                  ..x = 0
                  ..y = 1),
                ImageData((b) => b
                  ..image = 'assets/accessories/text.png'
                  ..x = 0
                  ..y = 3),
                ImageData((b) => b
                  ..image = 'assets/accessories/grains.png'
                  ..x = 0
                  ..y = 5),
                ImageData((b) => b
                  ..image = 'assets/accessories/clothes.png'
                  ..x = 3
                  ..y = 0),
                ImageData((b) => b
                  ..image = 'assets/accessories/mic.png'
                  ..x = 1
                  ..y = 0),
                ImageData((b) => b
                  ..image = 'assets/accessories/join.png'
                  ..x = 4
                  ..y = 2),
              ]),
              onGameOver: (_) {},
            ),
          ),
        )
      ];
}
