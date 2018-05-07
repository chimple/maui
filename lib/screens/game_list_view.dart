import 'dart:math';

import 'package:flutter/material.dart';

class GameListView extends StatelessWidget {
  const GameListView({Key key}) : super(key: key);

  Widget _buildButton(BuildContext context, String gameName, String displayName,
      Icon icon, Color color) {
    return new Container(
      color: color,
      child: new Column(
        children: <Widget>[
          new Expanded(
              child: new FlatButton(
                  key: new Key(gameName),
                  child: icon,
                  onPressed: () => showModes(context, gameName))),
          new Text(
            displayName,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media.size);
    final iconSize = min(media.size.width, media.size.height) / 8;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new GridView.count(
        key: new Key('Game_page'),
        primary: false,
        padding: const EdgeInsets.all(4.0),
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        crossAxisCount: media.size.height > media.size.width ? 4 : 6,
        children: <Widget>[

          _buildButton(context, 'reflex', 'Reflex',
              new Icon(Icons.collections, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'order_it', 'order_it',
              new Icon(Icons.cake, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'memory', 'memory',
              new Icon(Icons.camera, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'draw_challenge', 'draw_challenge',
              new Icon(Icons.add_alert, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'abacus', 'abacus',
              new Icon(Icons.image, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'crossword', 'crossword',
              new Icon(Icons.favorite, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'drawing', 'drawing',
              new Icon(Icons.format_paint, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'fill_in_the_blanks', 'fill_in_the_blanks',
              new Icon(Icons.call, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'calculate_numbers', 'calculate_numbers',
              new Icon(Icons.add_circle, size: iconSize), Colors.amberAccent),
          _buildButton(
              context,
              'casino',
              'casino',
              new Icon(Icons.developer_board, size: iconSize),
              Colors.amberAccent),
          _buildButton(
              context,
              'match_the_following',
              'match_the_following',
              new Icon(Icons.assistant_photo, size: iconSize),
              Colors.amberAccent),
          _buildButton(context, 'bingo', 'bingo',
              new Icon(Icons.add_to_queue, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'true_or_false', 'true_or_false',
              new Icon(Icons.arrow_right, size: iconSize), Colors.amberAccent),
          _buildButton(
              context,
              'tables',
              'tables',
              new Icon(Icons.check_box_outline_blank, size: iconSize),
              Colors.amberAccent),
          _buildButton(
              context,
              'identify',
              'identify',
              new Icon(Icons.directions_run, size: iconSize),
              Colors.amberAccent),
          _buildButton(context, 'fill_number', 'fill_number',
              new Icon(Icons.broken_image, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'quiz', 'quiz',
              new Icon(Icons.chevron_left, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'connect_the_dots', 'connect_the_dots',
              new Icon(Icons.wb_sunny, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'tap_home', 'tap_home',
              new Icon(Icons.timer, size: iconSize), Colors.amberAccent),
          _buildButton(
              context,
              'tap_wrong',
              'tap_wrong',
              new Icon(Icons.bluetooth_audio, size: iconSize),
              Colors.amberAccent),
          _buildButton(
              context,
              'guess',
              'guess',
              new Icon(Icons.keyboard_arrow_down, size: iconSize),
              Colors.amberAccent),
          _buildButton(context, 'clue_game', 'clue_game',
              new Icon(Icons.headset, size: iconSize), Colors.amberAccent),
          _buildButton(context, 'wordgrid', 'wordgrid',
              new Icon(Icons.android, size: iconSize), Colors.amberAccent),
          _buildButton(
              context,
              'spin_wheel',
              'spin_wheel',
              new Icon(Icons.sentiment_very_satisfied, size: iconSize),
              Colors.amberAccent),
          _buildButton(
              context,
              'first_word',
              'first_word',
              new Icon(Icons.child_friendly, size: iconSize),
              Colors.amberAccent),
          _buildButton(
              context,
              'friend_word',
              'friend_word',
              new Icon(Icons.voice_chat, size: iconSize),
              Colors.amberAccent),
        ]);
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}
