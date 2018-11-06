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

class CardSummary extends StatelessWidget {
  final QuackCard card;
  final int index;
  final String parentCardId;
  final Orientation orientation;

  CardSummary(
      {Key key,
      @required this.card,
      this.index,
      this.parentCardId,
      this.orientation = Orientation.portrait})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = InkWell(
      onTap: () {
        if (card.type == CardType.knowledge) {
          Navigator.of(context).push(
            new MaterialPageRoute(builder: (BuildContext context) {
              Provider.dispatch<RootState>(
                  context, AddProgress(card: card, parentCardId: parentCardId));
              return CardPager(
                cardId: parentCardId,
                cardType: CardType.knowledge,
                initialPage: index,
              );
            }),
          );
        } else {
          Provider.dispatch<RootState>(context, FetchCardDetail(card.id));
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
      child: AspectRatio(
        child: CardHeader(
          card: card,
          parentCardId: parentCardId,
        ),
        aspectRatio: 1.0,
      ),
    );

    final header = Material(
        elevation: 8.0,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: card.type == CardType.concept
            ? Stack(
                children: <Widget>[
                  widget,
                  CardLock(
                    card: card,
                    parentCardId: parentCardId,
                  ),
                ],
              )
            : widget);
    final desc = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(card.title ?? '',
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                LikeButton(
                  parentId: card.id,
                  tileType: TileType.card,
                  isInteractive: false,
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
      ],
    );
    return orientation == Orientation.portrait
        ? Column(
            children: <Widget>[header, desc],
          )
        : Row(
            children: <Widget>[header, Expanded(child: desc)],
          );
  }
}
