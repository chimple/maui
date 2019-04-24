import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/store_screen.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/store.dart';
import 'package:storyboard/storyboard.dart';
import 'package:maui/jamaica/models/accessories_data.dart';

class StoreScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(child: Store(list)),
        )
      ];
}
