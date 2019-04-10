import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/theme_map.dart';
import 'package:storyboard/storyboard.dart';

class ThemeMapStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: ThemeMap(),
          ),
        )
      ];
}
