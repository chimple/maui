import 'package:flutter/material.dart';

import '../db/entity/category_topic.dart';
import '../repos/category_topic_repo.dart';

class SubcategoryList extends StatefulWidget {
  final String gamename;
  final String gameid;

  const SubcategoryList({Key key, this.gamename, this.gameid})
      : super(key: key);
  @override
  _SubcategoryListState createState() => new _SubcategoryListState();
}

class _SubcategoryListState extends State<SubcategoryList> {
  @override
  String message = 'this is true';
  List<CategoryTopic> _dataCategory = new List<CategoryTopic>();

  var _categoryData;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    String iddata = widget.gameid;
    String idname = widget.gamename;
    print(".....id matching or not.::$iddata......::$idname");
    // var notifs = await NotifRepo().getNotifCountByType();
    _categoryData =
        await CategoryTopicRepo.categoryTopicDao.getAllCategoryTopics(iddata);
    //  datatemplate= await  ActivityTemplateRepo.activityTemplateDao.getalltemplate();
    print("object...category data is...eee...$_categoryData");
    setState(() {
      _dataCategory = _categoryData;
      print(".......::database data is....${_dataCategory.length}");
      // _notifs = notifs;
    });
  }

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("${widget.gamename}"),
        ),
        body: Stack(children: [
          Container(
              color: const Color(0xffFECE3D),
              child: new GridView.count(
                key: new Key('SubCategory_page'),
                primary: true,
//          padding: const EdgeInsets.all(.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                crossAxisCount: media.size.height > media.size.width ? 2 : 2,
                children: new List.generate(_dataCategory.length, (i) {
                  return GestureDetector(
                    onTap: () {
                      String gamename = _categoryData[i].name;
                      String gameid = _categoryData[i].id;
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new SubcategoryList(
                                  gamename: gamename, gameid: gameid)));
                    },
                    child: new Container(
                      height: 40.0,
                      width: 40.0,
                      color: Colors.redAccent,
                      child: Center(
                          child: new Text("${_dataCategory[i].topicId}")),
                    ),
                  );
                }),
              )),
          new SubcategoryScrollerView(),
        ]));
  }
}

class SubcategoryScrollerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("hello horizantal");
    return new Container(
      // margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 40.0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: new List.generate(9, (index) {
            return Container(
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 90.0,
                  color: Colors.blue,
                  child: Center(child: new Text("$index")),
                ),
              ),
            );
          })),
    );
  }
}
