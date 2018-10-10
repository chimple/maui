import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_detail.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _initData();
  }

  void _initData() async {
    _cards = await new CollectionRepo()
        .getCardsInCollectionByType(widget.cardId, widget.cardType);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: _cards.length,
        itemBuilder: (context, index) => CardDetail(
              card: _cards[index],
              showBackButton: widget.cardId != 'main',
            ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
