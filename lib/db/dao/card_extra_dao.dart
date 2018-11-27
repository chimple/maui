import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:sqflite/sqflite.dart';

class CardExtraDao {
  Future<List<CardExtra>> getCardExtrasByCardIdAndType(
      String cardId, CardExtraType cardExtraType,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(CardExtra.table,
        columns: CardExtra.allCols,
        where: '${CardExtra.cardIdCol} = ? AND ${CardExtra.typeCol} = ?',
        whereArgs: [cardId, cardExtraType.index],
        orderBy: CardExtra.serialCol);
    return maps.map((el) => new CardExtra.fromMap(el)).toList(growable: false);
  }
}
