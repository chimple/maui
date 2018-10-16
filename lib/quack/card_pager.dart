import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/repos/collection_repo.dart';

class CardPager extends StatefulWidget {
  final String cardId;
  final CardType cardType;
  final int initialPage;

  CardPager({Key key, this.cardId, this.cardType, this.initialPage});

  @override
  CardPagerState createState() {
    return new CardPagerState();
  }
}

class CardPagerState extends State<CardPager> {
  PageController _pageController;
  bool _isLoading = true;
  List<QuackCard> _cards;
  int _currentPageIndex;
  List<GlobalKey<CardDetailState>> _cardDetailKeys;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _currentPageIndex = widget.initialPage;
    _initData();
  }

  void _initData() async {
    _cards = await new CollectionRepo()
        .getCardsInCollectionByType(widget.cardId, widget.cardType);
    _cardDetailKeys =
        _cards.map((c) => GlobalKey<CardDetailState>()).toList(growable: false);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_currentPageIndex: $_currentPageIndex');
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    final widgets = <Widget>[
      Expanded(
        child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: _cards.length,
            itemBuilder: (context, index) => CardDetail(
                  key: _cardDetailKeys[index],
                  card: _cards[index],
                  parentCardId: widget.cardId,
                  showBackButton: widget.cardId != 'main',
                ),
            onPageChanged: (index) =>
                setState(() => _currentPageIndex = index)),
      )
    ];
    if (widget.cardId != 'main') {
      widgets.add(Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: _currentPageIndex == 0
                ? null
                : () async => await _pageController.previousPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn),
          ),
          Expanded(
            child: CommentTextField(
              parentId: _cards[_currentPageIndex].id,
              tileType: TileType.card,
              addComment: (comment) => _cardDetailKeys[_currentPageIndex]
                  .currentState
                  .initComments(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _currentPageIndex + 1 >= _cards.length
                ? null
                : () async => await _pageController.nextPage(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn),
          ),
        ],
      ));
    }
    return Scaffold(
      body: Column(children: widgets),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
