import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/drawing_grid.dart';

class CardDetail extends StatelessWidget {
  final QuackCard card;
  bool showBackButton;

  CardDetail({key, @required this.card, this.showBackButton = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return new Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: showBackButton,
          expandedHeight: media.size.height / 4,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(card.title),
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CardHeader(card: card),
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
        card.type == CardType.activity
            ? DrawingGrid(
                cardId: card.id,
              )
            : SliverToBoxAdapter(child: Container()),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(
              data: card.content ?? '',
              styleSheet: new MarkdownStyleSheet(
                  p: new TextStyle(fontSize: 16.0, color: Colors.black))),
        )),
        CollectionGrid(
          cardId: card.id,
          cardType: CardType.activity,
        ),
        CollectionGrid(
          cardId: card.id,
          cardType: CardType.knowledge,
        ),
        CollectionGrid(
          cardId: card.id,
          cardType: CardType.concept,
        )
      ],
    ));
  }
}
