import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:maui/state/app_state_container.dart';

class LoadActivitiesAction {}

class ActivitiesNotLoadedAction {}

class ActivitiesLoadedAction {
  final Map<String, UserActivity> activityMap;

  ActivitiesLoadedAction({this.activityMap});
}

class AddLikeAction {
  final String parentId;
  final TileType tileType;
  final String userId;

  AddLikeAction({this.parentId, this.tileType, this.userId});
}

class AddProgressAction {
  final String cardId;
  final String parentCardId;
  final int done;
  final int total;

  AddProgressAction({this.cardId, this.parentCardId, this.done, this.total});
}

ThunkAction<RedState> addLike(
    {String parentId, TileType tileType, String userId}) {
  return (Store<RedState> store) async {
    print('addLike');
    final user =
        userId == null ? store.state.user : await UserRepo().getUser(userId);
    final like = Like(
        id: Uuid().v4(),
        parentId: parentId,
        userId: userId ?? store.state.user.id,
        timeStamp: DateTime.now(),
        type: 0,
        user: user);
    LikeRepo().insert(like, tileType);

    final userActivity = store.state.activityMap[parentId] ?? UserActivity();
    if (userId == null) {
      userActivity.like = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userActivity', json.encode(store.state.activityMap));

      try {
        await p2p.addMessage(store.state.user.id, '0', 'like',
            '${tileType.index}${floresSeparator}$parentId', true, '');
      } on PlatformException {
        print('Flores: Failed addChat');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
    }

    print('dispatch: AddLikeAction');
    store.dispatch(
        AddLikeAction(parentId: parentId, tileType: tileType, userId: userId));
  };
}

ThunkAction<RedState> addProgress(
    {String cardId, String parentCardId, int index}) {
  return (Store<RedState> store) async {
    await CardProgressRepo().upsert(CardProgress(
        userId: store.state.user.id,
        cardId: cardId,
        updatedAt: DateTime.now()));
    final progress = await CardProgressRepo()
        .getProgressStatusByCollectionAndTypeAndUserId(
            parentCardId, CardType.knowledge, store.state.user.id);

    final userActivity =
        store.state.activityMap[parentCardId] ?? UserActivity();
    if ((userActivity.done ?? -1) < index) {
      userActivity.done = index;
      userActivity.total = userActivity.total ??
          await CollectionRepo()
              .getKnowledgeAndQuizCardCountInCollection(parentCardId);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      store.state.activityMap[parentCardId] = userActivity;
      prefs.setString('userActivity', json.encode(store.state.activityMap));
//      var frontMap = state.frontMap;
//      if (userActivity.done >= userActivity.total) {
//        frontMap = await FetchInitialData.fetchFrontMap(state);
//      }
    }
  };
}

ThunkAction<RedState> loadActivities() {
  return (Store<RedState> store) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userActivity = prefs.getString('userActivity');
    var activityMap = Map<String, UserActivity>();
    if (userActivity != null) {
      activityMap = Map.fromIterable(json.decode(userActivity).entries,
          key: (me) => me.key, value: (me) => UserActivity.fromJson(me.value));
    }
    store.dispatch(ActivitiesLoadedAction(activityMap: activityMap));
  };
}
