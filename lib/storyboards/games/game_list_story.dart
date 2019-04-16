import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/models/game_config.dart';
import 'package:maui/jamaica/widgets/game_list.dart';
import 'package:storyboard/storyboard.dart';

class GameListStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
            body: SafeArea(
                child: GameList(games: {
          'Literacy': {
            'Math Games': [
              GameConfig((b) => b
                ..name = 'Match the shape'
                ..image = 'match_the_shape.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Domino Math'
                ..image = 'domino_math.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Memory match'
                ..image = 'memory_match.png'
                ..levels = 10),
            ],
            'Reading Games': [
              GameConfig((b) => b
                ..name = 'Match the following'
                ..image = 'match_the_following.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Alphabet'
                ..image = 'alphabet.png'
                ..levels = 10),
            ],
            // 'Writing Games': [
            //   GameConfig((b) => b
            //     ..name = 'Match the following'
            //     ..image = 'match_the_following.png'
            //     ..levels = 10),
            //   GameConfig((b) => b
            //     ..name = 'Alphabet'
            //     ..image = 'alphabet.png'
            //     ..levels = 10),
            //   GameConfig((b) => b
            //     ..name = 'Match the following'
            //     ..image = 'match_the_following.png'
            //     ..levels = 10),
            //   GameConfig((b) => b
            //     ..name = 'Alphabet'
            //     ..image = 'alphabet.png'
            //     ..levels = 10),
            // ],
          },
          'Math': {
            'Math Games': [
              GameConfig((b) => b
                ..name = 'Match the shape'
                ..image = 'match_the_shape.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Domino Math'
                ..image = 'domino_math.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Memory match'
                ..image = 'memory_match.png'
                ..levels = 10),
            ],
            'Reading Games': [
              GameConfig((b) => b
                ..name = 'Match the following'
                ..image = 'match_the_following.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Alphabet'
                ..image = 'alphabet.png'
                ..levels = 10),
            ],
          },
          'Writing': {
            'Math Games': [
              GameConfig((b) => b
                ..name = 'Match the shape'
                ..image = 'match_the_shape.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Domino Math'
                ..image = 'domino_math.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Memory match'
                ..image = 'memory_match.png'
                ..levels = 10),
            ],
            'Reading Games': [
              GameConfig((b) => b
                ..name = 'Match the following'
                ..image = 'match_the_following.png'
                ..levels = 10),
              GameConfig((b) => b
                ..name = 'Alphabet'
                ..image = 'alphabet.png'
                ..levels = 10),
            ],
          }
        })))
      ];
}
