import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/lesson.dart';

class LessonUnitDao {
  Future<List<LessonUnit>> getLessonUnitsByLessonId(int lessonId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(LessonUnit.table,
        columns: [
          LessonUnit.idCol,
          LessonUnit.lessonIdCol,
          LessonUnit.seqCol,
          LessonUnit.subjectUnitIdCol,
          LessonUnit.objectUnitIdCol,
          LessonUnit.highlightCol
        ],
        where: "${LessonUnit.lessonIdCol} = ?",
        whereArgs: [lessonId],
        orderBy: LessonUnit.seqCol);
    return maps.map((el) => new LessonUnit.fromMap(el)).toList(growable: false);
  }

  Future<List<LessonUnit>> getLessonUnitsBelowSeqAndByConceptId(int seq, int conceptId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(LessonUnit.table,
        columns: [
          LessonUnit.idCol,
          LessonUnit.lessonIdCol,
          LessonUnit.seqCol,
          LessonUnit.subjectUnitIdCol,
          LessonUnit.objectUnitIdCol,
          LessonUnit.highlightCol
        ],
        where: "${LessonUnit.lessonIdCol} IN (SELECT ${Lesson.idCol} FROM ${Lesson.table} WHERE ${Lesson.seqCol} <= ? AND ${Lesson.conceptIdCol} = ?)",
        whereArgs: [seq, conceptId]);
    return maps.map((el) => new LessonUnit.fromMap(el)).toList(growable: false);
  }

}
