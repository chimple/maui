import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/connect_dots_game.dart';
import 'package:maui/state/button_state_container.dart';

import 'package:storyboard/storyboard.dart';

class ConnectDotGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
              child: ConnectDotGame(
                serialData: [1,2,3,4,5,6,7,],
                otherData: [10,10,10,10,10,10,10,101,10,10,10],
                onGameOver: (_) {},
              )),
        ),
      ];
}
