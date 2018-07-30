import 'package:flutter/material.dart';
import '../db/entity/category_topic.dart';
import '../repos/category_topic_repo.dart';

class SubcategoryList extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const SubcategoryList({Key key, this.categoryName, this.categoryId})
      : super(key: key);
  @override
  _SubcategoryListState createState() => new _SubcategoryListState();
}

class _SubcategoryListState extends State<SubcategoryList> {
  List<CategoryTopic> _dataCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    setState(() => _isLoading = true);
    String id = widget.categoryId;
    String idname = widget.categoryName;
    print(".....id matching or not.::$id......::$idname");

    _dataCategory = await CategoryTopicRepo().getCategoryTopicsByCategoryId(id);

    print(".......::database data is....${_dataCategory.length}");

    setState(() => _isLoading = false);
  }

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    Orientation orientation = MediaQuery.of(context).orientation;
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("${widget.categoryName}"),
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
                  return new Container(
                    height: 40.0,
                    width: 40.0,
                    color: Colors.redAccent,
                    child:
                        Center(child: new Text("${_dataCategory[i].topicId}")),
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
