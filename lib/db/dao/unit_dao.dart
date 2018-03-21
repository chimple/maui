import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/unit.dart';

class UnitDao {
  Future<Unit> getUnit(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Unit.table,
        columns: [
          Unit.idCol,
          Unit.nameCol,
          Unit.typeCol,
          Unit.imageCol,
          Unit.soundCol,
          Unit.phonemeSoundCol
        ],
        where: "${Unit.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Unit.fromMap(maps.first);
    }
    return null;
  }

  Future<Unit> insert(Unit unit, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Unit.table, unit.toMap());
    return unit;
  }
}
