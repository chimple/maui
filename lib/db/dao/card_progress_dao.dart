import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/card_progress.dart';
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
      print(maps);
      return CardProgress.fromMap(maps.first);
    }
    return null;
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
