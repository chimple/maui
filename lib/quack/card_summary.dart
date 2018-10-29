import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_lock.dart';
import 'package:maui/quack/card_pager.dart';
import 'package:maui/quack/like_button.dart';

final cardTypeColors = {
  CardType.knowledge: Color(0xff99CE34),
  CardType.concept: Color(0xffF5C851),
  CardType.activity: Color(0xffE84D4D),
  CardType.question: Color(0xff3CC1EF)
};

class CardSummary extends StatelessWidget {
  final QuackCard card;
  final int index;
  final String parentCardId;

  static final cardTypeAspectRatio = {
    CardType.knowledge: 1.0,
    CardType.concept: 1.0,
    CardType.activity: 1.0,
    CardType.question: 1.0
  };

  CardSummary({Key key, @required this.card, this.index, this.parentCardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.0,
          child: Card(
            color: cardTypeColors[card.type],
            margin: EdgeInsets.all(8.0),
            elevation: 8.0,
            child: InkWell(
              onTap: () {
                if (card.type == CardType.knowledge) {
                  Navigator.of(context).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                      Provider.dispatch<RootState>(context,
                          AddProgress(card: card, parentCardId: parentCardId));
                      return CardPager(
                        cardId: parentCardId,
                        cardType: CardType.knowledge,
                        initialPage: index,
                      );
                    }),
                  );
                } else {
                  Provider.dispatch<RootState>(
                      context, FetchCardDetail(card.id));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        print('MaterialPageRoute: CardDetail: $card');
                        return CardDetail(
                          card: card,
                          parentCardId: parentCardId,
                        );
                      },
                    ),
                  );
                }
              },
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: AspectRatio(
                      child: CardHeader(
                        card: card,
                        parentCardId: parentCardId,
                      ),
                      aspectRatio: 1.78,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(card.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  LikeButton(
                    parentId: card.id,
                    tileType: TileType.card,
                  ),
                  Text("${card.likes ?? ''}"),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.comment),
                  Text("${card.comments ?? ''}")
                ],
              )
            ],
          ),
        )
      ],
    );
    return card.type == CardType.concept
        ? Stack(
            children: <Widget>[
              summary,
              CardLock(
                card: card,
                parentCardId: parentCardId,
              ),
            ],
          )
        : summary;
  }
}
