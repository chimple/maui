import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/games/spin_wheel_game.dart';
import 'package:storyboard/storyboard.dart';

class SpinWheelGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: SpinWheelGame(
              data: {
                'U': 'U',
                'Z': 'Z',
                'R': 'R',
                'J': 'J',
                'O': 'O',
                'W': 'W'
              },
              dataSize: 6,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: SpinWheelGame(
              data: {
                'U': 'U',
                'Z': 'Z',
                'R': 'R',
                'J': 'J',
              },
              dataSize: 4,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: SpinWheelGame(
              data: {
                'U': 'U',
                'Z': 'Z',
                'R': 'R',
                'J': 'J',
                'O': 'O',
                'W': 'W',
                'N': 'N',
                'M': 'M'
              },
              dataSize: 8,
            ),
          ),
        )
      ];
}
