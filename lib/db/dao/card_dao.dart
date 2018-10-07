import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/card.dart';
import 'package:sqflite/sqflite.dart';

class CardDao {
  Future<Card> getCard(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Card.table,
        columns: Card.allCols, where: '${Card.idCol} = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Card.fromMap(maps.first);
    }
    return null;
  }
}
