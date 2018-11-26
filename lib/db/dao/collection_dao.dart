import 'dart:async';
import 'package:maui/db/entity/quack_card.dart';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/collection.dart';

class CollectionDao {
  Future<Collection> getCollection(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Collection.table,
        columns: Collection.allCols,
        where: "${Collection.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Collection.fromMap(maps.first);
    }
    return null;
  }

  Future<List<QuackCard>> getCardsInCollection(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: QuackCard.allCols,
        where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
''',
        whereArgs: [id],
        orderBy: '${Collection.serialCol}');
    return maps.map((el) => QuackCard.fromMap(el)).toList();
  }

  Future<List<QuackCard>> getKnowledgeAndQuizCardsInCollection(String id,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: QuackCard.allCols,
        where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${QuackCard.table}.${QuackCard.typeCol} in (?, ?)
''',
        whereArgs: [id, CardType.knowledge.index, CardType.question.index],
        orderBy: '${Collection.serialCol}');
    return maps.map((el) => QuackCard.fromMap(el)).toList();
  }

  Future<int> getKnowledgeAndQuizCardCountInCollection(String id,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: ['count(${QuackCard.table}.${QuackCard.idCol})'], where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${QuackCard.table}.${QuackCard.typeCol} in (?, ?)
''', whereArgs: [id, CardType.knowledge.index, CardType.question.index]);
    if (maps.length > 0) {
      return maps.first['count(${QuackCard.table}.${QuackCard.idCol})'];
    }
    return 0;
  }

  Future<int> getCardCountInCollection(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: ['count(${QuackCard.table}.${QuackCard.idCol})'], where: '''
${Collection.idCol} = ? 
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
''', whereArgs: [id]);
    if (maps.length > 0) {
      return maps.first['count(${QuackCard.table}.${QuackCard.idCol})'];
    }
    return 0;
  }

  Future<int> getCardCountInCollectionByType(String id, CardType cardType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: ['count(${QuackCard.table}.${QuackCard.idCol})'], where: '''
${Collection.idCol} = ? 
AND ${QuackCard.table}.${QuackCard.typeCol} = ?
AND ${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
''', whereArgs: [id, cardType.index]);
    if (maps.length > 0) {
      return maps.first['count(${QuackCard.table}.${QuackCard.idCol})'];
    }
    return 0;
  }
}
