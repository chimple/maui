import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/likes.dart';

import 'package:maui/app_database.dart';

class LikesDao {
  Future<List<Likes>> getLikesByTileId(String tileId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Likes.table,
      columns: [Likes.tileIdCol, Likes.likedUserIdCol],
      where: " ${Likes.tileIdCol} = ? ",
      whereArgs: [tileId],
    );
    if (maps.length > 0) {
      return maps.map((el) => new Likes.fromMap(el)).toList(growable: true);
    }
    return null;
  }

  Future<Likes> getLikesByTileIdAndLikedUserId(
      String tileId, String likedUserId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Likes.table,
      columns: [Likes.tileIdCol, Likes.likedUserIdCol],
      where: " ${Likes.tileIdCol} = ? AND ${Likes.likedUserIdCol} = ? ",
      whereArgs: [tileId, likedUserId],
    );
    if (maps.length > 0) {
      return new Likes.fromMap(maps.first);
    }
    return null;
  }

  Future<Null> insertALike(Likes likes, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Likes.table, likes.toMap());
  }

  Future<Null> deleteALike(Likes likes, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(Likes.table,
        where: ''' ${Likes.tileIdCol} = ? AND ${Likes.likedUserIdCol} = ? ''',
        whereArgs: [likes.tileId, likes.likedUserId]);
  }
}
