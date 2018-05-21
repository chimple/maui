import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';

class GameListView extends StatelessWidget {
  const GameListView({Key key}) : super(key: key);

  Widget _buildButton(
      BuildContext context, String gameName, String displayName) {
    MediaQueryData media = MediaQuery.of(context);
    final colors = SingleGame.gameColors[gameName];
    final color = colors != null ? colors[0] : Colors.amber;
    var size = media.size;
    return new Container(
      decoration: new BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
      ),
      margin: EdgeInsets.all(size.width * .02),
      child: new InkWell(
        onTap: () => showModes(context, gameName),
        key: new Key(gameName),
        child: new Column(
          children: <Widget>[
            new Expanded(
                child: Align(
                    child: new Hero(
              tag: 'assets/hoodie/$gameName.png',
              child: Image.asset('assets/hoodie/$gameName.png', scale: 0.3),
            ))),
            new Container(
                padding: EdgeInsets.all(size.width * .01),
                decoration: new BoxDecoration(
                  color: Colors.black38,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: const Radius.circular(16.0),
                      bottomRight: const Radius.circular(16.0)),
                ),
                child: new Center(
                    child: new Text(
                  displayName,
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    final iconSize = min(media.size.width, media.size.height) / 8;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    final gap = 16.0 * min(media.size.width, media.size.height) / 400.0;
    return new GridView.count(
        key: new Key('Game_page'),
        primary: true,
        padding: const EdgeInsets.all(12.0),
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        crossAxisCount: media.size.height > media.size.width ? 3 : 4,
        children: <Widget>[
          _buildButton(context, 'reflex', 'Reflex'),
          _buildButton(context, 'order_it', 'order_it'),
          _buildButton(context, 'memory', 'memory'),
          _buildButton(context, 'draw_challenge', 'draw_challenge'),
          _buildButton(context, 'abacus', 'abacus'),
          _buildButton(context, 'crossword', 'crossword'),
          _buildButton(context, 'drawing', 'drawing'),
          _buildButton(context, 'fill_in_the_blanks', 'fill_in_the_blanks'),
          _buildButton(context, 'calculate_numbers', 'calculate_numbers'),
          _buildButton(context, 'casino', 'casino'),
          _buildButton(context, 'match_the_following', 'match_the_following'),
          _buildButton(context, 'bingo', 'bingo'),
          _buildButton(context, 'true_or_false', 'true_or_false'),
          _buildButton(context, 'tables', 'tables'),
          _buildButton(context, 'identify', 'identify'),
          _buildButton(context, 'fill_number', 'fill_number'),
          _buildButton(context, 'quiz', 'quiz'),
          _buildButton(context, 'connect_the_dots', 'connect_the_dots'),
          _buildButton(context, 'tap_home', 'tap_home'),
          _buildButton(context, 'tap_wrong', 'tap_wrong'),
          _buildButton(context, 'guess', 'guess'),
          _buildButton(context, 'clue_game', 'clue_game'),
          _buildButton(context, 'wordgrid', 'wordgrid'),
          _buildButton(context, 'spin_wheel', 'spin_wheel'),
          _buildButton(context, 'first_word', 'first_word'),
          _buildButton(context, 'friend_word', 'friend_word'),
          _buildButton(context, 'dice', 'dice'),
        ]);
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}
