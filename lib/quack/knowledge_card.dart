import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_pager.dart';

class KnowledgeCard extends StatelessWidget {
  final QuackCard card;
  final int index;
  final String parentCardId;

  const KnowledgeCard(
      {Key key,
      @required this.card,
      @required this.index,
      @required this.parentCardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => CardPager(
                      cardId: parentCardId,
                      initialPage: index,
                      cardType: CardType.knowledge,
                    )),
          ),
      child: Row(
        children: <Widget>[
          AspectRatio(
            child: CardHeader(card: card),
            aspectRatio: 1.78,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(card.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          )
        ],
      ),
    );
  }
}
