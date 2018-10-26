import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/quack/like_button.dart';
import 'package:maui/state/app_state_container.dart';

class ConceptCard extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;
  final int likes;
  final int points;
  final double progress;

  const ConceptCard(
      {Key key,
      @required this.card,
      this.parentCardId,
      this.likes,
      this.points,
      this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = AppStateContainer.of(context).state.loggedInUser.id;
    return InkWell(
      onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CardDetail(
                    card: card,
                    parentCardId: parentCardId,
                  ),
            ),
          ),
      child: Column(
        children: <Widget>[
          AspectRatio(
            child: CardHeader(
              card: card,
              parentCardId: parentCardId,
            ),
            aspectRatio: 1.78,
          ),
          CollectionProgressIndicator(collectionId: card.id, userId: userId),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(card.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                LikeButton(
                  parentId: card.id,
                  tileType: TileType.card,
                  userId: userId,
                ),
                Text("${card.likes ?? ''}"),
              ]),
              Row(children: <Widget>[
                Icon(Icons.comment),
                Text("${card.comments ?? ''}")
              ])
            ],
          )
        ],
      ),
    );
  }
}
