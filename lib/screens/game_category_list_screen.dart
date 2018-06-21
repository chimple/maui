import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/game_category.dart';
import 'package:maui/repos/game_category_repo.dart';
import 'package:maui/components/game_category_list.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/db/entity/user.dart';

class GameCategoryListScreen extends StatefulWidget {
  String game;
  GameMode gameMode;
  GameDisplay gameDisplay;
  User otherUser;

  GameCategoryListScreen(
      {Key key,
      @required this.game,
      @required this.gameMode,
      @required this.gameDisplay,
      this.otherUser})
      : super(key: key);

  @override
  _GameCategoryListScreenState createState() {
    return new _GameCategoryListScreenState();
  }
}

class _GameCategoryListScreenState extends State<GameCategoryListScreen> {
  List<Tuple2<int, String>> _gameCategories;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    new GameCategoryRepo()
        .getGameCategoriesByGame(widget.game)
        .then((gameCategories) {
      if (gameCategories.isEmpty) {
        if (widget.game == "identify") {
          gameCategories = <Tuple2<int, String>>[
          new Tuple2<int, String>(1, 'Modes'),
        ];         
        } 
       else if (widget.game == "drawing") {
          gameCategories = <Tuple2<int, String>>[
            new Tuple2<int, String>(2, 'Draw')
          ];
        } else {
          gameCategories = <Tuple2<int, String>>[
            new Tuple2<int, String>(1, 'Todo Placeholder')
          ];
        }
        //   gameCategories = <Tuple2<int, String>>[
        //   new Tuple2<int, String>(1, 'Todo Placeholder')
        // ];
      }

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
            : new Scaffold(
                //appBar: new AppBar(title: new Text('Categories')),
                body: new GameCategoryList(
                  game: widget.game,
                  gameCategories: _gameCategories,
                  gameMode: widget.gameMode,
                  gameDisplay: widget.gameDisplay,
                  otherUser: widget.otherUser,
                ),
              ));
  }
}
