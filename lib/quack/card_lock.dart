import 'package:flutter/material.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/repos/card_progress_repo.dart';

class CardLock extends StatefulWidget {
  final QuackCard card;
  final String parentCardId;
  final String userId;

  const CardLock({Key key, this.card, this.parentCardId, this.userId})
      : super(key: key);
  @override
  CardLockState createState() {
    return new CardLockState();
  }
}

class CardLockState extends State<CardLock> {
  bool _isLoading = true;
  CardProgress _cardProgress;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(CardLock oldWidget) {
    if (widget.card != oldWidget.card) {
      _isLoading = true;
      _initData();
    }
  }

  void _initData() async {
    print('CardLock:_initData ${widget.card.id}');
    _cardProgress = await CardProgressRepo()
        .getCardProgressByCardIdAndUserId(widget.card.id, widget.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _isLoading
          ? null
          : _cardProgress == null
              ? _askToUnlock(context)
              : _goToCardDetail(context),
      child: Container(
        constraints: BoxConstraints.expand(),
      ),
    );
  }

  void _goToCardDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CardDetail(
              card: widget.card,
              parentCardId: widget.parentCardId,
            ),
      ),
    );
  }

  Future<Null> _askToUnlock(BuildContext context) async {
    await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('Unlock?'),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            })
        ? _goToCardDetail(context)
        : {};
  }
}
