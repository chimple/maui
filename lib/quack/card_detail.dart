import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:maui/app.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/quack/drawing_grid.dart';
import 'package:maui/quack/header_app_bar.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';

class CardDetail extends StatefulWidget {
  final QuackCard card;
  final String parentCardId;
  final bool showBackButton;
  final GlobalKey<CommentListState> commentListKey;

  CardDetail(
      {key,
      @required this.card,
      this.parentCardId,
      this.showBackButton = true,
      this.commentListKey})
      : super(key: key);

  @override
  CardDetailState createState() {
    return new CardDetailState();
  }
}

class CardDetailState extends State<CardDetail> with RouteAware {
  List<QuackCard> _cards;
  List<Tile> _drawings;
  bool _isLoading = true;
  GlobalKey<CommentListState> _commentListKey;

  @override
  void initState() {
    super.initState();
    _initData();
    _commentListKey = widget.commentListKey ?? GlobalKey<CommentListState>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = AppStateContainer.of(context).state.loggedInUser;
      CardProgressRepo().upsert(CardProgress(
          userId: user.id, cardId: widget.card.id, updatedAt: DateTime.now()));
      TileRepo().upsertByCardIdAndUserIdAndType(
          widget.card.id, user.id, TileType.card);
    });
  }

  void _initData() async {
    _cards = await CollectionRepo().getCardsInCollection(widget.card.id);
    if (widget.card.type == CardType.activity) {
      _drawings = await TileRepo()
          .getTilesByCardIdAndType(widget.card.id, TileType.drawing);
    }
    setState(() => _isLoading = false);
  }

  void initComments() async {
    _commentListKey.currentState.initData();
  }

  @override
  Widget build(BuildContext context) {
    final scrollViewWidgets = <Widget>[
      HeaderAppBar(
        card: widget.card,
        parentCardId: widget.parentCardId,
        showBackButton: widget.showBackButton,
      )
    ];

    if (!_isLoading && widget.card.type == CardType.activity) {
      scrollViewWidgets.add(DrawingGrid(
        cardId: widget.card.id,
        drawings: _drawings,
      ));
    }
    scrollViewWidgets.add(SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: MarkdownBody(
          data: widget.card.content ?? '',
          styleSheet: new MarkdownStyleSheet(
              p: new TextStyle(fontSize: 16.0, color: Colors.black))),
    )));
    if (!_isLoading) {
      scrollViewWidgets.addAll([
        CollectionGrid(
          cardId: widget.card.id,
          cardType: CardType.activity,
          cards: _cards
              .where((c) => c.type == CardType.activity)
              .toList(growable: false),
        ),
        CollectionGrid(
          cardId: widget.card.id,
          cardType: CardType.knowledge,
          cards: _cards
              .where((c) => c.type == CardType.knowledge)
              .toList(growable: false),
        ),
        CollectionGrid(
          cardId: widget.card.id,
          cardType: CardType.concept,
          cards: _cards
              .where((c) => c.type == CardType.concept)
              .toList(growable: false),
        )
      ]);
    }
    scrollViewWidgets.add(CommentList(
      key: _commentListKey,
      parentId: widget.card.id,
      tileType: TileType.card,
    ));

    final widgets = <Widget>[
      Expanded(
        child: CustomScrollView(
          slivers: scrollViewWidgets,
        ),
      )
    ];
    if (widget.showBackButton &&
        (widget.card.type == CardType.concept ||
            widget.card.type == CardType.activity)) {
      widgets.add(CommentTextField(
          parentId: widget.card.id,
          tileType: TileType.card,
          addComment: (comment) =>
              _commentListKey.currentState.addComment(comment)));
    }
    return widget.card.type == CardType.knowledge
        ? Column(
            children: widgets,
          )
        : Scaffold(
            body: Column(
              children: widgets,
            ),
          );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void didPopNext() {
    _initData();
  }
}
