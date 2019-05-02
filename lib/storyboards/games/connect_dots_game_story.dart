import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/connect_dots_game.dart';
import 'package:maui/state/button_state_container.dart';

import 'package:storyboard/storyboard.dart';

class ConnectDotGameStroy extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
              child: ConnectDotGame(
                serialData: ['1', '2', '3', '4', '5', '6', '7'],
                otherData: ['10', '13', '11', '14', '18', '10', '12', '12', '9'],
                onGameOver: (_) {},
              )),
        ),
      ];
}
