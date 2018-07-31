import 'package:flutter/material.dart';
import 'package:maui/db/entity/category.dart';
import 'package:maui/db/entity/topic.dart';
import '../components/topic_button.dart';
import '../repos/topic_repo.dart';
import '../repos/category_repo.dart';

class SubcategoryList extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const SubcategoryList({Key key, this.categoryName, this.categoryId})
      : super(key: key);
  @override
  _SubcategoryListState createState() => new _SubcategoryListState();
}

class _SubcategoryListState extends State<SubcategoryList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Topic> _topics;
  List _listTopics = [];
  List<Category> _subcategories;
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
    _subcategories = await CategoryRepo().getSubcategoriesByCategoryId(id);
    print("subcategories in my databse is...$_subcategories");
    _tabController =
        new TabController(vsync: this, length: _subcategories.length);
    _subcategories.forEach((e) {
      print("this data foreach is......::${e.name}");
      _getTopicDataForcategory(e.name);
    });
    print(
        "hello this is when click this in my tabbar....::${_subcategories.first.id}");
    _topics = await TopicRepo().getTopicsForCategoryId('animals');

    print(".......::database data is....${_topics.length}");
    print("hello data of the databselength isss.....${_listTopics.length}");

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    print("hello checking how many times its comming when i click tab");
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: Row(children: [
                new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new Text("${widget.categoryName}")
              ]),
              bottom: new TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: List<Widget>.generate(_subcategories.length, (int index) {
                  print("thisssss....is...::${_subcategories[index]}");

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Tab(text: "${_subcategories[index].name}"),
                  );
                }),
              ),
            ),
            body: _buildTabBarView(context)
            // new TabBarView(
            //   children:_buildTabBarView(context)
            //   //     List<Widget>.generate(_subcategories.length, (int index) {
            //   //   print(_subcategories[0]);

            //   //   return new GridView.count(
            //   //     key: new Key('Category_page'),
            //   //     primary: true,
            //   //     crossAxisSpacing: 12.0,
            //   //     mainAxisSpacing: 12.0,
            //   //     crossAxisCount:
            //   //         media.size.height > media.size.width ? 2 : 2,
            //   //     children: new List.generate(_topics.length, (i) {
            //   //       return TopicButton(
            //   //           text: '${_topics[i].name}',
            //   //           image: '${_topics[i].image}',
            //   //           onPress: null);
            //   //     }),
            //   //   );
            //   // }),
            // )
            ));
  }

  Widget _buildTabBarView(BuildContext context) {
    print(
        "data is.... commming of tabbar isss.....::${_tabController.animateTo((_tabController.index + 1) % 2)}");
    // print("data is.... commming of tabbar isss.....::${}");
    MediaQueryData media = MediaQuery.of(context);
    return new TabBarView(
        controller: _tabController,
        children: List<Widget>.generate(_subcategories.length, (int index) {
          print(_subcategories[0]);

          return new GridView.count(
            key: new Key('Category_page'),
            primary: true,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            crossAxisCount: media.size.height > media.size.width ? 2 : 2,
            children: new List.generate(_listTopics.length, (i) {
              print("legth isssss.s........::${_listTopics.length}");
              print("data iss........::${_listTopics[1][0].name}");
              return TopicButton(
                  text: '${_listTopics[i][0].name}',
                  image: '${_listTopics[i][0].image}',
                  onPress: null);
            }),
          );
        }));
  }

  void _getTopicDataForcategory(String name) async {
    var _topicis;
    print(" topics comming or not");
    _topicis = await TopicRepo().getTopicsForCategoryId('animals');
    print("after getting data from databse is...::$_topicis");
    setState(() {
      _listTopics.add(_topicis);
    });

    print("topics is........$_listTopics");
  }
}
