import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/db/entity/unit_part.dart';
import 'package:maui/db/entity/eager_unit_part.dart';

class UnitPartDao {
  Future<List<UnitPart>> getUnitPartsByUnitIdAndType(String unitId, UnitType type, {Database db}) async {
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

  Future<List<EagerUnitPart>> getEagerUnitPartsByUnitIdAndType(String unitId, UnitType type, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${UnitPart.table} up, ${Unit.table} u, ${Unit.table} p',
        columns: [
          'up.${UnitPart.unitIdCol}',
          'up.${UnitPart.partUnitIdCol}',
          'up.${UnitPart.typeCol}',
          'up.${UnitPart.seqCol}',
          'u.${Unit.idCol} AS u_${Unit.idCol}',
          'u.${Unit.nameCol} AS u_${Unit.nameCol}',
          'u.${Unit.typeCol} AS u_${Unit.typeCol}',
          'u.${Unit.imageCol} AS u_${Unit.imageCol}',
          'u.${Unit.soundCol} AS u_${Unit.soundCol}',
          'u.${Unit.phonemeSoundCol} AS u_${Unit.phonemeSoundCol}',
          'p.${Unit.idCol} AS p_${Unit.idCol}',
          'p.${Unit.nameCol} AS p_${Unit.nameCol}',
          'p.${Unit.typeCol} AS p_${Unit.typeCol}',
          'p.${Unit.imageCol} AS p_${Unit.imageCol}',
          'p.${Unit.soundCol} AS p_${Unit.soundCol}',
          'p.${Unit.phonemeSoundCol} AS p_${Unit.phonemeSoundCol}'
        ],
        where: '''
up.${UnitPart.unitIdCol} = ?
AND up.${UnitPart.typeCol} = ?
AND up.${UnitPart.unitIdCol} = u.id
AND up.${UnitPart.partUnitIdCol} = p.id
''',
        whereArgs: [unitId, type.index]);
    return maps.map((el) => new EagerUnitPart.fromMap(el));
  }

  Future<UnitPart> insert(UnitPart unitPart, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(UnitPart.table, unitPart.toMap());
    return unitPart;
  }
}
