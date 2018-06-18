import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:flores/flores.dart';

class SelectOpponentScreen extends StatefulWidget {
  final String gameName;
  final int gameCategoryId;
  const SelectOpponentScreen({Key key, this.gameName, this.gameCategoryId})
      : super(key: key);

  @override
  _SelectOpponentScreenState createState() {
    return new _SelectOpponentScreenState();
  }
}

class _SelectOpponentScreenState extends State<SelectOpponentScreen> {
  List<User> _users;
  List<User> _localUsers = [];
  List<User> _remoteUsers = [];
  User _user;
  String _deviceId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    var user = AppStateContainer.of(context).state.loggedInUser;
    List<User> users;
    users = await UserRepo().getUsers();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _deviceId = prefs.getString('deviceId');
      _users = users;
      _users.forEach((u) {
        if (u.id == user.id) {
          _user = u;
        } else if (u.deviceId == _deviceId) {
          _localUsers.add(u);
        } else {
          _remoteUsers.add(u);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Select Opponent"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: (_user == null)
            ? new Center(
                child: new SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(),
              ))
            : GridView.count(
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                crossAxisCount: media.size.height > media.size.width ? 3 : 4,
                children: _users
                    .map((u) => convertToFriend(context, u))
                    .toList(growable: false)));
  }

  Widget convertToFriend(BuildContext context, User user) {
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;

    return FriendItem(
      id: user.id,
      imageUrl: user.image,
      onTap: () {
        user.id == loggedInUser.id
            ? goToGame(context, widget.gameName, widget.gameCategoryId,
                GameDisplay.single, GameMode.iterations)
            : user.deviceId == _deviceId
                ? goToGame(context, widget.gameName, widget.gameCategoryId,
                    GameDisplay.localTurnByTurn, GameMode.iterations,
                    otherUser: user)
                : goToGame(context, widget.gameName, widget.gameCategoryId,
                    GameDisplay.networkTurnByTurn, GameMode.iterations,
                    otherUser: user);
      },
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
