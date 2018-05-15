import 'package:maui/games/single_game.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/db/entity/game_category.dart';
import 'expansionTile.dart';
import 'user_item.dart';

class GameCategoryList extends StatefulWidget {
  GameCategoryList(
      {Key key, @required this.gameCategories, @required this.game})
      : super(key: key);
  State<StatefulWidget> createState() => new _GameCategoryList();
  final List<Tuple2<int, String>> gameCategories;
  final String game;
}

class _GameCategoryList extends State<GameCategoryList> {
  List<int> colors = [
    0XFF48AECC,
    0XFFE66796,
    0XFFFF7676,
    0XFFEDC23B,
    0XFFAD85F9,
    0XFF77DB65,
    0XFF66488C,
    0XFFDD6154,
    0XFFFFCE73,
    0XFFD64C60,
    0XFFDD4785,
    0XFF52C5CE,
    0XFFF97658,
    0XFFA46DBA,
    0XFFA292FF,
    0XFFFF8481,
    0XFF35C9C1,
    0XFFEDC23B,
    0XFF42AD56,
    0XFFF47C5D,
    0XFF77DB65,
    0XFF57DBFF,
    0XFFEB706F,
    0XFF48AECC,
    0XFFFFC729,
    0XFF30C9E2,
    0XFFA1EF6F,
    0XFF48AECC,
    0XFFE66796,
    0XFFFF7676,
    0XFFEDC23B,
    0XFFAD85F9,
    0XFF77DB65,
    0XFF66488C,
    0XFFDD6154,
    0XFFFFCE73,
    0XFFD64C60,
    0XFFDD4785,
    0XFF52C5CE,
    0XFFF97658,
    0XFFA46DBA,
    0XFFA292FF,
    0XFFFF8481,
    0XFF35C9C1,
    0XFFEDC23B,
    0XFF42AD56,
    0XFFF47C5D,
    0XFF77DB65,
    0XFF57DBFF,
    0XFFEB706F,
    0XFF48AECC,
    0XFFFFC729,
    0XFF30C9E2,
    0XFFA1EF6F,
    0XFF48AECC,
    0XFFE66796,
    0XFFFF7676,
    0XFFEDC23B,
    0XFFAD85F9,
    0XFF77DB65,
    0XFF66488C,
    0XFFDD6154,
    0XFFFFCE73,
    0XFFD64C60,
    0XFFDD4785,
    0XFF52C5CE,
    0XFFF97658,
    0XFFA46DBA,
    0XFFA292FF,
    0XFFFF8481,
    0XFF35C9C1,
    0XFFEDC23B,
    0XFF42AD56,
    0XFFF47C5D,
    0XFF77DB65,
    0XFF57DBFF,
    0XFFEB706F,
    0XFF48AECC,
    0XFFFFC729,
    0XFF30C9E2,
    0XFFA1EF6F,
    0XFF48AECC,
    0XFFE66796,
    0XFFFF7676,
    0XFFEDC23B,
    0XFFAD85F9,
    0XFF77DB65,
    0XFF66488C,
    0XFFDD6154,
    0XFFFFCE73,
    0XFFD64C60,
    0XFFDD4785,
    0XFF52C5CE,
    0XFFF97658,
    0XFFA46DBA,
    0XFFA292FF,
    0XFFFF8481,
    0XFF35C9C1,
    0XFFEDC23B,
    0XFF42AD56,
    0XFFF47C5D,
    0XFF77DB65,
    0XFF57DBFF,
    0XFFEB706F,
    0XFF48AECC,
    0XFFFFC729,
    0XFF30C9E2,
    0XFFA1EF6F,
    0XFF48AECC,
  ];
  @override
  void initState() {
    int categoriesLength = widget.gameCategories.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int j = 1;
    Size media = MediaQuery.of(context).size;
    final _colors = SingleGame.gameColors[widget.game];
    final color = _colors != null ? _colors[0] : Colors.amber;
    return new Flex(
      direction: Axis.vertical,
      children: <Widget>[
        new Expanded(
          flex: 1,
          child: new Container(
            width: media.width,
            color: color,
            child: new Image(
              image: AssetImage(
                'assets/hoodie/${widget.game}.png',
              ),
            ),
          ),
        ),
        new Expanded(
          flex: 2,
          child: new ListView(
            children: widget.gameCategories
                .map((gameCategory) => _buildTiles(context, j++,
                    gameCategory.item1, gameCategory.item2, widget.game))
                .toList(growable: false),
          ),
        )
      ],
    );
  }

