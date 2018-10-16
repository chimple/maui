import 'dart:async';
import 'dart:core';

import 'package:maui/db/dao/like_dao.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/tile_repo.dart';

class LikeRepo {
  static final LikeDao likeDao = new LikeDao();

  const LikeRepo();

  Future<List<Like>> getLikesByParentId(
      String parentId, TileType tileType) async {
    return likeDao.getLikesByParentId(parentId, tileType);
  }

  Future<Like> getLikeByParentIdAndUserId(
      String parentId, String userId, TileType tileType) async {
    return likeDao.getLikeByParentIdAndUserId(parentId, userId, tileType);
  }

  Future<Null> insert(Like tileLike, TileType tileType) async {
    await likeDao.insert(tileLike, tileType);
    switch (tileType) {
      case TileType.card:
        await CardRepo().incrementLikes(tileLike.parentId, 1);
        break;
      case TileType.drawing:
        await TileRepo().incrementLikes(tileLike.parentId, 1);
        break;
    }
  }

  Future<Null> update(Like tileLike, TileType tileType) async {
    return likeDao.update(tileLike, tileType);
  }

  Future<Null> delete(Like tileLike, TileType tileType) async {
    await likeDao.delete(tileLike, tileType);
    switch (tileType) {
      case TileType.card:
        await CardRepo().incrementLikes(tileLike.parentId, -1);
        break;
      case TileType.drawing:
        await TileRepo().incrementLikes(tileLike.parentId, -1);
        break;
    }
  }
}
