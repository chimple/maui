import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_comments.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/social_summary.dart';
import 'package:maui/quack/tile_detail.dart';

class TileCard extends StatelessWidget {
  final Tile tile;

  const TileCard({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tile.type) {
      case TileType.card:
        return _buildTile(
            context: context,
            tile: tile,
            header: CardHeader(
              card: tile.card,
            ),
            title: tile.card.title,
            trailer: SocialSummary(
              parentId: tile.cardId,
              likes: tile.card.likes,
              comments: tile.card.comments,
              tileType: tile.type,
            ));
        break;
      case TileType.drawing:
        return _buildTile(
            context: context,
            tile: tile,
            header: DrawingCard(
              tile: tile,
              isInteractive: false,
            ),
            title: tile.card.title,
            user: tile.user,
            trailer: SocialSummary(
              parentId: tile.id,
              likes: tile.likes,
              comments: tile.comments,
              tileType: tile.type,
            ));
        break;
      case TileType.message:
        return _buildTile(
            context: context,
            tile: tile,
            header: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/comment_icon.png'),
            ),
            title: tile.content,
            user: tile.user,
            trailer: SocialSummary(
              parentId: tile.id,
              likes: tile.likes,
              comments: tile.comments,
              tileType: tile.type,
            ));
        break;
      case TileType.dot:
        return Container();
        break;
    }
  }

  Widget _buildTile(
      {BuildContext context,
      Tile tile,
      Widget header,
      String title,
      Widget trailer,
      User user}) {
    return InkWell(
      onTap: () {
        Provider.dispatch<RootState>(
            context,
            FetchComments(
                parentId: tile.type == TileType.card ? tile.card.id : tile.id,
                tileType: tile.type));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TileDetail(tile: tile)));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widgets = <Widget>[];
          widgets.add(Stack(
            children: <Widget>[
              SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxHeight,
                  child: header),
              Positioned(bottom: 0, left: 0, right: 0, child: trailer)
            ],
          ));
          final columnWidgets = <Widget>[];
          if (user != null) {
            columnWidgets.add(Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: FileImage(
                      File(user.image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                  child: Text(
                    user.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ));
          }
          columnWidgets.add(Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ));
          widgets.add(Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnWidgets,
            ),
          ));
          return Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
        },
      ),
    );
  }
}
