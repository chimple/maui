import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/collected_item_data.dart';
import 'package:tuple/tuple.dart';

class CollectedItemScreen extends StatefulWidget {
  final BuiltMap<String, int> itemsValue;
  final Map<CollectionTitle, List<CollectedItemData>> staticItems;
  CollectedItemScreen({Key key, this.itemsValue, this.staticItems})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CollectedItemScreenState();
  }
}

class CollectedItemScreenState extends State<CollectedItemScreen>
    with SingleTickerProviderStateMixin {
  final int itemCrossAxisCount;
  TabController _tabController;

  int _itemCount = 0;
  List<Tuple4<String, String, int, int>> itemRange =
      List<Tuple4<String, String, int, int>>();
  CollectedItemScreenState({this.itemCrossAxisCount = 4});

  @override
  void initState() {
    super.initState();
    widget.staticItems.forEach((e, l) {
      itemRange.add(Tuple4(e.imageName, e.categoryName, _itemCount,
          _itemCount + (l.length / itemCrossAxisCount).ceil()));
      _itemCount += (l.length / itemCrossAxisCount).ceil();
    });
    _tabController = new TabController(vsync: this, length: itemRange.length);
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController.dispose();
    super.dispose();
  }

  Future _displayPopup(CollectionTitle r, int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.4
                  : 0.8,
          widthFactor:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.8
                  : 0.4,
          child: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  widget.staticItems[r].elementAt(index).imageName,
                ),
                Text(
                  widget.staticItems[r].elementAt(index).categoryName,
                  textScaleFactor: 2.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return new Scaffold(body: Container(
      child: LayoutBuilder(builder: (context, c) {
        return Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: new TabBarView(
                controller: _tabController,
                children: widget.staticItems.keys
                    .map((r) => CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 10.0),
                                child: Text(
                                  r.categoryName,
                                  style: TextStyle(
                                      fontSize: mediaQuery.size.height * 0.03,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.only(top: 0.0),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            mediaQuery.orientation ==
                                                    Orientation.portrait
                                                ? 0.82
                                                : 1.0,
                                        crossAxisCount:
                                            mediaQuery.orientation ==
                                                    Orientation.portrait
                                                ? 4
                                                : 6),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: <Widget>[
                                        Container(
                                          height: mediaQuery.orientation ==
                                                  Orientation.portrait
                                              ? mediaQuery.size.height *
                                                  0.07 *
                                                  1.6
                                              : mediaQuery.size.height *
                                                  0.10 *
                                                  1.85,
                                          width: mediaQuery.orientation ==
                                                  Orientation.portrait
                                              ? mediaQuery.size.width *
                                                  0.12 *
                                                  1.6
                                              : mediaQuery.size.width *
                                                  0.06 *
                                                  1.85,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.indigo[300]),
                                          child: InkWell(
                                            onTap: widget.itemsValue.values
                                                        .elementAt(0) ==
                                                    1
                                                ? () {
                                                    _displayPopup(r, index);
                                                  }
                                                : null,
                                            child: Opacity(
                                              opacity: widget.itemsValue.values
                                                          .elementAt(0) ==
                                                      1
                                                  ? 1.0
                                                  : 0.5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                  widget.staticItems[r]
                                                      .elementAt(index)
                                                      .imageName,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.0),
                                        ),
                                        Opacity(
                                          opacity: widget.itemsValue.values
                                                      .elementAt(0) ==
                                                  1
                                              ? 1.0
                                              : 0.5,
                                          child: Text(
                                            widget.staticItems[r]
                                                .elementAt(index)
                                                .categoryName,
                                            style: TextStyle(
                                              fontSize:
                                                  mediaQuery.orientation ==
                                                          Orientation.portrait
                                                      ? mediaQuery.size.height *
                                                          0.018 *
                                                          1.1
                                                      : mediaQuery.size.height *
                                                          0.04,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                      ]),
                                    );
                                  },
                                  childCount: widget.staticItems[r].length,
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList(growable: false),
              ),
            ),
          ],
        );
      }),
    ));
  }
}
