import 'package:flutter/material.dart';
import 'package:maui/components/card_button.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/collection_repo.dart';

class TopicCardView extends StatefulWidget {
  final String topicId;
  final CardType cardType;

  TopicCardView({key, @required this.topicId, @required this.cardType})
      : super(key: key);
  @override
  _TopicCardViewState createState() => new _TopicCardViewState();
}

class _TopicCardViewState extends State<TopicCardView> {
  List<QuackCard> _cards;
  bool _isDataAvailable = false;

  void _initArticles() async {
    _cards = await CollectionRepo()
        .getCardsInCollectionByType(widget.topicId, widget.cardType);
    print(_cards);
    setState(() {
      _isDataAvailable = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initArticles();
  }

  List<Widget> _buildList() {
    return _cards
        .map((a) => CardButton(
              text: a.title,
              image: a.header,
              id: a.id,
              topicId: widget.topicId,
              cardType: widget.cardType,
            ))
        .toList(growable: false);
//  _cards.map((a) => Text(a.title)).toList(growable: false)
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return SliverGrid.count(
      crossAxisCount: media.size.height > media.size.width ? 3 : 4,
      childAspectRatio: 0.8,
      children: _isDataAvailable
          ? _buildList()
          : <Widget>[
              Container(
                child: new Center(
                  child: new Text(
                    Loca.of(context).no_data,
                    style: new TextStyle(
                        fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
    );
  }
}
