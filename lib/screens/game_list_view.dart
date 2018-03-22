import 'package:flutter/material.dart';

class GameListView extends StatelessWidget {
  const GameListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    print(Navigator.of(context).toString());
    return new GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        crossAxisCount: 2,
        children: <Widget>[
          new RaisedButton(
              key: new Key('reflex'),
              child: new Icon(Icons.collections, size: 64.0),
              onPressed: () => showModes(context, 'reflex')),
          new RaisedButton(
              key: new Key('orderit'),
              child: new Icon(Icons.cake, size: 64.0),
              onPressed: () =>showModes(context, 'order_it')),
          new RaisedButton(
              key: new Key('memory'),
              child: new Icon(Icons.camera, size: 64.0),
              onPressed: () => showModes(context, 'memory')),
          new RaisedButton(
              key: new Key('abacus'),
              child: new Icon(Icons.image, size: 64.0),
              onPressed: () => showModes(context, 'abacus')),
          new RaisedButton(
              key: new Key('crossword'),
              child: new Icon(Icons.favorite, size: 64.0),
              onPressed: () => showModes(context, 'crossword')),
          new RaisedButton(
              key: new Key('drawing'),
              child: new Icon(Icons.adjust, size: 64.0),
              onPressed: () =>showModes(context, 'drawing')),
          new RaisedButton(
              key: new Key('fill_in_the_blancks'),
              child: new Icon(Icons.call, size: 64.0),
              onPressed: () => showModes(context, 'fill_in_the_blanks')),
          new RaisedButton(
              key: new Key('calculate_numbers'),
              child: new Icon(Icons.add_circle, size: 64.0),
              onPressed: () => showModes(context, 'calculate_numbers')),
          new RaisedButton(
              key: new Key('casino'),
              child: new Icon(Icons.airline_seat_legroom_extra, size: 64.0),
              onPressed: () => showModes(context, 'casino')),
          new RaisedButton(
              key: new Key('match_the_following'),
              child: new Icon(Icons.assistant_photo, size: 64.0),
              onPressed: () =>showModes(context, 'match_the_following')),
          new RaisedButton(
              key: new Key('bingo'),
              child: new Icon(Icons.add_to_queue, size: 64.0),
              onPressed: () => showModes(context, 'bingo')),
          new RaisedButton(
              key: new Key('true_or_false'),
              child: new Icon(Icons.arrow_right, size: 64.0),
              onPressed: () => showModes(context, 'true_or_false')),
          new RaisedButton(
              key: new Key('tables'),
              child: new Icon(Icons.check_box_outline_blank, size: 64.0),
              onPressed: () => showModes(context, 'tables')),
          new RaisedButton(
              key: new Key('identify'),
              child: new Icon(Icons.directions_run, size: 64.0),
              onPressed: () => showModes(context, 'identify')),
          new RaisedButton(
              key: new Key('fill_number'),
              child: new Icon(Icons.broken_image, size: 64.0),
              onPressed: () => showModes(context, 'fill_number'))
        ]);
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}
