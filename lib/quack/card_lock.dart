import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/repos/card_progress_repo.dart';

class CardLock extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;

  const CardLock({Key key, this.card, this.parentCardId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Connect<RootState, double>(
      convert: (state) => state.progressMap[card.id],
      where: (prev, next) => next != prev,
      builder: (progress) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: progress == null
              ? InkWell(
                  onTap: () => _askToUnlock(context),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      color: Color(0x99999999),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CollectionProgressIndicator(collectionId: card.id)),
        );
      },
      nullable: true,
    );
  }

  void _goToCardDetail(BuildContext context) {
    Provider.dispatch<RootState>(context, FetchCardDetail(card.id));
    Provider.dispatch<RootState>(
        context, AddProgress(card: card, parentCardId: card.id));
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => CardDetail(
                card: card,
                parentCardId: parentCardId,
              )),
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
