import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/guess_image.dart';
import 'package:maui/widgets/dot_number.dart';
import 'package:maui/models/image_label_data.dart';
import 'package:storyboard/storyboard.dart';

class GuessImageStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: GuessImage(
                onGameUpdate: (
                    {int score, int max, bool gameOver, bool star}) {},
                imageName: "assets/temp/hospital.jpg",
                imageItemDetails: BuiltList<ImageItemDetail>(
                  [
                    ImageItemDetail((s) => s
                      ..itemName = 'building'
                      ..x = 117
                      ..y = 461
                      ..height = 397
                      ..width = 529),
                    ImageItemDetail((s) => s
                      ..itemName = 'tree'
                      ..x = 673
                      ..y = 635
                      ..height = 214
                      ..width = 149),
                    ImageItemDetail((s) => s
                      ..itemName = 'hospital'
                      ..x = 895
                      ..y = 544
                      ..height = 308
                      ..width = 434),
                    ImageItemDetail((s) => s
                      ..itemName = 'car'
                      ..x = 919
                      ..y = 896
                      ..height = 119
                      ..width = 310),
                    ImageItemDetail((s) => s
                      ..itemName = 'cloud'
                      ..x = 287
                      ..y = 92
                      ..height = 150
                      ..width = 308),
                    ImageItemDetail((s) => s
                      ..itemName = 'sun'
                      ..x = 1094
                      ..y = 68
                      ..height = 150
                      ..width = 154),
                    ImageItemDetail((s) => s
                      ..itemName = 'sign'
                      ..x = 238
                      ..y = 934
                      ..height = 321
                      ..width = 146),
                  ],
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: GuessImage(
                onGameUpdate: (
                    {int score, int max, bool gameOver, bool star}) {},
                imageName: "assets/topic/asb/26425.png",
                imageItemDetails: BuiltList<ImageItemDetail>(
                  [
                    ImageItemDetail((s) => s
                      ..itemName = 'Bird'
                      ..x = 62
                      ..y = 65
                      ..height = 110
                      ..width = 57),
                    ImageItemDetail((s) => s
                      ..itemName = 'Hen'
                      ..x = 129
                      ..y = 304
                      ..height = 188
                      ..width = 144),
                    ImageItemDetail((s) => s
                      ..itemName = 'Girl'
                      ..x = 320
                      ..y = 129
                      ..height = 245
                      ..width = 207),
                    ImageItemDetail((s) => s
                      ..itemName = 'House'
                      ..x = 135
                      ..y = 187
                      ..height = 83
                      ..width = 141),
                  ],
                ),
              ),
            ),
          ),
        ),
    Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: GuessImage(
            onGameUpdate: (
                {int score, int max, bool gameOver, bool star}) {},
            imageName: "assets/topic/asb/13837.png",
            imageItemDetails: BuiltList<ImageItemDetail>(
              [
                ImageItemDetail((s) => s
                  ..itemName = 'Bag'
                  ..x = 67
                  ..y = 119
                  ..height = 137
                  ..width = 73),
                ImageItemDetail((s) => s
                  ..itemName = 'Slippers'
                  ..x = 22
                  ..y = 404
                  ..height = 47
                  ..width = 76),
                ImageItemDetail((s) => s
                  ..itemName = 'Box'
                  ..x = 364
                  ..y = 374
                  ..height = 162
                  ..width = 156),
                ImageItemDetail((s) => s
                  ..itemName = 'Girl'
                  ..x = 152
                  ..y = 211
                  ..height = 256
                  ..width = 137),
                ImageItemDetail((s) => s
                  ..itemName = 'window'
                  ..x = 328
                  ..y = 99
                  ..height = 163
                  ..width = 165),
                ImageItemDetail((s) => s
                  ..itemName = 'lamp'
                  ..x = 222
                  ..y = 467
                  ..height = 61
                  ..width = 47),
              ],
            ),
          ),
        ),
      ),
    ),
      ];
}
