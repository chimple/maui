import 'dart:convert';
import 'dart:math';
import 'package:maui/components/videoplayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:badge/badge.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'game_category_list_screen.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:maui/loca.dart';
import 'package:maui/components/gameaudio.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isLoading = true;
      var user = AppStateContainer.of(context).state.loggedInUser;
      List<User> users;
      users = await UserRepo().getUsers();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<dynamic> messages;
      try {
        messages = await p2p.getLatestConversations(user.id, widget.gameName);
      } on PlatformException {
        print('Failed getting messages');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }

      print('_initData: $messages');

      if (!mounted) return;
      setState(() {
        _deviceId = prefs.getString('deviceId');
        _users = users;
        _messages = messages;
        _localUsers.add(user);
        _users.forEach((u) {
          if (u.id == user.id || u.id == User.botId) {
            //no op
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
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    print(
        "height and width of  opponent is ${mediaSize.width}....${mediaSize.height}");
    final _colors = SingleGame.gameColors[widget.gameName];
    final color = _colors != null ? _colors[0] : Colors.amber;
    final secondColor = _colors != null ? _colors[1] : Colors.amber;
    final thirdColor = _colors != null ? _colors[2] : Colors.amber;
    final gamename = widget.gameName;
    return Scaffold(
        body: (_isLoading)
            ? new Center(
                child: new SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(),
              ))
            : CustomScrollView(
                slivers: <Widget>[
                  new SliverAppBar(
                      backgroundColor: color,
                      // pinned: true,
                      expandedHeight: orientation == Orientation.portrait
                          ? mediaSize.height * .25
                          : mediaSize.height * .5,
                      flexibleSpace: new FlexibleSpaceBar(
                        background: new Stack(children: <Widget>[
                          new Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                              image: new AssetImage(
                                  "assets/background_image/${widget.gameName}_big.png"),
                              fit: BoxFit.fill,
                            )),
                          ),
                          Container(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Center(
                                child: new Hero(
                                  tag: 'assets/hoodie/${widget.gameName}.png',
                                  child: new Image.asset(
                                    'assets/hoodie/${widget.gameName}.png',
                                    scale: .4,
                                  ),
                                ),
                              ))
                        ]),
                      ),
                      title: new Text(Loca.of(context).intl(widget.gameName)),
                      actions: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: GestureDetector(
                            onTap: () {
                              button3(context, gamename);
                              print("valueme incresing");
                            },
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              // margin: EdgeInsets.only(left: 190.0),
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(40.0),
                                // color: Colors.red
                              ),
                              child: new Center(
                                child: Image.asset('assets/videohelp.png'),
                              ),
                            ),
                          ),
                        )
                      ]),
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            color: secondColor,
                            child: Text(Loca.of(context).family)),
                      ],
                    ),
                  ),
                  new SliverGrid(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return convertToFriend(context, _localUsers[index],
                            onTap: startGame);
                      },
                      childCount: _localUsers.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Container(
                            padding: EdgeInsets.all(8.0),
                            color: thirdColor,
                            child: Text(Loca.of(context).friends)),
                      ],
                    ),
                  ),
                  new SliverGrid(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Badge(
                          value: '!',
                          positionTop: 20.0,
                          positionRight: 20.0,
                          child: convertToFriend(context, _myTurn[index],
                              onTap: goToMyTurn),
                        );
                      },
                      childCount: _myTurn.length,
                    ),
                  ),
                  new SliverGrid(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return convertToFriend(context, _remoteUsers[index],
                            onTap: startGame);
                      },
                      childCount: _remoteUsers.length,
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return convertToFriend(context, _otherTurn[index]);
                    }, childCount: _otherTurn.length),
                  ),
                ],
              ));
  }

  startGame(BuildContext context, User user) {
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
    Random random = Random();
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) => GameCategoryListScreen(
              game: widget.gameName,
              gameMode: GameMode.iterations,
              gameDisplay: user.id == loggedInUser.id
                  ? GameDisplay.single
                  : user.deviceId == _deviceId
                      ? random.nextBool()
                          ? GameDisplay.localTurnByTurn
                          : GameDisplay.myHeadToHead
                      : GameDisplay.networkTurnByTurn,
              otherUser: user,
            )));
  }

  goToMyTurn(BuildContext context, User user) {
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;

    Navigator.of(context)
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

  Widget convertToFriend(BuildContext context, User user, {Function onTap}) {
    return FriendItem(
      id: user.id,
      name: user.name,
      imageUrl: user.image,
      color: user.color,
      replaceWithHoodie: false,
      onTap: () => onTap != null ? onTap(context, user) : null,
    );
  }

  void button3(BuildContext context, String gamename) {
    print("Button 1");
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new VideoApp(gamename: gamename)));
  }
}
