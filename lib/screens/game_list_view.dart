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
              child: new Icon(Icons.collections, size: 64.0),
              onPressed: () => showModes(context, 'reflex')),
          new RaisedButton(
              child: new Icon(Icons.cake, size: 64.0),
              onPressed: () =>showModes(context, 'order_it')),
          new RaisedButton(
              child: new Icon(Icons.camera, size: 64.0),
              onPressed: () => showModes(context, 'memory')),
          new RaisedButton(
              child: new Icon(Icons.image, size: 64.0),
              onPressed: () => showModes(context, 'abacus')),
          new RaisedButton(
              child: new Icon(Icons.favorite, size: 64.0),
              onPressed: () => showModes(context, 'crossword')),
          new RaisedButton(
              child: new Icon(Icons.adjust, size: 64.0),
              onPressed: () =>showModes(context, 'drawing')),
          new RaisedButton(
              child: new Icon(Icons.call, size: 64.0),
              onPressed: () => showModes(context, 'fill_in_the_blanks')),
          new RaisedButton(
              child: new Icon(Icons.add_circle, size: 64.0),
              onPressed: () => showModes(context, 'calculate_numbers')),
          new RaisedButton(
              child: new Icon(Icons.airline_seat_legroom_extra, size: 64.0),
              onPressed: () => showModes(context, 'casino')),
          new RaisedButton(
              child: new Icon(Icons.assistant_photo, size: 64.0),
              onPressed: () =>showModes(context, 'match_the_following')),
          new RaisedButton(
              child: new Icon(Icons.add_to_queue, size: 64.0),
              onPressed: () => showModes(context, 'bingo')),
          new RaisedButton(
              child: new Icon(Icons.arrow_right, size: 64.0),
              onPressed: () => showModes(context, 'true_or_false')),
          new RaisedButton(
              child: new Icon(Icons.check_box_outline_blank, size: 64.0),
              onPressed: () => showModes(context, 'tables')),
          new RaisedButton(
              child: new Icon(Icons.directions_run, size: 64.0),
              onPressed: () => showModes(context, 'identify')),
          new RaisedButton(
              child: new Icon(Icons.broken_image, size: 64.0),
              onPressed: () => showModes(context, 'fill_number'))
        ]);
  }

  showModes(BuildContext context, String game) async {
    String selected = await showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          print(Navigator.of(context).toString());
          return new Container(
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new IconButton(
                            icon: new Icon(Icons.alarm),
                            onPressed: () => Navigator.of(context).pop('h2h')),
                        new IconButton(
                            icon: new Icon(Icons.cake),
                            onPressed: () => Navigator.of(context).pop('single')),
                      ])));
        });
    switch(selected) {
      case 'h2h':
        Navigator.of(context).pushNamed('/games/$game/h2h');
        break;
      case 'single':
        Navigator.of(context).pushNamed('/games/$game/single');
        break;
    }
  }

}
