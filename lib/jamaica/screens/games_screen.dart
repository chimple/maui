import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:data/models/game_config.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/game_list.dart';

final Map<String, List<GameConfig>> _games = {
  'Math Games': [
    GameConfig((b) => b
      ..name = 'Match the shape'
      ..image = 'match_the_shape.svg'
      ..levels = 10),
    GameConfig((b) => b
      ..name = 'Domino Math'
      ..image = 'domino_math.svg'
      ..levels = 10),
    GameConfig((b) => b
      ..name = 'Memory match'
      ..image = 'memory_match.svg'
      ..levels = 10),
    GameConfig((b) => b
      ..name = 'Find the size'
      ..image = 'find_the_size.svg'
      ..levels = 10),
  ],
  'Reading Games': [
    GameConfig((b) => b
      ..name = 'Match the following'
      ..image = 'match_the_following.svg'
      ..levels = 10),
    GameConfig((b) => b
      ..name = 'Alphabet'
      ..image = 'alphabet.svg'
      ..levels = 10),
    GameConfig((b) => b
      ..name = 'Sequence'
      ..image = 'sequence.svg'
      ..levels = 10),
  ],
};

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Games'),
        ),
        body: GameList(
          games: _games,
          gameStatuses: container.state.userProfile.gameStatuses,
        ));
  }
}
