import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/game_category.dart';
import 'package:maui/repos/game_category_repo.dart';

class GameCategoryListScreen extends StatefulWidget {
  String game;

  GameCategoryListScreen({Key key, @required this.game}) : super(key: key);

  @override
  _GameCategoryListScreenState createState() {
    return new _GameCategoryListScreenState();
  }
}

class _GameCategoryListScreenState extends State<GameCategoryListScreen> {
  List<GameCategory> _gameCategories;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    new GameCategoryRepo().getGameCategoriesByGame(widget.game).then((gameCategories) {
      setState(() {
        _gameCategories = gameCategories;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _isLoading
          ? new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      )
          : new Text('test'),
      floatingActionButton: new FloatingActionButton(
        key: new ValueKey('add-user'),
        child: new Icon(Icons.add),
        onPressed: () => null,
      ),
    );
  }
}
