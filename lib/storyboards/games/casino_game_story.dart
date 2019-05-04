import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/casino_game.dart';
import 'package:storyboard/storyboard.dart';

class CasinoGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: CasinoGame(
              letters: [
                ['A', 'B', 'C', 'D'],
                ['N', 'O', 'P', 'Q'],
                ['T', 'U', 'V', 'W']
              ],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CasinoGame(
              letters: [
                ['O', 'P', 'Q', 'R'],
                ['R', 'S', 'T', 'U'],
                ['A', 'B', 'C', 'D'],
                ['N', 'O', 'P', 'Q'],
                ['G', 'H', 'I', 'J'],
                ['E', 'F', 'G', 'H']
              ],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CasinoGame(
              letters: [
                ['A', 'B', 'C', 'D'],
                ['P', 'Q', 'R', 'S'],
                ['P', 'Q', 'R', 'S'],
                ['L', 'M', 'N', 'O'],
                ['E', 'F', 'G', 'H']
              ],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CasinoGame(
              letters: [
                ['T', 'U', 'V', 'W'],
                ['I', 'J', 'K', 'L'],
                ['G', 'H', 'I', 'J'],
                ['E', 'F', 'G', 'H'],
                ['R', 'S', 'T', 'U'],
              ],
              onGameUpdate: ({int score, int max, bool gameOver, bool star}) {},
            ),
          ),
        ),
      ];
}
