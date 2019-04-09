import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/match_with_image_game.dart';
import 'package:storyboard/storyboard.dart';

class MatchWithImageGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MatchWithImageGame(
              images: BuiltList<String>([
                'assets/accessories/apple.png',
                'assets/accessories/camera.png',
                'assets/accessories/fruit.png'
              ]),
              choices: BuiltList<String>([
                'Camera',
                'Fruit',
                'Apple',
              ]),
              answers: BuiltList<String>([
                'Apple',
                'Camera',
                'Fruit',
              ]),
            ),
          ),
        ),
      ];
}
