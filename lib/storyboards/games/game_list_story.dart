import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/game_list.dart';
import 'package:storyboard/storyboard.dart';

class GameListStory extends FullScreenStory {
  @override
  List<Widget> get storyContent =>
      [Scaffold(body: SafeArea(child: GameList()))];
}
