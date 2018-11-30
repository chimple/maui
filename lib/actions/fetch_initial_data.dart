import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:maui/quack/user_activity.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/repos/user_repo.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/like_repo.dart';

class FetchInitialData implements AsyncAction<RootState> {
  final User user;

  CollectionRepo collectionRepo;
  CardProgressRepo cardProgressRepo;
  LikeRepo likeRepo;
  TileRepo tileRepo;
  UserRepo userRepo;
  CardRepo cardRepo;

  FetchInitialData(this.user);

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(collectionRepo != null, 'collectionRepo not injected');
    assert(cardProgressRepo != null, 'cardProgressRepo not injected');
    assert(likeRepo != null, 'likeRepo not injected');
    assert(tileRepo != null, 'tileRepo not injected');
    assert(userRepo != null, 'userRepo not injected');
    assert(cardRepo != null, 'cardRepo not injected');

    final cardMap = Map<String, QuackCard>();
    final collectionMap = Map<String, List<String>>();
    final progressMap = Map<String, double>();
    final likeMap = Map<String, Like>();
    var activityMap = Map<String, UserActivity>();
    await fetchCollection(
        name: 'main',
        cardMap: cardMap,
        collectionMap: collectionMap,
        progressMap: progressMap,
        likeMap: likeMap);
    await fetchCollection(
        name: 'story',
        cardMap: cardMap,
        collectionMap: collectionMap,
        progressMap: progressMap,
        likeMap: likeMap);
    await fetchCollection(
        name: 'open',
        cardMap: cardMap,
        collectionMap: collectionMap,
        progressMap: progressMap,
        likeMap: likeMap);
    final dummy = await cardRepo.getCard('dummy');
    cardMap['dummy'] = dummy;
    print('open ${collectionMap['open']}');
    final tiles = await tileRepo.getTilesOtherThanDots();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userActivity = prefs.getString('userActivity');
    if (userActivity != null) {
      activityMap = Map.fromIterable(json.decode(userActivity).entries,
          key: (me) => me.key, value: (me) => UserActivity.fromJson(me.value));
    }

    final userList = await userRepo.getRemoteUsers();
    final botUser = await userRepo.getUser(User.botId);
    userList.insert(0, botUser);
    Map<User, int> userMap =
        Map.fromIterable(userList, key: (u) => u, value: (u) => 0);
    final frontMap = await fetchFrontMap(
        RootState(cardMap: cardMap, collectionMap: collectionMap));
    return (RootState state) => RootState(
        frontMap: frontMap,
        user: user,
        collectionMap: state.collectionMap..addAll(collectionMap),
        cardMap: state.cardMap..addAll(cardMap),
        activityMap: activityMap,
        tiles: tiles,
        drawings: state.drawings,
        userMap: userMap,
        templates: state.templates,
        commentMap: {});
  }

  Future<void> fetchCollection(
      {String name,
      Map<String, QuackCard> cardMap,
      Map<String, List<String>> collectionMap,
      Map<String, double> progressMap,
      Map<String, Like> likeMap}) async {
    final mainCards =
        (await collectionRepo.getCardsInCollection(name)).map((c) {
      cardMap[c.id] = c;
      return c.id;
    }).toList(growable: false);
    collectionMap[name] = mainCards;

    await Future.forEach(mainCards, (mc) async {
      final cardNames =
          (await collectionRepo.getCardsInCollection(mc)).map((c) {
        cardMap[c.id] = c;
        return c.id;
      }).toList(growable: false);

      collectionMap[mc] = cardNames;
    });
  }

  static Future<Map<String, QuackCard>> fetchFrontMap(RootState state) async {
    final rand = Random();
    final openCollection = state.collectionMap['open'];
    final mainCollection = state.collectionMap['main'];
    final topic = mainCollection[rand.nextInt(mainCollection.length)];
    final topicCollection = state.collectionMap[topic];
    final storyCollection = state.collectionMap['story'];

    return {
      'open':
          state.cardMap[openCollection[rand.nextInt(openCollection.length)]],
      'topic':
          state.cardMap[topicCollection[rand.nextInt(topicCollection.length)]],
      'story':
          state.cardMap[storyCollection[rand.nextInt(storyCollection.length)]]
    };
  }
}
