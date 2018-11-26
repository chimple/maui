import 'dart:async';
import 'dart:core';

import 'package:maui/db/dao/comment_dao.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/tile_repo.dart';

class CommentRepo {
  static final CommentDao commentDao = new CommentDao();

  const CommentRepo();

  Future<List<Comment>> getCommentsByParentId(
      String parentId, TileType tileType) async {
    return commentDao.getCommentsByParentId(parentId, tileType);
  }

  Future<Null> insert(Comment tileComment, TileType tileType) async {
    await commentDao.insert(tileComment, tileType);
    switch (tileType) {
      case TileType.card:
        await CardRepo().incrementComments(tileComment.parentId, 1);
        break;
      case TileType.drawing:
        await TileRepo().incrementComments(tileComment.parentId, 1);
        break;
      case TileType.message:
        await TileRepo().incrementComments(tileComment.parentId, 1);
        break;
    }
  }

  Future<Null> update(Comment tileComment, TileType tileType) async {
    return commentDao.update(tileComment, tileType);
  }

  Future<Null> delete(Comment tileComment, TileType tileType) async {
    await commentDao.delete(tileComment, tileType);
    switch (tileType) {
      case TileType.card:
        await CardRepo().incrementComments(tileComment.parentId, -1);
        break;
      case TileType.drawing:
        await TileRepo().incrementComments(tileComment.parentId, -1);
        break;
    }
  }
}
