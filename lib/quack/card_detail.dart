import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/drawing_grid.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';

class CardDetail extends StatefulWidget {
  final QuackCard card;
  final String parentCardId;
  bool showBackButton;

  CardDetail(
      {key, @required this.card, this.parentCardId, this.showBackButton = true})
      : super(key: key);

  @override
  CardDetailState createState() {
    return new CardDetailState();
  }
}

class CardDetailState extends State<CardDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = AppStateContainer.of(context).state.loggedInUser;
      CardProgressRepo().upsert(CardProgress(
          userId: user.id, cardId: widget.card.id, updatedAt: DateTime.now()));
      TileRepo().upsertByCardIdAndUserIdAndType(
          widget.card.id, user.id, TileType.card);
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return new Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: widget.showBackButton,
          expandedHeight: media.size.height / 4,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget.card.title),
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CardHeader(
                  card: widget.card,
                  parentCardId: widget.parentCardId,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, -0.4),
                      colors: <Color>[Color(0x60000000), Color(0x00000000)],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        widget.card.type == CardType.activity
            ? DrawingGrid(
                cardId: widget.card.id,
              )
            : SliverToBoxAdapter(child: Container()),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(
              data: widget.card.content ?? '',
              styleSheet: new MarkdownStyleSheet(
                  p: new TextStyle(fontSize: 16.0, color: Colors.black))),
        )),
        CollectionGrid(
          cardId: widget.card.id,
          cardType: CardType.activity,
        ),
        CollectionGrid(
          cardId: widget.card.id,
          cardType: CardType.knowledge,
        ),
        CollectionGrid(
          cardId: widget.card.id,
          cardType: CardType.concept,
        )
      ],
    ));
  }
}
