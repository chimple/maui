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

    _subcategories = await CategoryRepo().getSubcategoriesByCategoryId(id);
    for (var i = 0; i < _subcategories.length; i++) {
      _topics = await TopicRepo().getTopicsForCategoryId(_subcategories[i].id);
      _listTopics.add(_topics);
    }
    setState(() => _isLoading = false);
  }

  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new MaterialApp(
        home: DefaultTabController(
      length: _subcategories.length,
      child: new Scaffold(
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
            // controller: _tabController,
            isScrollable: true,
            tabs: List<Widget>.generate(_subcategories.length, (int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Tab(text: "${_subcategories[index].name}"),
              );
            }).toList(),
          ),
        ),
        body: _buildTabBarView(context),
      ),
    ));
  }

  Widget _buildTabBarView(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    return new TabBarView(
        children: List<Widget>.generate(_subcategories.length, (int index) {
      return new GridView.count(
        key: new Key('Category_page'),
        primary: true,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        crossAxisCount: media.size.height > media.size.width ? 2 : 2,
        children: new List.generate(_listTopics[index].length, (j) {
          return TopicButton(
              text: '${_listTopics[index][j].name}',
              image: '${_listTopics[index][j].image}',
              onPress: null);
        }).toList(),
      );
    }));
  }
}
