import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/collection.dart';
import 'package:sqflite/sqflite.dart';

class CardProgressDao {
  const CardProgressDao();

  Future<CardProgress> getCardProgressByCardIdAndUserId(
      String cardId, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(CardProgress.table,
        columns: CardProgress.allCols,
        where:
            '${CardProgress.cardIdCol} = ? AND ${CardProgress.userIdCol} = ?',
        whereArgs: [cardId, userId]);
    if (maps.length > 0) {
      return CardProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CardProgress>> getCardProgressesByCollectionAndTypeAndUserId(
      String cardId, CardType cardType, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${CardProgress.table}, ${QuackCard.table}, ${Collection.table}',
        columns: CardProgress.allCols,
        where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${QuackCard.table}.${QuackCard.typeCol} = ?
AND ${CardProgress.table}.${CardProgress.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${CardProgress.table}.${CardProgress.userIdCol} = ?
''',
        whereArgs: [cardId, cardType.index, userId]);
    return maps.map((el) => CardProgress.fromMap(el)).toList();
  }

  Future<int> getCardProgressCountByCollectionAndTypeAndUserId(
      String cardId, CardType cardType, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${CardProgress.table}, ${QuackCard.table}, ${Collection.table}',
        columns: ['count(${CardProgress.table}.${CardProgress.cardIdCol})'],
        where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${QuackCard.table}.${QuackCard.typeCol} = ?
AND ${CardProgress.table}.${CardProgress.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${CardProgress.table}.${CardProgress.userIdCol} = ?
''',
        whereArgs: [cardId, cardType.index, userId]);
    if (maps.length > 0) {
      return maps
          .first['count(${CardProgress.table}.${CardProgress.cardIdCol})'];
    }
    return 0;
  }

  Future<int> getCardProgressCountByCollectionAndUserId(
      String cardId, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${CardProgress.table}, ${QuackCard.table}, ${Collection.table}',
        columns: ['count(${CardProgress.table}.${CardProgress.cardIdCol})'],
        where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${CardProgress.table}.${CardProgress.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${CardProgress.table}.${CardProgress.userIdCol} = ?
''',
        whereArgs: [cardId, userId]);
    if (maps.length > 0) {
      return maps
          .first['count(${CardProgress.table}.${CardProgress.cardIdCol})'];
    }
    return 0;
  }

  Future<CardProgress> insert(CardProgress cardProgress, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(CardProgress.table, cardProgress.toMap());
    return cardProgress;
  }

  Future<int> update(CardProgress cardProgress, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    return await db.update(CardProgress.table, cardProgress.toMap(),
        where:
            "${CardProgress.cardIdCol} = ? AND ${CardProgress.userIdCol} = ?",
        whereArgs: [cardProgress.cardId, cardProgress.userId]);
  }
}
