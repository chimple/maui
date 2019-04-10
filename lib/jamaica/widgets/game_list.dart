import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/game_config.dart';
import 'package:maui/models/game_status.dart';
import 'package:maui/jamaica/screens/game_level.dart';

enum _ButtonStatus { active, disabled }

class GameList extends StatefulWidget {
  final Map<String, List<GameConfig>> games;
  final BuiltMap<String, GameStatus> gameStatuses;
  const GameList({Key key, this.games, this.gameStatuses}) : super(key: key);

  @override
  GameListState createState() {
    return new GameListState();
  }
}

class GameListState extends State<GameList> {
  String gameToOpen = '';
  GameConfig gameConfig;
  bool isComplete = false;

  void _onTap(GameConfig gameConfig) {
    setState(() {
      gameToOpen = gameConfig.name;
      this.gameConfig = gameConfig;
    });
  }

  void _flareCallback(String animationNme) {
    setState(() {
      isComplete = true;
    });

    List gamelevel = [];
    for (int i = 1; i <= gameConfig.levels; i++) {
      gamelevel.add(i);
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GameLevel(
            gameName: gameToOpen,
            levelList: gamelevel,
            gameImage: gameConfig.image,
          );
        }).then((onValue) => setState(() {
          gameToOpen = '';
          isComplete = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final _isPortrait = media.size.width < media.size.height;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Container(
        color: Colors.blueGrey[300],
        child: Stack(children: [
          FlareActor("assets/map/map_background2.flr",
              alignment: Alignment.center,
              fit: _isPortrait ? BoxFit.fitHeight : BoxFit.fitWidth,
              isPaused: isComplete,
              animation: "bird"),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.games.length,
              itemBuilder: (_, int index) {
                var categoryName = widget.games.keys.toList()[index];
                var gameConfig = widget.games.values.toList()[index];

                return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          constraints: BoxConstraints(
                              maxHeight: _isPortrait
                                  ? media.size.height * .08
                                  : media.size.height * .15),
                          padding: EdgeInsets.only(
                              left: 12 + media.size.width * .02, bottom: 10),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                categoryName,
                                //Loca.of(context).intl(categoryName),
                                style: new TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: _isPortrait
                                      ? media.size.height * .03
                                      : media.size.width * .03,
                                ),
                              ))),
                      Container(
                        constraints:
                            BoxConstraints(maxHeight: media.size.height * 100),
                        child: new GridView.count(
                          shrinkWrap: true,
                          key: new Key('Game_page'),
                          physics: NeverScrollableScrollPhysics(),
                          primary: true,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          crossAxisCount: _isPortrait ? 3 : 4,
                          children: gameConfig
                              .map((t) => GameButton(
                                    t,
                                    onTap: _onTap,
                                    flareCallback: _flareCallback,
                                    animationFlag:
                                        t.name == gameToOpen ? true : false,
                                    buttonStatus: gameToOpen != ''
                                        ? _ButtonStatus.disabled
                                        : _ButtonStatus.active,
                                  ))
                              .toList(growable: false),
                        ),
                      ),
                    ]);
              }),
        ]));
  }
}

class GameButton extends StatelessWidget {
  final GameConfig gameConfig;

  final void Function(GameConfig) onTap;
  final bool animationFlag;
  final void Function(String) flareCallback;
  final _ButtonStatus buttonStatus;

  const GameButton(this.gameConfig,
      {Key key,
      this.onTap,
      this.animationFlag,
      this.buttonStatus,
      this.flareCallback})
      : super(key: key);

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    final iconSize = min(media.size.width, media.size.height) / 33;

    return new Container(
      decoration: new BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
      ),
      margin: EdgeInsets.symmetric(horizontal: size.width * .02),
      child: new InkWell(
        onTap: buttonStatus == _ButtonStatus.active
            ? () => onTap(gameConfig)
            : null,
        key: new Key(gameConfig.name),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff9309c6),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: FlareActor("assets/character/button.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      callback: flareCallback,
                      isPaused: !animationFlag,
                      animation: animationFlag ? "correct" : "idle"),
                ),
              ),
            ),
            new Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(gameConfig.name,
                    // Text(Loca.of(context).intl(gameConfig.name),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: new TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: iconSize,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis))
          ],
        ),
      ),
    );
  }
}
