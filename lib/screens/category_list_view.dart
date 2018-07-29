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
  _CategoryListViewState createState() {
    return new _CategoryListViewState();
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}

class _CategoryListViewState extends State<CategoryListView> {
  List<Category> _dataCategory = new List<Category>();
  var _dataTemplate;
  var _categoryData;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _categoryData = await CategoryRepo.categoryDao.getAllCategories();
    _dataTemplate =
        await ActivityTemplateRepo.activityTemplateDao.getAllTemplates();
    print("object...category data is......$_categoryData");
    setState(() {
      _dataCategory = _categoryData;
      print(".......::database data is....${_categoryData}");
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
                  ),
                )),
            new Column(
              children: <Widget>[
                new Container(
                    child: new Container(
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

    return Container(
        color: const Color(0xffFECE3D),
        child: new GridView.count(
          key: new Key('Category_page'),
          primary: true,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          crossAxisCount: media.size.height > media.size.width ? 2 : 2,
          children: new List.generate(_categoryData.length, (i) {
            return GestureDetector(
                onTap: () {
                  String gamename = _categoryData[i].name;
                  String gameid = _categoryData[i].id;
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new SubcategoryList(
                          gamename: gamename, gameid: gameid)));
                },
                child: _buildButton(context, '${_categoryData[i].name}',
                    '${_categoryData[i].id}'));
          }),
        ));
  }
}
