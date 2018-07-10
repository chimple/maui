import 'dart:math';
import 'package:maui/games/single_game.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/db/entity/game_category.dart';
import 'expansionTile.dart';
import 'package:maui/screens/select_opponent_screen.dart';
import 'user_item.dart';
import 'package:maui/repos/concept_repo.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/games/head_to_head_game.dart';

class GameCategoryList extends StatefulWidget {
  GameCategoryList(
      {Key key,
      @required this.gameCategories,
      @required this.game,
      @required this.gameMode,
      @required this.gameDisplay,
      this.otherUser})
      : super(key: key);
  State<StatefulWidget> createState() => new _GameCategoryList();
  final List<Tuple3<int, int, String>> gameCategories;
  final String game;
  GameMode gameMode;
  GameDisplay gameDisplay;
  User otherUser;
}

class _GameCategoryList extends State<GameCategoryList> {
  static final List<Color> colorsCodes = [
    Color(0XFF48AECC),
    Color(0XFFE66796),
    Color(0XFFFF7676),
    Color(0XFFEDC23B),
    Color(0XFFAD85F9),
    Color(0XFF77DB65),
    Color(0XFF66488C),
    Color(0XFFDD6154),
    Color(0XFFFFCE73),
    Color(0XFFD64C60),
    Color(0XFFDD4785),
    Color(0XFF52C5CE),
    Color(0XFFF97658),
    Color(0XFFA46DBA),
    Color(0XFFA292FF),
    Color(0XFFFF8481),
    Color(0XFF35C9C1),
    Color(0XFFEDC23B),
    Color(0XFF42AD56),
    Color(0XFFF47C5D),
    Color(0XFF77DB65),
    Color(0XFF57DBFF),
    Color(0XFFEB706F),
    Color(0XFF48AECC),
    Color(0XFFFFC729),
    Color(0XFF30C9E2),
    Color(0XFFA1EF6F),
  ];
  static final List<Color> tileColors = [];
  int count = 0;
  List<int> conceptid = [];
  List<int> unique = [];
  List<String> name = [];
  Set<int> list;
  Set<int> list1;
  Set<String> list2;
  List<String> listname = [
    'Upper Case Letters',
    'lower Case Letters',
    'Upper Case Letters to Lower Case Letters',
    'word with Upper Case Letters',
    'word with lower Case Letters',
    'concepts'
  ];
  List<Tuple3<int, int, String>> subGroup;
  List<Tuple3<int, int, String>> subGroup1;
  @override
  void initState() {
    super.initState();
    int categoriesLength = widget.gameCategories.length;
    widget.gameCategories
        .map((f) => unique.add(f.item1))
        .toList(growable: false);
    widget.gameCategories
        .map((f) => conceptid.add(f.item2))
        .toList(growable: false);
    widget.gameCategories.map((f) => name.add(f.item3)).toList(growable: false);
    list = Set.from(conceptid);
    print("gameCategories:::::::::::::${widget.gameCategories}");
    subGroup = widget.gameCategories.sublist(0, 6);
    subGroup1 = widget.gameCategories.sublist(3, 30);
    print("Length of categories::$list");
    print("gameCategories================$subGroup");

    print('list name is $listname');
    for (int i = 0; i < categoriesLength + 1; i++) {
      if (count == 26) count = 0;
      tileColors.add(colorsCodes[count]);
      count++;
    }
    print(colorsCodes.length);
    print(tileColors.length);
  }

  @override
  Widget build(BuildContext context) {
    int j = 0;
    Size media = MediaQuery.of(context).size;
    final _colors = SingleGame.gameColors[widget.game];
    final color = _colors != null ? _colors[0] : Colors.amber;
    return new CustomScrollView(
      primary: true,
      shrinkWrap: false,
      slivers: <Widget>[
        new SliverAppBar(
            backgroundColor: color,
            pinned: true,
            expandedHeight: media.height * .37,
            flexibleSpace: new FlexibleSpaceBar(
              background: new FittedBox(
                child: new Hero(
                    tag: 'assets/hoodie/${widget.game}.png',
                    child: new Image.asset(
                      'assets/hoodie/${widget.game}.png',
                      scale: .8,
                    )),
              ),
              centerTitle: true,
              title: new Text(widget.game),
            )),
        new SliverList(
          delegate: new SliverChildListDelegate(new List<Widget>.generate(
            1,
            (int index1) {
              return new Container(
                  alignment: Alignment.center,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: subGroup
                        .map((gameCategory) => Container(
                            color: tileColors[j++],
                            child: gameCategory.item2 == 3 ||
                                    gameCategory.item2 == 4 ||
                                    gameCategory.item2 == 5
                                ? ExpansionTile(
                                    title: new Text(
                                      'A',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 34.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    children: subGroup1
                                        .map((gameCategory) => Container(
                                              child: ListTile(
                                                title: Text(gameCategory.item3),
                                                onTap: () => goToGame(
                                                    context,
                                                    widget.game,
                                                    gameCategory.item1,
                                                    widget.gameDisplay,
                                                    widget.gameMode,
                                                    otherUser:
                                                        widget.otherUser),
                                              ),
                                            ))
                                        .toList(growable: false),
                                  )
                                : FlatButton(
                                    onPressed: () => goToGame(
                                        context,
                                        widget.game,
                                        gameCategory.item1,
                                        widget.gameDisplay,
                                        widget.gameMode,
                                        otherUser: widget.otherUser),
                                    child: Text(gameCategory.item3),
                                  )))
                        .toList(growable: false),
                  ));
            },
          )),
        ),
        new SliverToBoxAdapter(
          child: new Container(height: 2.0, color: Colors.white),
        ),
      ],
    );
  }

