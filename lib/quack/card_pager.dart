import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_comments.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/quack/knowledge_detail.dart';
import 'package:maui/quack/quiz_navigator.dart';
import 'package:maui/components/quiz_welcome.dart';
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
    return Connect<RootState, List<QuackCard>>(
      convert: (state) => state.collectionMap[widget.cardId]
          .map((id) => state.cardMap[id])
          .where((c) => c.type == widget.cardType)
          .toList(growable: false),
      where: (prev, next) => next != prev,
      builder: (cardList) {
        final widgets = <Widget>[
          Expanded(
            child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: cardList.length + 1,
                itemBuilder: (context, index) => index >= cardList.length
                    ? QuizWelcome(
                        cardId: widget.cardId,
                      )
                    : KnowledgeDetail(
//                    key: _cardDetailKeys[index],
                        card: cardList[index],
                        parentCardId: widget.cardId,
                        showBackButton: widget.cardId != 'main',
                      ),
                onPageChanged: (index) {
                  if (index < cardList.length) {
                    Provider.dispatch<RootState>(
                        context,
                        FetchComments(
                            parentId: cardList[index].id,
                            tileType: TileType.card));
                    Provider.dispatch<RootState>(
                        context,
                        AddProgress(
                            cardId: cardList[index].id,
                            parentCardId: widget.cardId,
                            index: index));
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
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
