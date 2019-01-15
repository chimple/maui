import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/select_opponent_screen.dart';
import 'package:maui/repos/notif_repo.dart';
import 'package:badge/badge.dart';
import 'package:maui/loca.dart';
import 'package:maui/components/gameaudio.dart';
import 'package:tuple/tuple.dart';

List<Tuple2<String, String>> gameNames = [
  Tuple2('reflex', 'Reflex'),
  Tuple2('order_it', 'Order It'),
  Tuple2('memory', 'Memory'),
  Tuple2('drawing', 'drawing'),
  Tuple2('fill_in_the_blanks', 'Fill In The Blanks'),
  Tuple2('calculate_numbers', 'Calculate'),
  Tuple2('casino', 'Casino'),
  Tuple2('match_the_following', 'Match'),
  Tuple2('bingo', 'Bingo'),
  Tuple2('true_or_false', 'True Or False'),
  Tuple2('tables', 'Tables'),
  Tuple2('identify', 'identify'),
  Tuple2('fill_number', 'Fill Number'),
  Tuple2('quiz', 'Quiz'),
  Tuple2('connect_the_dots', 'Connect The Dots'),
  Tuple2('tap_home', 'Tap Home'),
  Tuple2('tap_wrong', 'Tap Wrong'),
  Tuple2('guess', 'guess'),
  Tuple2('wordgrid', 'Word Grid'),
  Tuple2('spin_wheel', 'Spin The Wheel'),
  Tuple2('dice', 'Dice'),
];

//            GameButton( 'abacus', 'Abacus', notifs: _notifs),
//            GameButton( 'circle_word', 'Circle Word'),
//            GameButton( 'first_word', 'First Word'),
//            GameButton( 'friend_word', 'Friend Word'),
//            GameButton( 'picture_sentence', 'Picture Sentence'),
//            GameButton( 'crossword', 'Crossword'),
//            GameButton( 'draw_challenge', 'draw_challenge'),
//            GameButton( 'clue_game', 'Clue'),

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

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final iconSize = min(media.size.width, media.size.height) / 8;
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    final gap = 16.0 * min(media.size.width, media.size.height) / 400.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(Loca.of(context).games),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        child: new GridView.count(
          key: new Key('Game_page'),
          primary: true,
//          padding: const EdgeInsets.all(.0),
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          crossAxisCount: media.size.height > media.size.width ? 3 : 4,
          children: gameNames
              .map((t) => GameButton(
                    t.item1,
                    t.item2,
                    notifs: _notifs,
                  ))
              .toList(growable: false),
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String gameName;
  final String displayName;
  final Map<String, int> notifs;

  const GameButton(this.gameName, this.displayName, {Key key, this.notifs})
      : super(key: key);

  Widget build(BuildContext context) {
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
          Navigator.of(context)
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
                    child: (notifs == null || notifs[gameName] == null)
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
                            value: '${notifs[gameName]}',
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
}
