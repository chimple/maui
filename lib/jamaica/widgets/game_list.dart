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
  final Map<String, Map<String, List<GameConfig>>> games;
  final BuiltMap<String, GameStatus> gameStatuses;
  final int score;
  const GameList({Key key, this.games, this.gameStatuses, this.score = 4})
      : super(key: key);

  @override
  GameListState createState() {
    return new GameListState();
  }
}

class GameListState extends State<GameList>
    with SingleTickerProviderStateMixin {
  String gameToOpen = '';
  GameConfig gameConfig;
  bool isComplete = false;
  TabController _tabController;

  List data;
  @override
  void initState() {
    super.initState();
    data = widget.games.values.toList();
    _tabController = new TabController(vsync: this, length: 3);
  }

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget tabBarView(data, MediaQueryData media, bool _isPortrait) {
    List<GameConfig> gameConfig = [];
    for (int i = 0; i < data.values.length; i++) {
      gameConfig.addAll(data.values.toList()[i]);
    }
    return FractionallySizedBox(
        widthFactor: .7,
        child: ListView(
          shrinkWrap: true,
          children: gameConfig
              .map((t) => GameButton(
                    t,
                    score: widget.score,
                    onTap: _onTap,
                    flareCallback: _flareCallback,
                    animationFlag: t.name == gameToOpen ? true : false,
                    buttonStatus: gameToOpen != ''
                        ? _ButtonStatus.disabled
                        : _ButtonStatus.active,
                  ))
              .toList(growable: false),
        ));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final double height = media.size.height;
    final double width = media.size.width;
    final _isPortrait = width < height;
    return Stack(alignment: Alignment.center, children: [
      Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: widget.games.values
                    .map((f) => tabBarView(f, media, _isPortrait))
                    .toList()),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: _isPortrait ? height * .1 : height * .18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[400], Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  indicatorWeight: 7,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.menu),
                      text: 'Litereacy',
                    ),
                    Tab(
                      icon: Icon(Icons.search),
                      text: 'Math',
                    ),
                    Tab(
                      icon: Icon(Icons.access_time),
                      text: 'Writing',
                    ),
                  ],
                  controller: _tabController,
                )),
          ),
        ],
      )
    ]);
  }
}

class GameButton extends StatelessWidget {
  final GameConfig gameConfig;

  final void Function(GameConfig) onTap;
  final bool animationFlag;
  final void Function(String) flareCallback;
  final _ButtonStatus buttonStatus;
  final int score;

  const GameButton(this.gameConfig,
      {Key key,
      this.onTap,
      this.score,
      this.animationFlag,
      this.buttonStatus,
      this.flareCallback})
      : super(key: key);

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final iconSize = max(media.size.width, media.size.height) / 42;

    return AspectRatio(
      aspectRatio: 2.1,
      child: Opacity(
        opacity: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.all(media.size.width * .03),
          child: Material(
            color: Colors.transparent,
            elevation: 10.0,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(16.0)),
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange[400], Colors.white],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FlareActor("assets/character/button.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        callback: flareCallback,
                        isPaused: !animationFlag,
                        animation: animationFlag ? "happy" : "idle"),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(gameConfig.name,
                                //  maxLines: 2,
                                // Text(Loca.of(context).intl(gameConfig.name),
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: iconSize,
                                    color: Colors.deepOrange),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Text(
                          'Progress',
                          style: TextStyle(color: Colors.red),
                        ),
                        LinearProgressIndicator(
                          value: score / 5,
                        ),
                        Divider(
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                                color: Colors.orange,
                                child: Text(
                                  'play',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: buttonStatus == _ButtonStatus.active
                                    ? () => onTap(gameConfig)
                                    : () {},
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
