import 'package:flutter/material.dart';
import 'package:maui/util/accessories_data.dart';
import 'package:maui/jamaica/widgets/store.dart';
import 'package:storyboard/storyboard.dart';

class StoreScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(child: Store(list)),
        )
      ];
}
