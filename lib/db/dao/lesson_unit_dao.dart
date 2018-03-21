import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/eager_lesson_unit.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:maui/db/entity/unit.dart';

class LessonUnitDao {
  Future<List<LessonUnit>> getLessonUnitsByLessonId(int lessonId,
      {Database db}) async {
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

  Future<List<EagerLessonUnit>> getEagerLessonUnitsByLessonId(int lessonId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${LessonUnit.table} lu, ${Unit.table} su, ${Unit.table} ou',
        columns: [
          'lu.${LessonUnit.idCol}',
          'lu.${LessonUnit.lessonIdCol}',
          'lu.${LessonUnit.seqCol}',
          'lu.${LessonUnit.subjectUnitIdCol}',
          'lu.${LessonUnit.objectUnitIdCol}',
          'lu.${LessonUnit.highlightCol}',
          'su.${Unit.idCol} AS su_${Unit.idCol}',
          'su.${Unit.nameCol} AS su_${Unit.nameCol}',
          'su.${Unit.typeCol} AS su_${Unit.typeCol}',
          'su.${Unit.imageCol} AS su_${Unit.imageCol}',
          'su.${Unit.soundCol} AS su_${Unit.soundCol}',
          'su.${Unit.phonemeSoundCol} AS su_${Unit.phonemeSoundCol}',
          'ou.${Unit.idCol} AS ou_${Unit.idCol}',
          'ou.${Unit.nameCol} AS ou_${Unit.nameCol}',
          'ou.${Unit.typeCol} AS ou_${Unit.typeCol}',
          'ou.${Unit.imageCol} AS ou_${Unit.imageCol}',
          'ou.${Unit.soundCol} AS ou_${Unit.soundCol}',
          'ou.${Unit.phonemeSoundCol} AS ou_${Unit.phonemeSoundCol}'
        ],
        where: '''
lu.${LessonUnit.lessonIdCol} = ? 
AND ${LessonUnit.subjectUnitIdCol} = su.id 
AND ${LessonUnit.objectUnitIdCol} = ou.id
''',
        whereArgs: [lessonId],
        orderBy: LessonUnit.seqCol);
    return maps
        .map((el) => new EagerLessonUnit.fromMap(el))
        .toList(growable: false);
  }

  Future<List<LessonUnit>> getLessonUnitsBelowSeqAndByConceptId(
      int seq, int conceptId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(LessonUnit.table, columns: [
      LessonUnit.idCol,
      LessonUnit.lessonIdCol,
      LessonUnit.seqCol,
      LessonUnit.subjectUnitIdCol,
      LessonUnit.objectUnitIdCol,
      LessonUnit.highlightCol
    ], where: '''
${LessonUnit.lessonIdCol} IN (
  SELECT ${Lesson.idCol} 
  FROM ${Lesson.table} 
  WHERE ${Lesson.seqCol} <= ? 
  AND ${Lesson.conceptIdCol} = ?)
''', whereArgs: [
      seq,
      conceptId
    ]);
    return maps.map((el) => new LessonUnit.fromMap(el)).toList(growable: false);
  }

  Future<List<EagerLessonUnit>> getEagerLessonUnitsBelowSeqAndByConceptId(
      int seq, int conceptId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${LessonUnit.table} lu, ${Unit.table} su, ${Unit.table} ou',
        columns: [
          'lu.${LessonUnit.idCol}',
          'lu.${LessonUnit.lessonIdCol}',
          'lu.${LessonUnit.seqCol}',
          'lu.${LessonUnit.subjectUnitIdCol}',
          'lu.${LessonUnit.objectUnitIdCol}',
          'lu.${LessonUnit.highlightCol}',
          'su.${Unit.idCol} AS su_${Unit.idCol}',
          'su.${Unit.nameCol} AS su_${Unit.nameCol}',
          'su.${Unit.typeCol} AS su_${Unit.typeCol}',
          'su.${Unit.imageCol} AS su_${Unit.imageCol}',
          'su.${Unit.soundCol} AS su_${Unit.soundCol}',
          'su.${Unit.phonemeSoundCol} AS su_${Unit.phonemeSoundCol}',
          'ou.${Unit.idCol} AS ou_${Unit.idCol}',
          'ou.${Unit.nameCol} AS ou_${Unit.nameCol}',
          'ou.${Unit.typeCol} AS ou_${Unit.typeCol}',
          'ou.${Unit.imageCol} AS ou_${Unit.imageCol}',
          'ou.${Unit.soundCol} AS ou_${Unit.soundCol}',
          'ou.${Unit.phonemeSoundCol} AS ou_${Unit.phonemeSoundCol}'
        ],
        where: '''
lu.${LessonUnit.lessonIdCol} IN (
  SELECT l.${Lesson.idCol} 
  FROM ${Lesson.table} l 
  WHERE l.${Lesson.seqCol} <= ? 
  AND l.${Lesson.conceptIdCol} = ?) 
AND ${LessonUnit.subjectUnitIdCol} = su.id 
AND ${LessonUnit.objectUnitIdCol} = ou.id
''',
        whereArgs: [
          seq,
          conceptId
        ]);
    return maps
        .map((el) => new EagerLessonUnit.fromMap(el))
        .toList(growable: false);
  }
}
