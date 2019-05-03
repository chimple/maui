import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/guess_image.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';
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
                imageName: "assets/hospital.jpg",
                imageItemDetails: BuiltList<ImageItemDetail>(
                  [
                    ImageItemDetail((s) => s
                      ..itemName = 'building'
                      ..x = '117'
                      ..y = '461'
                      ..height = '397'
                      ..width = '529'),
                    ImageItemDetail((s) => s
                      ..itemName = 'tree'
                      ..x = '673'
                      ..y = '635'
                      ..height = '214'
                      ..width = '149'),
                    ImageItemDetail((s) => s
                      ..itemName = 'tree'
                      ..x = '673'
                      ..y = '635'
                      ..height = '214'
                      ..width = '149'),
                    ImageItemDetail((s) => s
                      ..itemName = 'hospital'
                      ..x = '895'
                      ..y = '544'
                      ..height = '308'
                      ..width = '434'),
                    ImageItemDetail((s) => s
                      ..itemName = 'car'
                      ..x = '919'
                      ..y = '896'
                      ..height = '119'
                      ..width = '310'),
                    ImageItemDetail((s) => s
                      ..itemName = 'cloud'
                      ..x = '287'
                      ..y = '92'
                      ..height = '150'
                      ..width = '308'),
                    ImageItemDetail((s) => s
                      ..itemName = 'sun'
                      ..x = '1094'
                      ..y = '68'
                      ..height = '150'
                      ..width = '154'),
                    ImageItemDetail((s) => s
                      ..itemName = 'sign'
                      ..x = '238'
                      ..y = '934'
                      ..height = '321'
                      ..width = '146'),
                  ],
                ),
              ),
            ),
          ),
        )
      ];
}
