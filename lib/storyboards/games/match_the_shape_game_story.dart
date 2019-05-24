import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/games/match_the_shape_game.dart';
import 'package:maui/models/display_item.dart';
import 'package:storyboard/storyboard.dart';

class MatchTheShapeGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: MatchTheShapeGame(
              first: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = '1'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = '2'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = '3'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = '4'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                // '1', '2', '3', '4'
              ]),
              second: BuiltList<DisplayItem>([
                DisplayItem(
                  (d) => d
                    ..item = '1'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = '2'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = '3'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                DisplayItem(
                  (d) => d
                    ..item = '4'
                    ..displayType = DisplayTypeEnum.letter,
                ),
                // '1', '2', '3', '4'
              ]),
            ),
          ),
        )
      ];
}
