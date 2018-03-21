import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/db/entity/unit_part.dart';

class UnitPartDao {
  Future<List<UnitPart>> getUnitPartsByUnitIdAndType(int unitId, UnitType type, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(UnitPart.table,
        columns: [
          UnitPart.unitIdCol,
          UnitPart.partUnitIdCol,
          UnitPart.typeCol,
          UnitPart.seqCol
        ],
        where: "${UnitPart.unitIdCol} = ? AND ${UnitPart.typeCol} = ?",
        whereArgs: [unitId, type.index]);
    return maps.map((el) => new UnitPart.fromMap(el));
  }

  Future<UnitPart> insert(UnitPart unitPart, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(UnitPart.table, unitPart.toMap());
    return unitPart;
  }
}
