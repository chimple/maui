import 'package:flutter/material.dart';

import '../db/entity/category_topic.dart';
import '../repos/category_topic_repo.dart';

class SubcategoryList extends StatefulWidget {
  final String gamename;
  final String gameid;

  const SubcategoryList({Key key, this.gamename, this.gameid})
      : super(key: key);
  @override
  MyappclassState createState() => new MyappclassState();
}

class MyappclassState extends State<SubcategoryList> {
  @override
  bool val = true;
  String message = 'this is true';
  List<CategoryTopic> _datacategory = new List<CategoryTopic>();
  var datatemplate;
  var categorydata;
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
    categorydata =
        await CategoryTopicRepo.categoryTopicDao.getallcategoryTopic(iddata);
    //  datatemplate= await  ActivityTemplateRepo.activityTemplateDao.getalltemplate();
    print("object...category data is...eee...${categorydata}");
    setState(() {
      _datacategory = categorydata;
      print(".......::database data is....${_datacategory.length}");
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
                key: new Key('Game_page'),
                primary: true,
//          padding: const EdgeInsets.all(.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                crossAxisCount: media.size.height > media.size.width ? 2 : 2,
                children: new List.generate(_datacategory.length, (i) {
                  return GestureDetector(
                    onTap: () {
                      String gamename = categorydata[i].name;
                      String gameid = categorydata[i].id;
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
                          child: new Text("${_datacategory[i].topicId}")),
                    ),
                  );
                }),
              )),
          new MyAppScrol(),
        ]));
  }
}

class MyAppScrol extends StatelessWidget {
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
