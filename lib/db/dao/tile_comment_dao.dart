import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/tile_comment.dart';

import 'package:maui/app_database.dart';

class TileCommentDao {
  Future<List<TileComment>> getTileCommentsByTileId(String tileId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      TileComment.table,
      columns: TileComment.allCols,
      where: " ${TileComment.tileIdCol} = ? ",
      whereArgs: [tileId],
      orderBy: "${TileComment.timeStampCol}",
    );
    if (maps.length > 0) {
      return maps
          .map((el) => new TileComment.fromMap(el))
          .toList(growable: true);
    }
    return null;
  }

  Future<Null> insert(TileComment tileComment, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(TileComment.table, tileComment.toMap());
  }

  Future<Null> delete(TileComment tileComment, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(TileComment.table,
        where: '${TileComment.idCol} = ?', whereArgs: [tileComment.id]);
  }

  Future<Null> update(TileComment tileComment, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.update(TileComment.table, tileComment.toMap(),
        where: '${TileComment.idCol} = ?', whereArgs: [tileComment.id]);
  }
}
