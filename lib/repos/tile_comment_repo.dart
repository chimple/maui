import 'dart:async';
import 'dart:core';

import 'package:maui/db/dao/tile_comment_dao.dart';
import 'package:maui/db/entity/tile_comment.dart';

class TileCommentRepo {
  static final TileCommentDao tileCommentDao = new TileCommentDao();

  const TileCommentRepo();

  Future<List<TileComment>> getTileCommentsByTileId(String id) async {
    return tileCommentDao.getTileCommentsByTileId(id);
  }

  Future<Null> insert(TileComment tileComment) async {
    return tileCommentDao.insert(tileComment);
  }

  Future<Null> update(TileComment tileComment) async {
    return tileCommentDao.update(tileComment);
  }

  Future<Null> delete(TileComment tileComment) async {
    return tileCommentDao.delete(tileComment);
  }
}
