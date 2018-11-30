import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/app.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_pager.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/quack/activity_drawing_grid.dart';
import 'package:maui/quack/header_app_bar.dart';
import 'package:maui/quack/knowledge_button.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';

class CardDetail extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;
  final bool showBackButton;
//  final GlobalKey<CommentListState> commentListKey;

  CardDetail(
      {key, @required this.card, this.parentCardId, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollViewWidgets = <Widget>[
      HeaderAppBar(
        card: card,
        parentCardId: parentCardId,
        showBackButton: showBackButton,
      )
    ];

    if (card.type == CardType.activity) {
      scrollViewWidgets.add(ActivityDrawingGrid(cardId: card.id));
    }
    scrollViewWidgets.add(SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        card.content ?? '',
        style: Theme.of(context).textTheme.display1,
      ),
    )));
    scrollViewWidgets.addAll([
      SliverToBoxAdapter(
        child: CollectionGrid(
          cardId: card.id,
          cardType: CardType.activity,
        ),
      ),
    ]);
    if (showBackButton &&
        (card.type == CardType.concept || card.type == CardType.activity)) {
      scrollViewWidgets.add(CommentList(
        parentId: card.id,
        tileType: TileType.card,
      ));
    }
    final widgets = <Widget>[
      Expanded(
        child: CustomScrollView(
          slivers: scrollViewWidgets,
        ),
      )
    ];
    if (card.type == CardType.concept) {
      widgets.add(KnowledgeButton(cardId: card.id));
    }

    return card.type == CardType.knowledge
        ? Column(
            children: widgets,
          )
        : Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgets,
            ),
          );
  }

//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    routeObserver.subscribe(this, ModalRoute.of(context));
//  }
//
//  @override
//  void dispose() {
//    routeObserver.unsubscribe(this);
//    super.dispose();
//  }
//
//  void didPopNext() {
//    _initData();
//  }
}
