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

// List<int> _initiallyExpand = [];

class _GameCategoryList extends State<GameCategoryList> {
  @override
  void initState() {
    // _initiallyExpand.clear();
    super.initState();
    print(widget.game);
    int categoriesLength = widget.gameCategories.length;
    print("Length of categories::$categoriesLength");
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
              background: new Image.asset(
                'assets/hoodie/${widget.game}.png',
                scale: .85,
              ),
              centerTitle: true,
              title: new Text(widget.game),
            )),
        new SliverList(
          delegate: new SliverChildListDelegate(new List<Widget>.generate(
            1,
            (int index) {
              return new Container(
                  alignment: Alignment.center,
                  child: new Flex(
                    direction: Axis.vertical,
                    children: widget.gameCategories
                        .map((gameCategory) => _buildTiles(
                              context,
                              j++,
                              gameCategory.item1,
                              gameCategory.item2,
                              widget.game,
                            ))
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

  bool _isLoading = false;
  Widget _buildTiles(
    BuildContext context,
    int index,
    int id,
    String gameCategory,
    String game,
  ) {
    if (_isLoading) {
      return new Center(
        child: new Text(
          'Loading..',
          style: new TextStyle(fontSize: 40.0, color: Colors.green),
        ),
      );
    }
    return new BuildExpansionTiles(
      context: context,
      categoryId: id,
      index: index,
      gameCategory: gameCategory,
      gameName: game,
      onClick: (dynamic) {
        print("print index of tile $index");
        // if (_initiallyExpand[index] != 1) {
        //   setState(() {
        //     _initiallyExpand[index] = 1;
        //   });
        //   flag = 1;
        // }
        // if (_oldIndex != index && flag == 1) {
        //   setState(() {
        //     _initiallyExpand[_oldIndex] = 0;
        //     flag = 0;
        //   });
        // }
        // _oldIndex = index;
      },
    );
  }
}

class BuildExpansionTiles extends StatefulWidget {
  BuildExpansionTiles(
      {Key key,
      this.context,
      this.onClick,
      @required this.categoryId,
      @required this.gameName,
      @required this.index,
      @required this.gameCategory})
      : super(key: key);
  final BuildContext context;
  int index;
  int categoryId;
  String gameCategory;
  String gameName;
  ValueChanged onClick;
  @override
  State<StatefulWidget> createState() => new _BuildExpansionTiles();
}

class _BuildExpansionTiles extends State<BuildExpansionTiles> {
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
    super.initState();
  }

  callMe() {
    print("count callll::");
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double _fontSize;
    _fontSize = (media.height * .58 * .162) / 3.9;
    return new Container(
      color: new Color(colors[widget.index]),
      child: new ExpansionTiles(
        // onExpansionChanged: showModes(context, widget.gameName,
        //             'push', widget.categoryId),
        title: new Center(
            child: new Text(
          widget.gameCategory,
          style: TextStyle(color: Colors.white, fontSize: _fontSize),
        )),
        trailing: new Text(''),
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new IconButton(
                color: Colors.white,
                key: new Key('single'),
                icon: new Icon(Icons.accessibility),
                onPressed: () => showModes(context, widget.gameName,
                    'single_iterations', widget.categoryId),
              ),
              new IconButton(
                color: Colors.white,
                key: new Key('h2h'),
                icon: new Icon(Icons.people),
                onPressed: () => showModes(context, widget.gameName,
                    'h2h_iterations', widget.categoryId),
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

//older cod

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
//     print("count calling state:: $context, $game, $id");
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
