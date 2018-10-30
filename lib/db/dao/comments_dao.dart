import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/comments.dart';

import 'package:maui/app_database.dart';

class CommentsDao {
  Future<List<Comments>> getCommentsByTileId(String tileId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Comments.table,
      columns: [
        Comments.tileIdCol,
        Comments.commentCol,
        Comments.timeStampCol,
        Comments.commentingUserIdCol
      ],
      where: " ${Comments.tileIdCol} = ? ",
      whereArgs: [tileId],
      // orderBy: "${Comments.timeStampCol}",
    );
    if (maps.length > 0) {
      return maps.map((el) => new Comments.fromMap(el)).toList(growable: true);
    }
    return null;
  }

  Future<Null> insertAComment(Comments comments, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Comments.table, comments.toMap());
  }

  Future<Null> deleteAComment(Comments comments, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(Comments.table,
        where: ''' ${Comments.tileIdCol} = ? AND ${Comments.commentCol} = ?''',
        whereArgs: [comments.tileId, comments.comment]);
  }

  Future<Null> updateAComment(Comments comments, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.update(Comments.table, comments.toMap(),
        where:
            ''' ${Comments.tileIdCol} = ? AND ${Comments.commentingUserIdCol} = ? AND ${Comments.timeStampCol} = ?''',
        whereArgs: [
          comments.tileId,
          comments.commentingUserId,
          comments.timeStamp
        ]);
  }
}
