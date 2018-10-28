import 'dart:async';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';

class AddProgress implements AsyncAction<RootState> {
  final QuackCard card;
  final String parentCardId;

  CardProgressRepo cardProgressRepo;

  AddProgress({this.card, this.parentCardId});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(cardProgressRepo != null, 'CardProgressRepo not injected');

    await cardProgressRepo.upsert(CardProgress(
        userId: state.user.id, cardId: card.id, updatedAt: DateTime.now()));
    final progress =
        await cardProgressRepo.getProgressStatusByCollectionAndTypeAndUserId(
            parentCardId, CardType.knowledge, state.user.id);

    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        likeMap: state.likeMap,
        comments: state.comments,
        progressMap: state.progressMap..[parentCardId] = progress);
  }
}
