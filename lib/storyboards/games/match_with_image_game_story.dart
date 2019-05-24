import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/match_with_image_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class MatchWithImageGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MatchWithImageGame(
              // images: BuiltList<DisplayItem>([
              //   'assets/accessories/apple.png',
              //   'assets/accessories/camera.png',
              //   'assets/accessories/fruit.png'
              // ]),
              choices: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'Camera'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Fruit'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Apple'
                    ..displayType = DisplayTypeEnum.word,
                ),

                // 'Camera',
                // 'Fruit',
                // 'Apple',
              ]),
              answers: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = 'Apple'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Camera'
                    ..displayType = DisplayTypeEnum.word,
                ),
                DisplayItem(
                  (d) => d
                    ..item = 'Fruit'
                    ..displayType = DisplayTypeEnum.word,
                ),

                // 'Apple',
                // 'Camera',
                // 'Fruit',
              ]),
            ),
          ),
        ),
      ];
}
