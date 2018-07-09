import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/concept.dart';
import 'package:sqflite/sqflite.dart';

class ConceptDao {
  Future<Concept> getConcept(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Concept.table,
        columns: [Concept.idCol, Concept.nameCol, Concept.areaIdCol],
        where: "${Concept.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Concept.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Concept>> getConcepts({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Concept.table,
        columns: [Concept.idCol, Concept.nameCol, Concept.areaIdCol]);
    return maps.map((conceptMap) => Concept.fromMap(conceptMap)).toList();
  }
}
