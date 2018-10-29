import 'dart:async';

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

  FetchInitialData(this.user);

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(collectionRepo != null, 'collectionRepo not injected');
    assert(cardProgressRepo != null, 'cardProgressRepo not injected');
    assert(likeRepo != null, 'likeRepo not injected');

    final cardMap = Map<String, QuackCard>();
    final collectionMap = Map<String, List<String>>();
    final progressMap = Map<String, double>();
    final likeMap = Map<String, Like>();

    final mainCards =
        (await collectionRepo.getCardsInCollection('main')).map((c) {
      cardMap[c.id] = c;
      return c.id;
    }).toList(growable: false);
    collectionMap['main'] = mainCards;

    await Future.forEach(mainCards, (mc) async {
      final cardNames =
          (await collectionRepo.getCardsInCollection(mc)).map((c) {
        cardMap[c.id] = c;
        return c.id;
      }).toList(growable: false);

      await Future.forEach(cardNames, (c) async {
        progressMap[c] = await cardProgressRepo
            .getProgressStatusByCollectionAndTypeAndUserId(
                c, CardType.knowledge, user.id);
        likeMap[c] = await likeRepo.getLikeByParentIdAndUserId(
            c, user.id, TileType.card);
      });

      collectionMap[mc] = cardNames;
    });

    print('FetchInitialData: $progressMap');
    return (RootState state) => RootState(
        user: user,
        collectionMap: state.collectionMap..addAll(collectionMap),
        cardMap: state.cardMap..addAll(cardMap),
        progressMap: state.progressMap..addAll(progressMap),
        likeMap: likeMap,
        tiles: state.tiles,
        templates: state.templates,
        commentMap: {});
  }
}
