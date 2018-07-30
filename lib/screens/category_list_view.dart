import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
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
  var _dataCategory;
  bool _isLoading = true;
  var _categoryData;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    setState(() => _isLoading = true);
    _dataCategory = await CategoryRepo().getCategories();

    print("object...category data is......$_categoryData");
    print("data of the $_dataCategory");
    setState(() => _isLoading = false);
  }

  Widget _buildButton(
      BuildContext context, String categoryName, String categoryId) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;

    final color = Colors.amber;
    var size = media.size;
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
      ),
      margin: EdgeInsets.all(size.width * .02),
      child: new Stack(
        children: <Widget>[
          new Material(
              elevation: 8.0,
              borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
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
                      child: new Text(Loca.of(context).intl(categoryName),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: new TextStyle(
                              fontSize: size.height * .04, color: Colors.white),
                          overflow: TextOverflow.ellipsis))),
            ],
          ),
        ],
      ),
    );
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
    return Container(
        color: const Color(0xffFECE3D),
        child: new GridView.count(
          key: new Key('Category_page'),
          primary: true,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          crossAxisCount: media.size.height > media.size.width ? 2 : 2,
          children: new List.generate(_dataCategory.length, (i) {
            return GestureDetector(
                onTap: () {
                  String categoryName = _dataCategory[i].name;
                  String categoryId = _dataCategory[i].id;
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new SubcategoryList(
                          categoryName: categoryName, categoryId: categoryId)));
                },
                child: _buildButton(context, '${_dataCategory[i].name}',
                    '${_dataCategory[i].id}'));
          }),
        ));
  }
}
