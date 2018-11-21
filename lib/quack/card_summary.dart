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
import 'package:maui/quack/social_summary.dart';

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
        child: widget);
    final stackChildren = <Widget>[
      header,
    ];
    if (card.type == CardType.concept) {
      stackChildren.add(CardLock(
        card: card,
        parentCardId: parentCardId,
      ));
    }
    final stackHeader = Stack(
      children: stackChildren,
      overflow: Overflow.visible,
    );
    final desc = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(card.title ?? '',
          style: Theme.of(context).textTheme.subhead,
          textAlign: TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis),
    );
    return Column(
      children: <Widget>[
        stackHeader,
        desc,
        SocialSummary(
          card: card,
          tileType: TileType.card,
        )
      ],
    );
  }
}
