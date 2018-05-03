import 'dart:math';

import 'package:flutter/material.dart';

class GameListView extends StatelessWidget {
  const GameListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media.size);
    final iconSize = min(media.size.width, media.size.height) / 8;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new GridView.count(
        key: new Key('Game_page'),
        primary: false,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        crossAxisCount: media.size.height > media.size.width ? 4 : 6,
        children: <Widget>[
          new RaisedButton(
              key: new Key('reflex'),
              child: new Icon(Icons.collections, size: iconSize),
              onPressed: () => showModes(context, 'reflex')),
          new RaisedButton(
              key: new Key('orderit'),
              child: new Icon(Icons.cake, size: iconSize),
              onPressed: () => showModes(context, 'order_it')),
          new RaisedButton(
              key: new Key('memory'),
              child: new Icon(Icons.camera, size: iconSize),
              onPressed: () => showModes(context, 'memory')),
          new RaisedButton(
              key: new Key('draw_challenge'),
              child: new Icon(Icons.add_alert, size: iconSize),
              onPressed: () => showModes(context, 'draw_challenge')),
          new RaisedButton(
              key: new Key('abacus'),
              child: new Icon(Icons.image, size: iconSize),
              onPressed: () => showModes(context, 'abacus')),
          new RaisedButton(
              key: new Key('crossword'),
              child: new Icon(Icons.favorite, size: iconSize),
              onPressed: () => showModes(context, 'crossword')),
          new RaisedButton(
              key: new Key('drawing'),
              child: new Icon(Icons.format_paint, size: iconSize),
              onPressed: () => showModes(context, 'drawing')),
          new RaisedButton(
              key: new Key('fill_in_the_blanks'),
              child: new Icon(Icons.call, size: iconSize),
              onPressed: () => showModes(context, 'fill_in_the_blanks')),
          new RaisedButton(
              key: new Key('calculate_numbers'),
              child: new Icon(Icons.add_circle, size: iconSize),
              onPressed: () => showModes(context, 'calculate_numbers')),
          new RaisedButton(
              key: new Key('casino'),
              child: new Icon(Icons.developer_board, size: iconSize),
              onPressed: () => showModes(context, 'casino')),
          new RaisedButton(
              key: new Key('match_the_following'),
              child: new Icon(Icons.assistant_photo, size: iconSize),
              onPressed: () => showModes(context, 'match_the_following')),
          new RaisedButton(
              key: new Key('bingo'),
              child: new Icon(Icons.add_to_queue, size: iconSize),
              onPressed: () => showModes(context, 'bingo')),
          new RaisedButton(
              key: new Key('true_or_false'),
              child: new Icon(Icons.arrow_right, size: iconSize),
              onPressed: () => showModes(context, 'true_or_false')),
          new RaisedButton(
              key: new Key('tables'),
              child: new Icon(Icons.check_box_outline_blank, size: iconSize),
              onPressed: () => showModes(context, 'tables')),
          new RaisedButton(
              key: new Key('identify'),
              child: new Icon(Icons.directions_run, size: iconSize),
              onPressed: () => showModes(context, 'identify')),
          new RaisedButton(
              key: new Key('fill_number'),
              child: new Icon(Icons.broken_image, size: iconSize),
              onPressed: () => showModes(context, 'fill_number')),
          new RaisedButton(
              key: new Key('quiz'),
              child: new Icon(Icons.chevron_left, size: iconSize),
              onPressed: () => showModes(context, 'quiz')),
          new RaisedButton(
              key: new Key('connect_the_dots'),
              child: new Icon(Icons.wb_sunny, size: iconSize),
              onPressed: () => showModes(context, 'connect_the_dots')),
          new RaisedButton(
              key: new Key('tap_home'),
              child: new Icon(Icons.timer, size: iconSize),
              onPressed: () => showModes(context, 'tap_home')),
          new RaisedButton(
              key: new Key('tap_wrong'),
              child: new Icon(Icons.bluetooth_audio, size: iconSize),
              onPressed: () => showModes(context, 'tap_wrong')),
          new RaisedButton(
              key: new Key('guess'),
              child: new Icon(Icons.keyboard_arrow_down, size: iconSize),
              onPressed: () => showModes(context, 'guess')),
          new RaisedButton(
              key: new Key('clue_game'),
              child: new Icon(Icons.headset, size: iconSize),
              onPressed: () => showModes(context, 'clue_game')),
          new RaisedButton(
              key: new Key('wordgrid'),
              child: new Icon(Icons.android, size: iconSize),
              onPressed: () => showModes(context, 'wordgrid')),
          new RaisedButton(
              key: new Key('spin_wheel'),
              child: new Icon(Icons.sentiment_very_satisfied, size: iconSize),
              onPressed: () => showModes(context, 'spin_wheel')),
          new RaisedButton(
              key: new Key('first_word'),
              child: new Icon(Icons.child_friendly, size: iconSize),
              onPressed: () => showModes(context, 'first_word')),
        ]);
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}
