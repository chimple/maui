import 'dart:async';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/comment.dart';

import 'package:maui/app_database.dart';

class CommentDao {
  static const Map<TileType, String> tableMap = {
    TileType.card: 'cardComment',
    TileType.drawing: 'tileComment',
    TileType.message: 'tileComment'
  };

  Future<List<Comment>> getCommentsByParentId(
      String parentId, TileType tileType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      '${tableMap[tileType]} ${Comment.table}, ${User.table}',
      columns: Comment.allCols,
      where: '''
${Comment.table}.${Comment.parentIdCol} = ?
AND ${Comment.table}.${Comment.userIdCol} = ${User.table}.${User.idCol}
''',
      whereArgs: [parentId],
      orderBy: "${Comment.timeStampCol} DESC",
    );
    return maps.map((el) => new Comment.fromMap(el)).toList(growable: true);
  }

  Future<Null> insert(Comment tileComment, TileType tileType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(tableMap[tileType], tileComment.toMap());
  }

  Future<Null> delete(Comment tileComment, TileType tileType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(tableMap[tileType],
        where: '${Comment.idCol} = ?', whereArgs: [tileComment.id]);
  }

  Future<Null> update(Comment tileComment, TileType tileType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.update(tableMap[tileType], tileComment.toMap(),
        where: '${Comment.idCol} = ?', whereArgs: [tileComment.id]);
  }
}
