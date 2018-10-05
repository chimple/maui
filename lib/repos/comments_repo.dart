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

  Future<String> insertAComment(String tileId, String timeStamp,
      String commentingUserId, String comment) async {
    await commentsDao.insertAComment(new Comments(
        timeStamp: timeStamp,
        tileId: tileId,
        comment: comment,
        commentingUserId: commentingUserId));
    return "Comment inserted";
  }

  Future<String> updateAComment(String tileId, String timeStamp,
      String commentingUserId, String comment) async {
    await commentsDao.updateAComment(new Comments(
        timeStamp: timeStamp,
        tileId: tileId,
        comment: comment,
        commentingUserId: commentingUserId));
    return "Comment updated";
  }

  Future<String> deleteAComment(String tileId, String timeStamp,
      String commentingUserId, String comment) async {
    await commentsDao.deleteAComment(new Comments(
        timeStamp: timeStamp,
        tileId: tileId,
        comment: comment,
        commentingUserId: commentingUserId));
    return "Comment Deleted";
  }
}
