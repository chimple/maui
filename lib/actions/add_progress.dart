import 'dart:async';
import 'dart:convert';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/log_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProgress implements AsyncAction<RootState> {
  final String cardId;
  final String parentCardId;
  final int index;

  CardProgressRepo cardProgressRepo;
  CollectionRepo collectionRepo;

  AddProgress({this.cardId, this.parentCardId, this.index});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(cardProgressRepo != null, 'CardProgressRepo not injected');
    assert(collectionRepo != null, 'collectionRepo not injected');

    await cardProgressRepo.upsert(CardProgress(
        userId: state.user.id, cardId: cardId, updatedAt: DateTime.now()));
    final progress =
        await cardProgressRepo.getProgressStatusByCollectionAndTypeAndUserId(
            parentCardId, CardType.knowledge, state.user.id);

    final userActivity = state.activityMap[parentCardId] ?? UserActivity();
    var frontMap = state.frontMap;
    if ((userActivity.done ?? -1) < index) {
      userActivity.done = index;
      userActivity.total = userActivity.total ??
          await collectionRepo
              .getKnowledgeAndQuizCardCountInCollection(parentCardId);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      state.activityMap[parentCardId] = userActivity;
      prefs.setString('userActivity', json.encode(state.activityMap));
      if (userActivity.done >= userActivity.total) {
        frontMap = await FetchInitialData.fetchFrontMap(state);
      }
      writeLog('progress,$parentCardId,$cardId,$index,${userActivity.total}');
    }

    return (RootState state) => RootState(
        frontMap: frontMap,
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap..[parentCardId] = userActivity,
        commentMap: state.commentMap,
        tiles: state.tiles,
        userMap: state.userMap,
        drawings: state.drawings,
        templates: state.templates);
  }
}
