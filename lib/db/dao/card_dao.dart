import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:sqflite/sqflite.dart';

class CardDao {
  Future<QuackCard> getCard(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuackCard.table,
        columns: QuackCard.allCols,
        where: '${QuackCard.idCol} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return QuackCard.fromMap(maps.first);
    }
    return null;
  }
}
