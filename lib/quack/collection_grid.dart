import 'package:flutter/material.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/collection_repo.dart';

class CollectionGrid extends StatefulWidget {
  final String cardId;
  final CardType cardType;

  CollectionGrid({key, @required this.cardId, @required this.cardType})
      : super(key: key);
  @override
  _CollectionGridState createState() => new _CollectionGridState();
}

class _CollectionGridState extends State<CollectionGrid> {
  List<QuackCard> _cards;
  bool _isLoading = true;

  void _initData() async {
    _cards = await CollectionRepo()
        .getCardsInCollectionByType(widget.cardId, widget.cardType);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  List<Widget> _buildList() {
    int index = 0;
    return _cards
        .map((a) => CardSummary(
              card: a,
              index: index++,
              parentCardId: widget.cardId,
            ))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: widget.cardType == CardType.knowledge ? 2 : 3,
      childAspectRatio: widget.cardType == CardType.knowledge ? 3.0 : 1.0,
      children: _isLoading
          ? _buildList()
          : <Widget>[
              Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: new CircularProgressIndicator(),
                ),
              )
            ],
    );
  }
}
