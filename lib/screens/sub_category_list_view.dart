import 'package:flutter/material.dart';
import 'package:maui/db/entity/category.dart';
import 'package:maui/db/entity/topic.dart';
import 'package:maui/loca.dart';
import 'package:maui/screens/topic_screen.dart';
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
    print(";;;;;id of the subcatgory isss....;:$id");
    _subcategories = await CategoryRepo().getSubcategoriesByCategoryId(id);
    print("subcategory of birds iss,,,....::$_subcategories");

    setState(() => _isLoading = false);
  }

  Widget build(BuildContext context) {
    print('loca sub_category_list_state ${Loca.of(context)}');
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return DefaultTabController(
      length: _subcategories.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text("${widget.categoryName}"),
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
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return new TabBarView(
        children: List<Widget>.generate(_subcategories.length, (int index) {
      return new TabcontrollerView(id: _subcategories[index].id);
    }));
  }
}

class TabcontrollerView extends StatefulWidget {
  final String id;

  const TabcontrollerView({Key key, this.id}) : super(key: key);
  @override
  TabcontrollerViewState createState() => new TabcontrollerViewState();
}

class TabcontrollerViewState extends State<TabcontrollerView> {
  List<Topic> _topics;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    setState(() => _isLoading = true);
    String id = widget.id;
    print(";;;;;id of the subcatgory isss....;:$id");

    _topics = await TopicRepo().getTopicsForCategoryId(id);
    print("topic data to dilspy is....::$_topics");

    setState(() => _isLoading = false);
  }

  Widget build(BuildContext context) {
    print('loca tab_controller_view_state ${Loca.of(context)}');
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new GridView.count(
      key: new Key('Subcatgory_page'),
      primary: true,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      crossAxisCount: media.size.height > media.size.width ? 2 : 2,
      children: new List.generate(_topics.length, (j) {
        print("Topic Id generated at subcategory list - ${_topics[j].id}");
        return TopicButton(
            text: '${_topics[j].name}',
            image: '${_topics[j].image}',
            topicId: '${_topics[j].id}',
            onPress: () {
              Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new TopicScreen(topicId: _topics[j].id,
                            topicName: _topics[j].name

                            )),
                  );
            });
      }).toList(),
    );
  }
}