  Widget _buildTiles(BuildContext context, int index, int categoryId,
      String categories, String gameName) {
    return new Container(
      color: new Color(colors[index]),
      child: new ExpansionTiles(
        title: new Center(
            child: new Text(
          categories,
          style: TextStyle(color: Colors.white),
        )),
        trailing: new Text(''),
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new IconButton(
                color: Colors.white,
                key: new Key('single'),
                icon: new Icon(Icons.accessibility),
                onPressed: () => showModes(
                    context, gameName, 'single_iterations', categoryId),
              ),
              new IconButton(
                color: Colors.white,
                key: new Key('h2h'),
                icon: new Icon(Icons.people),
                onPressed: () =>
                    showModes(context, gameName, 'h2h_iterations', categoryId),
              ),
            ],
          )
        ],
      ),
    );
  }

  String selected;
  showModes(
    BuildContext context,
    String game,
    String _modeName,
    int id,
  ) async {
    selected = await showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          if (_modeName == 'single_iterations') {
            Navigator.of(context).pop('single_iterations');
          } else if (_modeName == 'h2h_iterations') {
            Navigator.of(context).pop('h2h_iterations');
          }
        });
    if (selected.isNotEmpty)
      Navigator.of(context).pushNamed('/games/$game/categories/$id/$selected');
  }
}

// older cod

// class GameCategoryList extends StatelessWidget {
//   final List<Tuple2<int, String>> gameCategories;
//   final String game;

//   GameCategoryList(
//       {Key key, @required this.gameCategories, @required this.game})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return new ListView(
//         key: new Key('game-category-list'),
//         primary: false,
//         children: gameCategories
//             .map((gameCategory) => new RaisedButton(
//                   key: new Key('${gameCategory.item2}'),
//                   child: new Text(gameCategory.item2),
//                   onPressed: () => showModes(context, game, gameCategory.item1),
//                 ))
//             .toList());
//   }

//   showModes(BuildContext context, String game, int id) async {
//     String selected = await showModalBottomSheet<String>(
//         context: context,
//         builder: (BuildContext context) {
//           print(Navigator.of(context).toString());
//           return new Container(
//               child: new Padding(
//                   padding: const EdgeInsets.all(32.0),
//                   child: new ButtonBar(
//                       alignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         new IconButton(
//                             key: new Key('single'),
//                             icon: new Icon(Icons.accessibility),
//                             onPressed: () =>
//                                 Navigator.of(context).pop('single_iterations')),
//                         new IconButton(
//                             key: new Key('singletimed'),
//                             icon: new Icon(Icons.alarm),
//                             onPressed: () =>
//                                 Navigator.of(context).pop('single_timed')),
//                         new IconButton(
//                             key: new Key('h2h'),
//                             icon: new Icon(Icons.people),
//                             onPressed: () =>
//                                 Navigator.of(context).pop('h2h_iterations')),
//                         new IconButton(
//                             key: new Key('h2htimed'),
//                             icon: new Icon(Icons.av_timer),
//                             onPressed: () =>
//                                 Navigator.of(context).pop('h2h_timed')),
//                       ])));
//         });
//     if (selected.isNotEmpty)
//       Navigator.of(context).pushNamed('/games/$game/categories/$id/$selected');
//   }
// }
