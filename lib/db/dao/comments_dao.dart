import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/Comments.dart';

import 'package:maui/app_database.dart';

class CommentsDao {
  Future<List<Comments>> getCommentsByTileId(String tileId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Comments.table,
      columns: [
        Comments.tileIdCol,
        Comments.userIdCol,
        Comments.commentCol,
        Comments.timeStampCol,
        Comments.commentingUserIdCol
      ],
      where: " ${Comments.tileIdCol} = ? ",
      whereArgs: [tileId],
      orderBy: "${Comments.timeStampCol}",
    );
    if (maps.length > 0) {
      return maps.map((el) => new Comments.fromMap(el)).toList(growable: false);
    }
    return null;
  }
}
