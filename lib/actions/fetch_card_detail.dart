import 'dart:async';
import 'dart:convert';

import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';

class FetchCardDetail implements AsyncAction<RootState> {
  final String cardId;
  CollectionRepo collectionRepo;
  CardProgressRepo cardProgressRepo;
  CardRepo cardRepo;
  CommentRepo commentRepo;
  LikeRepo likeRepo;
  TileRepo tileRepo;
  CardExtraRepo cardExtraRepo;

  FetchCardDetail(this.cardId);

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(collectionRepo != null, 'collectionRepo not injected');
    assert(cardProgressRepo != null, 'cardProgressRepo not injected');
    assert(cardRepo != null, 'cardRepo not injected');
    assert(commentRepo != null, 'commentRepo not injected');
    assert(likeRepo != null, 'likeRepo not injected');
    assert(tileRepo != null, 'tileRepo not injected');
    assert(cardExtraRepo != null, 'cardExtraRepo not injected');

    final cardMap = Map<String, QuackCard>();
    final progressMap = Map<String, double>();
    final collectionMap = Map<String, List<String>>();
    final likeMap = Map<String, Like>();
    var drawings = List<Tile>();
    var templates = List<CardExtra>();

    final card = state.cardMap[cardId];
    if (card == null) {
      cardMap[cardId] = await cardRepo.getCard(cardId);
      likeMap[cardId] = await likeRepo.getLikeByParentIdAndUserId(
          cardId, state.user.id, TileType.card);
    }

    if (card.type == CardType.concept) {
      final mainCards =
          (await collectionRepo.getCardsInCollection(cardId)).map((c) {
        cardMap[c.id] = c;
        return c.id;
      }).toList(growable: false);
      collectionMap[cardId] = mainCards;

      await Future.forEach(mainCards, (mc) async {
        progressMap[mc] = await cardProgressRepo
            .getProgressStatusByCollectionAndTypeAndUserId(
                mc, CardType.knowledge, state.user.id);
        likeMap[mc] = await likeRepo.getLikeByParentIdAndUserId(
            mc, state.user.id, TileType.card);
      });
    } else if (card.type == CardType.activity) {
      drawings =
          await tileRepo.getTilesByCardIdAndType(card.id, TileType.drawing);
      templates = await cardExtraRepo.getCardExtrasByCardIdAndType(
          card.id, CardExtraType.template);
    }

    final comments =
        await commentRepo.getCommentsByParentId(cardId, TileType.card);

    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: state.user,
        collectionMap: state.collectionMap..addAll(collectionMap),
        cardMap: state.cardMap..addAll(cardMap),
        activityMap: state.activityMap,
        tiles: state.tiles,
        drawings: drawings,
        userMap: state.userMap,
        templates: templates,
        commentMap: state.commentMap..[cardId] = comments);
  }
}