  void goToGame(BuildContext context, String gameName, int gameCategoryId,
      GameDisplay gameDisplay, GameMode gameMode,
      {User otherUser}) {
    Random random = new Random();
    var gameConfig = new GameConfig(
        gameCategoryId: gameCategoryId,
        questionUnitMode: UnitMode.values[random.nextInt(3)],
        answerUnitMode: UnitMode.values[random.nextInt(3)],
        level: random.nextInt(10) + 1);
    print('goToGame: $gameName $gameCategoryId, $gameDisplay, $gameMode');
    switch (gameDisplay) {
      case GameDisplay.single:
        gameMode == GameMode.iterations
            ? Navigator.of(context).push(
                MaterialPageRoute<Null>(builder: (BuildContext context) {
                  gameConfig.gameDisplay = GameDisplay.single;
                  gameConfig.amICurrentPlayer = true;
                  gameConfig.myScore = 0;
                  gameConfig.myUser =
                      AppStateContainer.of(context).state.loggedInUser;
                  gameConfig.otherScore = 0;
                  gameConfig.orientation = MediaQuery.of(context).orientation;
                  return new SingleGame(
                    gameName,
                    gameMode: GameMode.iterations,
                    gameConfig: gameConfig,
                  );
                }),
              )
            : Navigator.of(context).push(
                MaterialPageRoute<Null>(builder: (BuildContext context) {
                  gameConfig.gameDisplay = GameDisplay.single;
                  gameConfig.orientation = MediaQuery.of(context).orientation;
                  gameConfig.myUser =
                      AppStateContainer.of(context).state.loggedInUser;
                  return new SingleGame(
                    gameName,
                    gameMode: GameMode.timed,
                    gameConfig: gameConfig,
                  );
                }),
              );
        break;
      case GameDisplay.localTurnByTurn:
        Navigator.of(context).push(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
            gameConfig.gameDisplay = GameDisplay.localTurnByTurn;
            gameConfig.amICurrentPlayer = true;
            gameConfig.myUser =
                AppStateContainer.of(context).state.loggedInUser;
            gameConfig.otherUser = otherUser;
            gameConfig.myScore = 0;
            gameConfig.otherScore = 0;
            gameConfig.orientation = MediaQuery.of(context).orientation;
            return new SingleGame(
              gameName,
              gameMode: GameMode.iterations,
              gameConfig: gameConfig,
            );
          }),
        );
        break;
      case GameDisplay.networkTurnByTurn:
        Navigator.of(context).push(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
            gameConfig.gameDisplay = GameDisplay.networkTurnByTurn;
            gameConfig.amICurrentPlayer = true;
            gameConfig.myUser =
                AppStateContainer.of(context).state.loggedInUser;
            gameConfig.otherUser = otherUser;
            gameConfig.myScore = 0;
            gameConfig.otherScore = 0;
            gameConfig.orientation = MediaQuery.of(context).orientation;
            return new SingleGame(
              gameName,
              gameMode: GameMode.iterations,
              gameConfig: gameConfig,
            );
          }),
        );
        break;
      case GameDisplay.myHeadToHead:
        gameConfig.orientation = Orientation.landscape;
        gameConfig.myUser = AppStateContainer.of(context).state.loggedInUser;
        gameConfig.otherUser = otherUser;
        gameMode == GameMode.iterations
            ? Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) => new HeadToHeadGame(
                        gameName,
                        gameMode: GameMode.iterations,
                        gameConfig: gameConfig,
                      ),
                ))
            : Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) => new HeadToHeadGame(
                        gameName,
                        gameMode: GameMode.timed,
                        gameConfig: gameConfig,
                      ),
                ));
    }
  }
}
