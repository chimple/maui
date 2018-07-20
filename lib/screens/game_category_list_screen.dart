import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/concept.dart';
import 'package:maui/db/entity/game_category.dart';
import 'package:maui/repos/game_category_repo.dart';
import 'package:maui/components/game_category_list.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/concept_repo.dart';

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
  List<Tuple4<int, int, String,int>> _gameCategories;
  List<Concept> _concepts;
  Map<int, Concept> _conceptMap;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    new GameCategoryRepo()
        .getGameCategoriesByGame(widget.game)
        .then((gameCategories) async {
      if (gameCategories.isEmpty) {
        if (widget.game == "identify") {
          gameCategories = <Tuple4<int, int, String, int>>[
            new Tuple4<int, int, String, int>(1, 1, 'Modes', 1),
          ];
        } else if (widget.game == "drawing") {
          gameCategories = <Tuple4<int, int, String, int>>[
            new Tuple4<int, int, String, int>(2, 1, 'Draw', 1)
          ];
        } else {
          gameCategories = <Tuple4<int, int, String, int>>[
            new Tuple4<int, int, String, int>(1, 1, 'Todo Placeholder', 1)
          ];
        }
        //   gameCategories = <Tuple2<int, String>>[
        //   new Tuple2<int, String>(1, 'Todo Placeholder')
        // ];
      }

      List<Concept> concepts = await ConceptRepo.conceptDao.getConcepts();
      Map<int, Concept> conceptMap = Map<int, Concept>();
      concepts.forEach((c) => conceptMap[c.id] = c);
      setState(() {
        _gameCategories = gameCategories;
        _isLoading = false;
        _concepts = concepts;
        _conceptMap = conceptMap;
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
                  concepts: _conceptMap,
                  game: widget.game,
                  gameCategories: _gameCategories,
                  gameMode: widget.gameMode,
                  gameDisplay: widget.gameDisplay,
                  otherUser: widget.otherUser,
                ),
              ));
  }
}
