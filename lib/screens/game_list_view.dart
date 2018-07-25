import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/select_opponent_screen.dart';
import 'package:maui/repos/notif_repo.dart';
import 'package:badge/badge.dart';
import 'package:maui/loca.dart';
import 'package:maui/components/gameaudio.dart';

class GameListView extends StatefulWidget {
  const GameListView({Key key}) : super(key: key);

  @override
  GameListViewState createState() {
    return new GameListViewState();
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}

class GameListViewState extends State<GameListView> {
  Map<String, int> _notifs = Map<String, int>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    var notifs = await NotifRepo().getNotifCountByType();
    setState(() {
      _notifs = notifs;
    });
  }

  Widget _buildButton(
      BuildContext context, String gameName, String displayName) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    final colors = SingleGame.gameColors[gameName];
    final color = colors != null ? colors[0] : Colors.amber;
    var size = media.size;
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
      ),
      margin: EdgeInsets.all(size.width * .02),
      child: new InkWell(
        onTap: () {
          Navigator
              .of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return SelectOpponentScreen(
              gameName: gameName,
            );
          }));
        },
        key: new Key(gameName),
        child: new Stack(
          children: <Widget>[
            new Material(
                elevation: 8.0,
                borderRadius:
                    const BorderRadius.all(const Radius.circular(16.0)),
                child: new Container(
                  decoration: new BoxDecoration(
                    color: color,
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(16.0)),
                    image: new DecorationImage(
                      image: new AssetImage(
                          "assets/background_image/${gameName}_small.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            new Column(
              children: <Widget>[
                new Expanded(
                    child: _notifs[gameName] == null
                        ? new Column(children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Container(
                                  width: orientation == Orientation.portrait
                                      ? size.width * 0.15
                                      : size.width * 0.1,
                                  child: new Hero(
                                    tag: 'assets/hoodie/$gameName.png',
                                    child: Image.asset(
                                        'assets/hoodie/$gameName.png',
                                        scale: 0.2),
                                  ),
                                ),
                              ],
                            ),
                          ])
                        : Badge(
                            value: '${_notifs[gameName]}',
                            child: new Column(children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new Container(
                                    width: orientation == Orientation.portrait
                                        ? size.width * 0.15
                                        : size.width * 0.1,
                                    child: new Hero(
                                      tag: 'assets/hoodie/$gameName.png',
                                      child: Image.asset(
                                          'assets/hoodie/$gameName.png',
                                          scale: 0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ]))),
                new Container(
                    child: new Container(
//                      padding: EdgeInsets.only(left:size.width * 0.1),
                        // margin: EdgeInsets.only(left: size.width*.15),
                        child: new Text(Loca.of(context).intl(gameName),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: new TextStyle(
                                fontSize: size.height * .04,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    final iconSize = min(media.size.width, media.size.height) / 8;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    final gap = 16.0 * min(media.size.width, media.size.height) / 400.0;
    return Container(
      color: const Color(0xffFECE3D),
      child: new GridView.count(
          key: new Key('Game_page'),
          primary: true,
//          padding: const EdgeInsets.all(.0),
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          crossAxisCount: media.size.height > media.size.width ? 3 : 4,
          children: <Widget>[
            _buildButton(context, 'reflex', 'Reflex'),
            _buildButton(context, 'order_it', 'Order It'),
            _buildButton(context, 'memory', 'Memory'),
//            _buildButton(context, 'abacus', 'Abacus'),
            _buildButton(context, 'drawing', 'drawing'),
            _buildButton(context, 'fill_in_the_blanks', 'Fill In The Blanks'),
            _buildButton(context, 'calculate_numbers', 'Calculate'),
            _buildButton(context, 'casino', 'Casino'),
            _buildButton(context, 'match_the_following', 'Match'),
            _buildButton(context, 'bingo', 'Bingo'),
            _buildButton(context, 'true_or_false', 'True Or False'),
            _buildButton(context, 'tables', 'Tables'),
            _buildButton(context, 'identify', 'identify'),
            _buildButton(context, 'fill_number', 'Fill Number'),
            _buildButton(context, 'quiz', 'Quiz'),
            _buildButton(context, 'connect_the_dots', 'Connect The Dots'),
            _buildButton(context, 'tap_home', 'Tap Home'),
            _buildButton(context, 'tap_wrong', 'Tap Wrong'),
            _buildButton(context, 'guess', 'guess'),
            _buildButton(context, 'wordgrid', 'Word Grid'),
            _buildButton(context, 'spin_wheel', 'Spin The Wheel'),
            _buildButton(context, 'dice', 'Dice'),
//            _buildButton(context, 'circle_word', 'Circle Word'),
//            _buildButton(context, 'first_word', 'First Word'),
//            _buildButton(context, 'friend_word', 'Friend Word'),
//            _buildButton(context, 'picture_sentence', 'Picture Sentence'),
//            _buildButton(context, 'crossword', 'Crossword'),
//            _buildButton(context, 'draw_challenge', 'draw_challenge'),
//            _buildButton(context, 'clue_game', 'Clue'),
          ]),
    );
  }
}
