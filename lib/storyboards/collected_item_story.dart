import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/collected_item_data.dart';
import 'package:maui/jamaica/widgets/collected_item_screen.dart';
import 'package:storyboard/storyboard.dart';

class CollectedItemStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: CollectedItemScreen(
                itemsValue: BuiltMap<String, int>({'a': 0}), staticItems: list),
          ),
        )
      ];
}
