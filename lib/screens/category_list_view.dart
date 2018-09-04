import 'package:flutter/material.dart';
import 'package:maui/db/entity/category.dart';
import 'package:maui/loca.dart';
import '../components/topic_button.dart';
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
  List<Category> _dataCategories;
  bool _isLoading = true;
  static const mainCategoryId = 'main';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    setState(() => _isLoading = true);
    _dataCategories =
        await CategoryRepo().getSubcategoriesByCategoryId(mainCategoryId);

    print("object...category data is......$_dataCategories");
    print("data of the $_dataCategories");
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    print("hello image is ther or not ....::...'${_dataCategories[0].image}'");
    print("data Category list received - '${_dataCategories[0].id}'");
    return Container(
        color: const Color(0xffFECE3D),
        child: new GridView.count(
          key: new Key('Category_page'),
          primary: true,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          crossAxisCount: media.size.height > media.size.width ? 2 : 2,
          children: new List.generate(_dataCategories.length, (i) {
            return TopicButton(
                text: '${_dataCategories[i].name}',
                image: '${_dataCategories[i].image}',
                topicId: '${_dataCategories[i].id}',
                onPress: () {
                  Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new SubcategoryList(
                                    categoryName: _dataCategories[i].name,
                                    categoryId: _dataCategories[i].id)),
                      );
                });
          }),
        ));
  }
}
