import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/util/accessories_data.dart';
import 'package:maui/jamaica/widgets/chimp_character.dart';
import 'package:tuple/tuple.dart';

class Store extends StatefulWidget {
  // final BuiltMap<String, String> accessories;
  final Map<AccessoryCategory, List<AccessoryData>> items;
  Store(this.items, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StoreWidget();
  }
}

class StoreWidget extends State<Store> with SingleTickerProviderStateMixin {
  final int itemCrossAxisCount;
  final List<String> itemNames = <String>[];
  TabController _tabController;
  List<Tab> tabs;
  List<int> _colorStatus = [];
  String itemName;
  var tabIndex;
  var l;
  int listIndex = 0;
  int score = 500;
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
    _tabController = TabController(vsync: this, length: itemRange.length);
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
    return Tab(
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
    int index = 0;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
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
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: <Widget>[
                              Positioned(
                                top: 10.0,
                                left: 10.0,
                                child: Text('$score',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    )),
                              ),
                              ChimpCharacter(
                                itemNames: itemNames,
                                key: UniqueKey(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TabBar(
                                  isScrollable: true,
                                  indicator: BubbleTabIndicator(
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
                                child: Text(
                                  'Coins is $score',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ChimpCharacter(
                                  itemNames: itemNames,
                                  key: UniqueKey(),
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
                                child: TabBar(
                                  isScrollable: true,
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Colors.black,
                                  indicator: BubbleTabIndicator(
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
    // final container = StateContainer.of(context);
    int index = 0;
    return Container(
        child: TabBarView(
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
                          itemNames: itemNames,
                          name: f.accessoryName,
                          toggleItem: (s) {
                            setState(() {
                              itemNames.add(s);
                            });
                          },
                          score: score,
                          setName: (int n) {
                            // itemName = s;
                            setState(() {
                              if (score <= 0 && _colorStatus[n] == 0) {
                                print('call is comingf here');
                                score = 0;
                                Navigator.of(context).pop();
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                          heightFactor: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? 0.3
                                              : 0.8,
                                          widthFactor: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? 0.7
                                              : 0.4,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Sorry Not Enough Coins',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ));
                                    });
                              } else if (_colorStatus[n] == 0) {
                                setState(() {
                                  score = score - 100;
                                });
                              }
                              _colorStatus[n] = 1;
                              // container.setAccessories(BuiltMap<String, String>(
                              //     {r.accessoryCategoryName: itemName}));
                              // print(container.state.userProfile);
                            });
                            print('coin in set Name is $score');
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

class StoreAccessoryButton extends StatefulWidget {
  int index;
  String imagePath;
  String name;
  List<String> itemNames = <String>[];
  int coin;
  int score;
  Color color;
  final Function toggleItem;
  final Function setName;
  List<int> colorStatus;
  StoreAccessoryButton({
    Key key,
    this.setName,
    this.toggleItem,
    this.itemNames,
    this.index,
    this.score,
    this.color,
    this.imagePath,
    this.coin,
    this.colorStatus,
    this.name,
  }) : super(key: key);

  @override
  _StoreAccessoryButtonState createState() => _StoreAccessoryButtonState();
}

class _StoreAccessoryButtonState extends State<StoreAccessoryButton> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.colorStatus[widget.index] == 1
                      ? Colors.yellow
                      : Colors.indigo[400],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.height * 0.07
                    : mediaQuery.size.height * 0.10,
                width: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.width * 0.14
                    : mediaQuery.size.width * 0.06,
                child: InkWell(
                    key: Key('key ${widget.index}'),
                    onTap: () {
                      print('coin in button is ${widget.score}');
                      if (widget.colorStatus[widget.index] != 1) {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return _showDialog(
                                  context, widget.name, widget.imagePath);
                            },
                          );
                        });
                      } else {
                        _toggleItem(widget.name);
                        widget.setName(widget.index);
                      }
                    },
                    child: SvgPicture.asset('${widget.imagePath}.svg')),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: mediaQuery.orientation == Orientation.portrait
                      ? mediaQuery.size.height * 0.018
                      : mediaQuery.size.height * 0.03,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle,
                    color: Colors.yellow[700],
                    size: 20.0,
                  ),
                  Text(
                    widget.coin.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _showDialog(BuildContext context, String text, String imagePath) {
    return FractionallySizedBox(
      heightFactor: MediaQuery.of(context).orientation == Orientation.portrait
          ? 0.3
          : 0.8,
      widthFactor: MediaQuery.of(context).orientation == Orientation.portrait
          ? 0.7
          : 0.4,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Do you want $text ?',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: 10),
                child: SizedBox(
                  child: SvgPicture.asset('${widget.imagePath}.svg'),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 3.0,
                  onPressed: () {
                    print('coin is ${widget.score}');
                    if (widget.score + 100 != 0) {
                      setState(() {
                        widget.setName(widget.index);
                      });
                    }
                    _toggleItem(widget.name);
                    Navigator.of(context).pop();
                  },
                  child: Text('BUY'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleItem(String item) {
    widget.itemNames.add(item);
  }
}
