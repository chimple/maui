import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/models/accessories_data.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/chimp_character.dart';
import 'package:tuple/tuple.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class Store extends StatefulWidget {
  final BuiltMap<String, String> accessories;
  final Map<AccessoryCategory, List<AccessoryData>> items;
  Store(this.accessories, this.items, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new StoreWidget();
  }
}

class StoreWidget extends State<Store> with SingleTickerProviderStateMixin {
  final int itemCrossAxisCount;
  TabController _tabController;
  List<Tab> tabs;
  List<int> _colorStatus = [];
  String itemName;
  var tabIndex;
  var l;
  int listIndex = 0;
  int coin = 1000;
  int _itemCount = 0;
  List<Tuple4<String, String, int, int>> itemRange =
      List<Tuple4<String, String, int, int>>();
  StoreWidget({this.itemCrossAxisCount = 4});

  @override
  void initState() {
    super.initState();
    widget.items.forEach((e, l) {
      itemRange.add(Tuple4(
          e.accessoryCategoryImagePath,
          e.accessoryCategoryName,
          _itemCount,
          _itemCount + (l.length / itemCrossAxisCount).ceil()));
      _itemCount += (l.length / itemCrossAxisCount).ceil();
    });
    var totalAccessories =
        widget.items.values.map((v) => v.length).reduce((a, b) => a + b);
    for (int i = 0; i < totalAccessories + 1; i++) _colorStatus.add(0);
    _tabController = new TabController(vsync: this, length: itemRange.length);
    _tabController.addListener(() {
      l = _tabController..index;
      tabIndex = l.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _tab(String text) {
    return new Tab(
      child: SizedBox(
        child: Image.asset(
          text,
          color: Colors.white,
        ),
        width: 40.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return new Scaffold(
        body: Container(
            color: Colors.indigo[900],
            child: mediaQuery.orientation == Orientation.portrait
                // For Portrait mode
                ? Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.indigo[50].withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Text('Coins is $coin',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      )),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: ChimpCharacter(
                                  itemName: itemName,
                                  key: new GlobalObjectKey(itemName),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: new TabBar(
                                  isScrollable: true,
                                  indicator: new BubbleTabIndicator(
                                    indicatorHeight: 50.0,
                                    indicatorColor: Colors.red,
                                    tabBarIndicatorSize:
                                        TabBarIndicatorSize.tab,
                                  ),
                                  tabs: itemRange.map((s) {
                                    return _tab(s.item1);
                                  }).toList(growable: false),
                                  controller: _tabController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 5, child: displayAccessories()),
                    ],
                  )
                //For LandScape Mode
                : Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.indigo[50].withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text('Coins is $coin',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    )),
                              ),
                              Expanded(
                                flex: 1,
                                child: ChimpCharacter(
                                  itemName: itemName,
                                  key: new GlobalObjectKey(itemName),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: new TabBar(
                                  isScrollable: true,
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Colors.black,
                                  indicator: new BubbleTabIndicator(
                                    indicatorHeight: 65.0,
                                    indicatorColor: Colors.red,
                                    tabBarIndicatorSize:
                                        TabBarIndicatorSize.tab,
                                  ),
                                  tabs: itemRange.map((s) {
                                    return _tab(s.item1);
                                  }).toList(growable: false),
                                  controller: _tabController,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: displayAccessories(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )));
  }

  Widget displayAccessories() {
    final container = StateContainer.of(context);
    int index = 0;
    return Container(
        child: new TabBarView(
            controller: _tabController,
            children: widget.items.keys.map((r) {
              return Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Text(
                        r.accessoryCategoryName,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      children: widget.items[r].map((f) {
                        index++;
                        return StoreAccessoryButton(
                          index: index,
                          coin: f.coin,
                          colorStatus: _colorStatus,
                          imagePath: f.imagePath,
                          name: f.accessoryName,
                          setName: (String s, int n) {
                            setState(() {
                              itemName = s;
                              if (coin <= 0)
                                coin = 0;
                              else if (_colorStatus[n] == 0) {
                                coin = coin - 100;
                              }
                              _colorStatus[n] = 1;
                              container.setAccessories(BuiltMap<String, String>(
                                  {r.accessoryCategoryName: itemName}));
                              print(container.state.userProfile);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ));
            }).toList()));
  }
}

class StoreAccessoryButton extends StatelessWidget {
  int index;
  String imagePath;
  String name;
  int coin;
  Color color;
  final Function setName;
  List<int> colorStatus;
  StoreAccessoryButton({
    Key key,
    this.setName,
    this.index,
    this.color,
    this.imagePath,
    this.coin,
    this.colorStatus,
    this.name,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: colorStatus[index] == 1 ? Colors.yellow : Colors.indigo[400],
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: mediaQuery.orientation == Orientation.portrait
              ? mediaQuery.size.height * 0.07
              : mediaQuery.size.height * 0.10,
          width: mediaQuery.orientation == Orientation.portrait
              ? mediaQuery.size.width * 0.14
              : mediaQuery.size.width * 0.06,
          child: InkWell(
            key: Key('key $index'),
            onTap: () {
              setName(name, index);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(imagePath),
            ),
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: mediaQuery.orientation == Orientation.portrait
                ? mediaQuery.size.height * 0.018
                : mediaQuery.size.height * 0.03,
            color: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.add_circle,
              color: Colors.yellow[700],
            ),
            Text(
              coin.toString(),
              style: TextStyle(
                fontSize: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.height * 0.018
                    : mediaQuery.size.height * 0.03,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
