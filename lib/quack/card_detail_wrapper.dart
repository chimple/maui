import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/repos/card_repo.dart';

class CardDetailWrapper extends StatefulWidget {
  final String cardId;
  bool showBackButton;

  CardDetailWrapper({Key key, this.cardId, this.showBackButton = true})
      : super(key: key);

  @override
  CardDetailWrapperState createState() {
    return new CardDetailWrapperState();
  }
}

class CardDetailWrapperState extends State<CardDetailWrapper> {
  bool _isLoading = true;
  QuackCard _card;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _card = await CardRepo().getCard(widget.cardId);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return CardDetail(
      card: _card,
      parentCardId: widget.cardId,
      showBackButton: widget.showBackButton,
    );
  }
}
