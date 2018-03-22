import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/game_category.dart';
import 'user_item.dart';

class GameCategoryList extends StatelessWidget {
  final List<GameCategory> gameCategories;

  GameCategoryList({Key key, @required this.gameCategories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        key: new Key('game-category-list'),
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: gameCategories
            .map((gameCategory) => new RaisedButton(
              key: new Key('${gameCategory.seq}'),
              child: new Text(gameCategory.name),
              onPressed: null,
        ))
            .toList());
  }
}
