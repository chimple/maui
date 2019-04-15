import 'package:flutter/material.dart';
import 'package:storyboard/storyboard.dart';
import 'package:maui/screens/progress_screen.dart';


class ProgressScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
    Scaffold(
      body: SafeArea(
        child: ProgressScreen(),
      ),
    ),
  ];
}