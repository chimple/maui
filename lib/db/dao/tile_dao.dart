import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class TileDao {
  Future<Tile> getTile(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${Tile.table}, ${QuackCard.table}, ${User.table}',
        columns: Tile.allCols,
        where: "${Tile.table}.${Tile.idCol} = ? ",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Tile.fromMap(maps.first);
    }
    return null;
  }

  Future<Tile> getTileByCardIdAndUserId(String cardId, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${Tile.table}, ${QuackCard.table}, ${User.table}',
        columns: Tile.allCols,
        where:
            "${Tile.table}.${Tile.cardIdCol} = ? AND ${Tile.table}.${Tile.userIdCol} = ?",
        whereArgs: [cardId, userId]);
    if (maps.length > 0) {
      return Tile.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Tile>> getTilesByCardId(String cardId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${Tile.table}, ${QuackCard.table}, ${User.table}',
        columns: Tile.allCols,
        where: '''
${Tile.table}.${Tile.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${Tile.table}.${Tile.userIdCol} = ${User.table}.${User.idCol}
AND ${Tile.table}.${Tile.cardIdCol} = ?
''',
        whereArgs: [cardId]);
    return maps.map((el) => new Tile.fromMap(el)).toList();
  }

  Future<List<Tile>> getTiles({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps =
        await db.query('${Tile.table}, ${QuackCard.table}, ${User.table}',
            where: '''
${Tile.table}.${Tile.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${Tile.table}.${Tile.userIdCol} = ${User.table}.${User.idCol}
''',
            columns: Tile.allCols);
    return maps.map((el) => new Tile.fromMap(el)).toList();
  }

  Future<Tile> insert(Tile tile, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Tile.table, tile.toMap());
    return tile;
  }

  Future<int> delete(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db
        .delete(Tile.table, where: "${Tile.idCol} = ?", whereArgs: [id]);
  }

  Future<int> update(Tile tile, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db.update(Tile.table, tile.toMap(),
        where: "${Tile.idCol} = ?", whereArgs: [tile.id]);
  }
}
