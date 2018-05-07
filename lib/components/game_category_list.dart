import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/db/entity/game_category.dart';
import 'user_item.dart';

class GameCategoryList extends StatelessWidget {
  final List<Tuple2<int, String>> gameCategories;
  final String game;

  GameCategoryList(
      {Key key, @required this.gameCategories, @required this.game})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView(
        key: new Key('game-category-list'),
        primary: false,
        children: gameCategories
            .map((gameCategory) => new RaisedButton(
                  key: new Key('${gameCategory.item2}'),
                  child: new Text(gameCategory.item2),
                  onPressed: () => showModes(context, game, gameCategory.item1),
                ))
            .toList());
  }

  showModes(BuildContext context, String game, int id) async {
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
                            key: new Key('single'),
                            icon: new Icon(Icons.accessibility),
                            onPressed: () =>
                                Navigator.of(context).pop('single_iterations')),
                        new IconButton(
                            key: new Key('singletimed'),
                            icon: new Icon(Icons.alarm),
                            onPressed: () =>
                                Navigator.of(context).pop('single_timed')),
                        new IconButton(
                            key: new Key('h2h'),
                            icon: new Icon(Icons.people),
                            onPressed: () =>
                                Navigator.of(context).pop('h2h_iterations')),
                        new IconButton(
                            key: new Key('h2htimed'),
                            icon: new Icon(Icons.av_timer),
                            onPressed: () =>
                                Navigator.of(context).pop('h2h_timed')),
                      ])));
        });
    if (selected.isNotEmpty)
      Navigator.of(context).pushNamed('/games/$game/categories/$id/$selected');
  }
}
