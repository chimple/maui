import 'package:maui/db/entity/comments.dart';
import 'package:maui/db/dao/comments_dao.dart';
import 'dart:async';

class CommentsRepo {
  const CommentsRepo();
  static final CommentsDao commentsDao = new CommentsDao();

  Future<List<Comments>> getCommentsByTileId(String tileId) async {
    var comments = await commentsDao.getCommentsByTileId(tileId);
    return comments;
  }
}
