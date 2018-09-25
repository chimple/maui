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
      return maps.map((el) => new Likes.fromMap(el)).toList(growable: false);
    }
    return null;
  }
}
