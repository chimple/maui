import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/concept.dart';

class ConceptDao {
  Future<Concept> getConcept(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Concept.table,
        columns: [
          Concept.idCol,
          Concept.nameCol
        ],
        where: "${Concept.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Concept.fromMap(maps.first);
    }
    return null;
  }
}