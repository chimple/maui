import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:maui/db/entity/card_comment.dart';

import 'package:maui/app_database.dart';

class CardCommentDao {
  Future<List<CardComment>> getCardCommentsByCardId(String cardId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      CardComment.table,
      columns: CardComment.allCols,
      where: " ${CardComment.cardIdCol} = ? ",
      whereArgs: [cardId],
      orderBy: "${CardComment.timeStampCol}",
    );
    if (maps.length > 0) {
      return maps
          .map((el) => new CardComment.fromMap(el))
          .toList(growable: true);
    }
    return null;
  }

  Future<Null> insert(CardComment cardComment, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(CardComment.table, cardComment.toMap());
  }

  Future<Null> delete(CardComment cardComment, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.delete(CardComment.table,
        where: '${CardComment.idCol} = ?', whereArgs: [cardComment.id]);
  }

  Future<Null> update(CardComment cardComment, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.update(CardComment.table, cardComment.toMap(),
        where: '${CardComment.idCol} = ?', whereArgs: [cardComment.id]);
  }
}
