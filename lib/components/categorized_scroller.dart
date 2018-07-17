import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/screens/chat_screen.dart';

typedef Widget BuildItem(String text, bool enabled);

class CategorizedScroller extends StatefulWidget {
  final OnUserPress onUserPress;
  final Map<String, List<String>> items;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;

  const CategorizedScroller(
      {this.onUserPress,
      this.items,
      this.itemCrossAxisCount = 5,
      this.buildItem,
      this.buildIndexItem});

  @override
  CategorizedScrollerState createState() {
    return new CategorizedScrollerState();
  }
}

class CategorizedScrollerState extends State<CategorizedScroller> {
  ScrollController _scrollController;
  int _itemCount = 0;
  List<Tuple3<String, int, int>> _itemRange = List<Tuple3<String, int, int>>();
  String highlightedItem;

  @override
  void initState() {
    super.initState();
    widget.items.forEach((e, l) {
      _itemRange.add(Tuple3(e, _itemCount,
          _itemCount + (l.length / widget.itemCrossAxisCount).ceil()));
      _itemCount += (l.length / widget.itemCrossAxisCount).ceil();
    });
    highlightedItem = _itemRange.first.item1;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _itemCount *
          _scrollController.offset /
          (_scrollController.position.maxScrollExtent +
              _scrollController.position.viewportDimension -
              8.0);
      final highlight = _itemRange.firstWhere((e) => e.item3 >= offset);
      setState(() {
        highlightedItem = highlight.item1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: widget.itemCrossAxisCount * 2,
            child: Container(
              color: Color(0XFFF4F4F4),
              child: CustomScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  slivers: widget.items.keys
                      .map((e) => SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: widget.itemCrossAxisCount),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                    onTap: () => widget
                                        .onUserPress(widget.items[e][index]),
                                    child: widget.buildItem(
                                        widget.items[e][index], true)),
                              );
                            }, childCount: widget.items[e].length),
                          ))
                      .toList(growable: false)),
            )),
        Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _itemRange
                  .map((e) => Container(
                        color: e.item1 == highlightedItem
                            ? Color(0XFFF4F4F4)
                            : Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              final offset =
                                  (_scrollController.position.maxScrollExtent +
                                          _scrollController
                                              .position.viewportDimension) *
                                      e.item2 /
                                      _itemCount;
//                          _scrollController.animateTo(offset,
//                              duration: Duration(milliseconds: 500),
//                              curve: ElasticInCurve());
                              _scrollController.jumpTo(offset);
                            },
                            child: widget.buildIndexItem(
                                e.item1, e.item1 == highlightedItem)),
                      ))
                  .toList(growable: false),
            ))
      ],
    );
  }
}
