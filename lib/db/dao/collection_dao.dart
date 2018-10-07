import 'dart:async';
import 'package:maui/db/entity/card.dart';
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

  Future<List<Card>> getCardsInCollection(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query('${Card.table}, ${Collection.table}',
        columns: Card.allPrefixedCols, where: '''
${Collection.table}.${Collection.idCol} = ? 
AND ${Collection.table}.${Collection.cardIdCol} = ${Card.table}.${Card.idCol}
''', whereArgs: [id]);
    return maps.map((el) => Card.fromMap(el)).toList();
  }
}
