import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/eager_lesson_unit.dart';
import 'package:maui/db/dao/lesson_unit_dao.dart';

class LessonUnitRepo {
  static final LessonUnitDao lessonUnitDao = new LessonUnitDao();

  const LessonUnitRepo();

  Future<List<LessonUnit>> getLessonUnitsByLessonId(int lessonId) async {
    return lessonUnitDao.getLessonUnitsByLessonId(lessonId);
  }

  Future<List<EagerLessonUnit>> getEagerLessonUnitsByLessonId(int lessonId) async {
    return lessonUnitDao.getEagerLessonUnitsByLessonId(lessonId);
  }

  Future<List<LessonUnit>> getLessonUnitsBelowSeqAndByConceptId(
  int seq, int conceptId) async {
    return lessonUnitDao.getLessonUnitsBelowSeqAndByConceptId(seq, conceptId);
  }

  Future<List<EagerLessonUnit>> getEagerLessonUnitsBelowSeqAndByConceptId(
      int seq, int conceptId) async {
    return lessonUnitDao.getEagerLessonUnitsBelowSeqAndByConceptId(seq, conceptId);
  }

}
