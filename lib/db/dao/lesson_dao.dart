import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:sqflite/sqflite.dart';

class LessonDao {
  Future<Lesson> getLesson(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Lesson.table,
        columns: [
          Lesson.idCol,
          Lesson.titleCol,
          Lesson.conceptIdCol,
          Lesson.seqCol,
          Lesson.hasOrderCol
        ],
        where: "${Lesson.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Lesson.fromMap(maps.first);
    }
    return null;
  }

  Future<Lesson> getLessonBySeq(int seq, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Lesson.table,
        columns: [
          Lesson.idCol,
          Lesson.titleCol,
          Lesson.conceptIdCol,
          Lesson.seqCol,
          Lesson.hasOrderCol
        ],
        where: "${Lesson.seqCol} = ?",
        whereArgs: [seq]);
    if (maps.length > 0) {
      return new Lesson.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Lesson>> getLessonsBelowSeqAndByConceptId(
      int seq, List<int> conceptIds,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    var inClause = conceptIds.map((c) => '?').join(',');
    List whereArgs = [seq];
    whereArgs.addAll(conceptIds);
    List<Map> maps = await db.query(Lesson.table,
        columns: [
          Lesson.idCol,
          Lesson.titleCol,
          Lesson.conceptIdCol,
          Lesson.seqCol,
          Lesson.hasOrderCol
        ],
        where:
            "${Lesson.seqCol} <= ? AND ${Lesson.conceptIdCol} IN ($inClause)",
        whereArgs: whereArgs);
    return maps.map((el) => new Lesson.fromMap(el)).toList();
  }

  Future<List<Lesson>> getLessons({Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Lesson.table,
      columns: [
        Lesson.idCol,
        Lesson.titleCol,
        Lesson.conceptIdCol,
        Lesson.seqCol,
        Lesson.hasOrderCol
      ],
    );
    return maps.map((el) => new Lesson.fromMap(el)).toList();
  }

  Future<List<Lesson>> getLessonsByHasOrder(int hasOrder, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List whereArgs = [hasOrder];
    List<Map> maps = await db.query(Lesson.table,
        columns: [
          Lesson.idCol,
          Lesson.titleCol,
          Lesson.conceptIdCol,
          Lesson.seqCol,
          Lesson.hasOrderCol
        ],
        where: "${Lesson.hasOrderCol} = ?",
        whereArgs: whereArgs);
    return maps.map((el) => new Lesson.fromMap(el)).toList();
  }

  Future<Lesson> insert(Lesson lesson, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Lesson.table, lesson.toMap());
    return lesson;
  }
}
