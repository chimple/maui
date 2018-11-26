import 'dart:async';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/like.dart';

import 'package:maui/app_database.dart';

class LikeDao {
  static const Map<TileType, String> tableMap = {
    TileType.card: 'cardLike',
    TileType.drawing: 'tileLike',
    TileType.message: 'tileLike'
  };

  Future<List<Like>> getLikesByParentId(String parentId, TileType tileType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      '${tableMap[tileType]} ${Like.table}, ${User.table}',
      columns: Like.allCols,
      where: '''
${Like.table}.${Like.parentIdCol} = ?
AND ${Like.table}.${Like.userIdCol} = ${User.table}.${User.idCol}
''',
      whereArgs: [parentId],
      orderBy: "${Like.timeStampCol}",
    );
    if (maps.length > 0) {
      return maps.map((el) => new Like.fromMap(el)).toList(growable: true);
    }
    return null;
  }

  Future<Like> getLikeByParentIdAndUserId(
      String parentId, String userId, TileType tileType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${tableMap[tileType]} ${Like.table}, ${User.table}',
        columns: Like.allCols,
        where: '''
${Like.table}.${Like.parentIdCol} = ?
AND ${Like.table}.${Like.userIdCol} = ?
AND ${Like.table}.${Like.userIdCol} = ${User.table}.${User.idCol}
''',
        whereArgs: [parentId, userId]);
    if (maps.length > 0) {
      return Like.fromMap(maps.first);
    }
    return null;
  }

  Future<Null> insert(Like tileLike, TileType tileType, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(tableMap[tileType], tileLike.toMap());
  }

  Future<Null> delete(Like tileLike, TileType tileType, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(tableMap[tileType],
        where: '${Like.idCol} = ?', whereArgs: [tileLike.id]);
  }

  Future<Null> update(Like tileLike, TileType tileType, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.update(tableMap[tileType], tileLike.toMap(),
        where: '${Like.idCol} = ?', whereArgs: [tileLike.id]);
  }
}
