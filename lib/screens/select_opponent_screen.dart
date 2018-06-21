import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'game_category_list_screen.dart';
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
  List<dynamic> _messages;
  List<User> _localUsers = [];
  List<User> _remoteUsers = [];
  List<User> _myTurn = [];
  List<User> _otherTurn = [];
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
    List<dynamic> messages;
    try {
      messages =
          await Flores().getLatestConversations(user.id, widget.gameName);
    } on PlatformException {
      print('Failed getting messages');
    }
    print('_initData: $messages');
    if (!mounted) return;
    setState(() {
      _deviceId = prefs.getString('deviceId');
      _users = users;
      _messages = messages;
      _users.forEach((u) {
        if (u.id == user.id) {
          _user = u;
        } else if (u.deviceId == _deviceId) {
          _localUsers.add(u);
        } else if (messages.any((m) => u.id == m['userId'])) {
          _myTurn.add(u);
        } else if (messages.any((m) => u.id == m['recipientUserId'])) {
          _otherTurn.add(u);
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
            : CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: RaisedButton(
                            onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) =>
                                          GameCategoryListScreen(
                                              game: widget.gameName,
                                              gameMode: GameMode.iterations,
                                              gameDisplay: GameDisplay.single)),
                                ),
                            child: Text('Single Player'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            color: Theme.of(context).primaryColor,
                            child: Text('My Turn')),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return continueGame(context, _myTurn[index],
                          onTap: goToMyTurn);
                    }, childCount: _myTurn.length),
                  ),
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            color: Theme.of(context).primaryColor,
                            child: Text('New local game')),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return convertToFriend(context, _localUsers[index]);
                    }, childCount: _localUsers.length),
                  ),
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            color: Theme.of(context).primaryColor,
                            child: Text('New network game')),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return convertToFriend(context, _remoteUsers[index]);
                    }, childCount: _remoteUsers.length),
                  ),
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            color: Theme.of(context).primaryColor,
                            child: Text('Waiting for Other Turn')),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return continueGame(context, _otherTurn[index]);
                    }, childCount: _otherTurn.length),
                  ),
                ],
              ));
  }

  Widget convertToFriend(BuildContext context, User user, {Function onTap}) {
    return FriendItem(
        id: user.id,
        imageUrl: user.image,
        onTap: () {
          final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
          Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext context) => GameCategoryListScreen(
                    game: widget.gameName,
                    gameMode: GameMode.iterations,
                    gameDisplay: user.id == loggedInUser.id
                        ? GameDisplay.single
                        : user.deviceId == _deviceId
                            ? GameDisplay.localTurnByTurn
                            : GameDisplay.networkTurnByTurn,
                    otherUser: user,
                  )));
        });
  }

  goToMyTurn(BuildContext context, User user) {
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;

    Navigator
        .of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      print('continueGame: ${user.id} $_messages');
      final message = _messages.firstWhere((m) => user.id == m['userId']);
      print('continueGame: message: $message');
      GameConfig gameConfig = GameConfig.fromJson(message['message']);
      gameConfig.myUser = loggedInUser;
      gameConfig.otherUser = user;
      final tempScore = gameConfig.myScore;
      gameConfig.myScore = gameConfig.otherScore;
      gameConfig.otherScore = tempScore;
      final tempIteration = gameConfig.myIteration;
      gameConfig.myIteration = gameConfig.otherIteration;
      gameConfig.otherIteration = tempIteration;
      gameConfig.amICurrentPlayer = true;
      gameConfig.orientation = MediaQuery.of(context).orientation;
      gameConfig.sessionId = message['sessionId'];
      print('continueGame: gameConfig: $gameConfig');
      return SingleGame(
        widget.gameName,
        gameMode: GameMode.iterations,
        gameConfig: gameConfig,
      );
    }));
  }

  Widget continueGame(BuildContext context, User user, {Function onTap}) {
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;

    return FriendItem(
      id: user.id,
      imageUrl: user.image,
      onTap: () => onTap != null ? onTap(context, user) : null,
    );
  }
}
