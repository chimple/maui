import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/models/rewards_data.dart';
import 'package:tahiti/activity_board.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_svg/svg.dart';

class ShowRewards extends StatefulWidget {
  final Map<RewardData, List<RewardCategory>> rewardList;
  final BuiltMap<String, int> items;

  const ShowRewards({Key key, this.rewardList, this.items}) : super(key: key);
  @override
  _ShowRewardsState createState() => _ShowRewardsState();
}

class _ShowRewardsState extends State<ShowRewards>
    with SingleTickerProviderStateMixin {
  PageController pageController = new PageController();
  List<Tuple4<String, String, int, int>> itemRange =
      List<Tuple4<String, String, int, int>>();

  int _itemCount = 0;
  int itemCrossAxisCount = 4;
  List<int> colorStatus = [];
  List<String> categoryList = [];
  List<String> rewardImageList = [];
  List<String> dummyList = [];
  String highlightedItem;
  int flag = 0;
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    widget.rewardList.forEach((e, l) {
      itemRange.add(Tuple4(e.categoryName, e.categoryImagePath, _itemCount,
          _itemCount + (l.length / itemCrossAxisCount).ceil()));
      _itemCount += (l.length / itemCrossAxisCount).ceil();
      categoryList.add(e.categoryName);
    });
    print(widget.items);
    // var totalRewards =
    //     widget.rewardList.values.map((v) => v.length).reduce((a, b) => a + b);

    widget.items.forEach((k, v) {
      colorStatus.add(v);
      dummyList.add(k);
    });
    for (int i = 0; i < dummyList.length; i++) {
      if (colorStatus[i] == 1) {
        rewardImageList.add(dummyList[i]);
      }
    }
    print('imagelist is $rewardImageList');
    print('color Status is  is $colorStatus');

    highlightedItem = itemRange.first.item1;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = -1;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: topContent(),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 5.0))),
            ),
          ),
          Expanded(
            flex: 70,
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: widget.rewardList.keys.map((d) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          d.categoryName,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 15,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: GridView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 16.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20.0,
                                  childAspectRatio: 0.9,
                                  crossAxisCount: 5),
                          children: widget.rewardList[d].map((f) {
                            index++;
                            return Container(
                              key: Key('index $index'),
                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        backgroundColor: index <= 7
                                            ? colorStatus[index] == 0
                                                ? Colors.grey
                                                : Colors.white
                                            : Colors.grey,
                                        child: AspectRatio(
                                          aspectRatio: 2.0,
                                          child: SvgPicture.asset(
                                            f.rewardItemImagePath,
                                            package: 'tahiti',
                                            color: index <= 7
                                                ? colorStatus[index] == 0
                                                    ? Colors.red
                                                        .withOpacity(0.3)
                                                    : null
                                                : Colors.red.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          f.rewardItemName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          }).toList(growable: false),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(growable: false),
            ),
          ),
          Expanded(flex: 12, child: mainCategoryList()),
        ],
      ),
    );
  }

  Widget mainCategoryList() {
    int index = 0;
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange[300],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                scrollDirection: Axis.horizontal,
                children: itemRange.map((f) {
                  return buildIndexItem(context, f.item1, f.item2,
                      f.item1 == highlightedItem, index++);
                }).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.yellow,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ),
        Text(
          'Map',
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.yellow,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(4.0, 4.0),
                blurRadius: 3.0,
                color: Colors.grey,
              ),
              Shadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 8.0,
                  color: Colors.grey),
            ],
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.ac_unit,
              // size: 60.0,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                ActivityBoard(
                  rewardImageList: rewardImageList,
                );
              });
              print('reward list on pop is  $rewardImageList');
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Widget buildIndexItem(BuildContext context, String text, String imagePath,
      bool enabled, int index) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      child: InkWell(
        onTap: () {
          print('index is $index');
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          setState(() {
            flag = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Image.asset(
                imagePath,
                color: flag == index ? Colors.red : null,
                package: 'tahiti',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: TextStyle(color: flag == index ? Colors.red : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
