import 'package:flutter/material.dart';
import 'package:maui/components/quiz_welcome.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/knowledge_detail.dart';

//TODO: pass cards
class CardPager extends StatefulWidget {
  final String cardId;
  final CardType cardType;
  final int initialPage;
  final List<QuackCard> cards;

  CardPager(
      {Key key, this.cardId, this.cardType, this.initialPage, this.cards});

  @override
  CardPagerState createState() {
    return new CardPagerState();
  }
}

class CardPagerState extends State<CardPager> {
  PageController _pageController;
//  bool _isLoading = true;
//  List<QuackCard> _cards;
  int _currentPageIndex;
//  List<GlobalKey<CardDetailState>> _cardDetailKeys;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _currentPageIndex = widget.initialPage;
//    _initData();
  }

//  void _initData() async {
//    _cards = await new CollectionRepo()
//        .getCardsInCollectionByType(widget.cardId, widget.cardType);
////    _cardDetailKeys =
////        _cards.map((c) => GlobalKey<CardDetailState>()).toList(growable: false);
//    setState(() => _isLoading = false);
//  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      Expanded(
        child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.cards.length + 1,
            itemBuilder: (context, index) => index >= widget.cards.length
                ? QuizWelcome(
                    cardId: widget.cardId,
                  )
                : KnowledgeDetail(
//                    key: _cardDetailKeys[index],
                    card: widget.cards[index],
                    parentCardId: widget.cardId,
                    showBackButton: widget.cardId != 'main',
                  ),
            onPageChanged: (index) {
              if (index < widget.cards.length) {
//                    Provider.dispatch<RootState>(
//                        context,
//                        FetchComments(
//                            parentId: cardList[index].id,
//                            tileType: TileType.card));
//                    Provider.dispatch<RootState>(
//                        context,
//                        AddProgress(
//                            cardId: cardList[index].id,
//                            parentCardId: widget.cardId,
//                            index: index));
              }
              setState(() => _currentPageIndex = index);
            }),
      )
    ];
//        if (widget.cardId != 'main' && _currentPageIndex < cardList.length) {
//          widgets.add(Row(
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.chevron_left),
//                onPressed: _currentPageIndex == 0
//                    ? null
//                    : () async => await _pageController.previousPage(
//                        duration: Duration(milliseconds: 250),
//                        curve: Curves.fastOutSlowIn),
//              ),
//              Expanded(
//                child: CommentTextField(
//                  parentId: cardList[_currentPageIndex].id,
//                  tileType: TileType.card,
//                ),
//              ),
//              IconButton(
//                icon: Icon(Icons.chevron_right),
//                onPressed: _currentPageIndex >= cardList.length
//                    ? null
//                    : () async => await _pageController.nextPage(
//                        duration: Duration(milliseconds: 250),
//                        curve: Curves.fastOutSlowIn),
//              ),
//            ],
//          ));
//        }
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
