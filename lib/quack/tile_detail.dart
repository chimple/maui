import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/quiz_open_detail.dart';

class TileDetail extends StatelessWidget {
  final Tile tile;

  const TileDetail({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tile.type) {
      case TileType.drawing:
        return DrawingDetail(tile: tile);
      case TileType.message:
        return PostDetail(tile: tile);
      case TileType.card:
        return TileCardDetail(tile: tile);
      case TileType.dot:
        return Container();
    }
  }
}

class TileCardDetail extends StatelessWidget {
  final Tile tile;

  const TileCardDetail({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: media.size.height / 4,
                child: CardHeader(
                  card: tile.card,
                  parentCardId: 'open',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: tile.card.title == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tile.card.title ?? '',
                          style: Theme.of(context).textTheme.display1),
                    ),
            ),
            CommentList(
              parentId: tile.cardId,
              tileType: tile.type,
              showInput: false,
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(32.0))),
            color: Color(0xFF0E4476),
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              Provider.dispatch<RootState>(
                  context, FetchCardDetail(tile.card.id));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) {
                  return tile.card.type == CardType.question
                      ? QuizOpenDetail(
                          card: tile.card,
                        )
                      : CardDetail(
                          card: tile.card,
                          parentCardId: tile.cardId,
                        );
                },
              ));
            },
            child: Text(
              Loca.of(context).answerThis,
              style: TextStyle(color: Colors.white, fontSize: 32.0),
            ),
          ),
        )
      ],
    ));
  }
}

class DrawingDetail extends StatelessWidget {
  final Tile tile;

  const DrawingDetail({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(tile.card.title)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: CustomScrollView(slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: FileImage(
                            File(tile.user.image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tile.user.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: DrawingCard(
                    tile: tile,
                    isInteractive: false,
                  ),
                ),
                CommentList(
                  parentId: tile.id,
                  tileType: tile.type,
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(32.0))),
                color: Color(0xFF0E4476),
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Provider.dispatch<RootState>(
                      context, FetchCardDetail(tile.card.id));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => CardDetail(
                          card: tile.card,
                        ),
                  ));
                },
                child: Text(
                  Loca.of(context).draw,
                  style: TextStyle(color: Colors.white, fontSize: 32.0),
                ),
              ),
            )
          ],
        ));
  }
}

class PostDetail extends StatelessWidget {
  final Tile tile;

  const PostDetail({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Loca.of(context).post)),
      body: CustomScrollView(slivers: <Widget>[
        SliverToBoxAdapter(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: FileImage(
                    File(tile.user.image),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tile.user.name,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(tile.content),
          ),
        ),
        CommentList(
          parentId: tile.id,
          tileType: tile.type,
        )
      ]),
    );
  }
}
