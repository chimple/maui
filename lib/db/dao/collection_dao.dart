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
        columns: QuackCard.allPrefixedCols,
        where: '''
${Collection.table}.${Collection.idCol} = ? 
AND ${Collection.table}.${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
''',
        whereArgs: [id],
        orderBy: '${Collection.table}.${Collection.serialCol}');
    return maps.map((el) => QuackCard.fromMap(el)).toList();
  }

  Future<List<QuackCard>> getCardsInCollectionByType(
      String id, CardType cardType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: QuackCard.allPrefixedCols,
        where: '''
${Collection.table}.${Collection.idCol} = ? 
AND ${Collection.table}.${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
AND ${QuackCard.table}.${QuackCard.typeCol} = ?
''',
        whereArgs: [id, cardType.index],
        orderBy: '${Collection.table}.${Collection.serialCol}');
    return maps.map((el) => QuackCard.fromMap(el)).toList();
  }

  Future<int> getCardCountInCollection(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: ['count(${QuackCard.idCol})'], where: '''
${Collection.table}.${Collection.idCol} = ? 
AND ${Collection.table}.${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
''', whereArgs: [id]);
    if (maps.length > 0) {
      return maps.first['count(${QuackCard.idCol})'];
    }
    return 0;
  }

  Future<int> getCardCountInCollectionByType(String id, CardType cardType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${QuackCard.table}, ${Collection.table}',
        columns: ['count(${QuackCard.idCol})'], where: '''
${Collection.table}.${Collection.idCol} = ? 
AND ${QuackCard.table}.${QuackCard.typeCol} = ?
AND ${Collection.table}.${Collection.cardIdCol} = ${QuackCard.table}.${QuackCard.idCol}
''', whereArgs: [id, cardType.index]);
    if (maps.length > 0) {
      return maps.first['count(${QuackCard.idCol})'];
    }
    return 0;
  }
}
