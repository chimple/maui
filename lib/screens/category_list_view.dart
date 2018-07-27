import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/select_opponent_screen.dart';
import 'package:maui/repos/notif_repo.dart';
import 'package:badge/badge.dart';
import 'package:maui/loca.dart';
import 'package:maui/components/gameaudio.dart';

import '../db/entity/category.dart';
import '../repos/activity_template_repo.dart';
import '../repos/category_repo.dart';
import 'sub_category_list_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key key}) : super(key: key);

  @override
  GameListViewState createState() {
    return new GameListViewState();
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}

class GameListViewState extends State<CategoryListView> {
  Map<String, int> _notifs = Map<String, int>();
  var datatemplate;
  var categorydata;
  List<Category> _datacategory = new List<Category>();
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    var notifs = await NotifRepo().getNotifCountByType();
    categorydata = await CategoryRepo.categoryDao.getallcategory();
    datatemplate =
        await ActivityTemplateRepo.activityTemplateDao.getalltemplate();
    print("object...category data is......$categorydata");
    setState(() {
      _datacategory = categorydata;
      // _datatemplate=datatemplate;
      print(".......::database data is....${_datacategory}");
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
          String gamename = gameName;
          String gameid = displayName;
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new SubcategoryList(gamename: gamename, gameid: gameid)));
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
          crossAxisCount: media.size.height > media.size.width ? 2 : 2,
          children: new List.generate(categorydata.length, (i) {
            return GestureDetector(
                onTap: () {
                  String gamename = categorydata[i].name;
                  String gameid = categorydata[i].id;
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new SubcategoryList(
                          gamename: gamename, gameid: gameid)));
                },
                child: _buildButton(context, '${categorydata[i].name}',
                    '${categorydata[i].id}'));
          }),
        ));
  }
}
