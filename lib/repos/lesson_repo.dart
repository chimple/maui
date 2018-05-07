import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/lesson.dart';
import 'package:maui/db/dao/lesson_dao.dart';

class LessonRepo {
  static final LessonDao lessonDao = new LessonDao();

  const LessonRepo();

  Future<Lesson> getLesson(int id) async {
    return await lessonDao.getLesson(id);
  }

  Future<Lesson> getLessonsBySeq(int seq) async {
    return await lessonDao.getLessonBySeq(seq);
  }

  Future<List<Lesson>> getLessonsBelowSeqAndByConceptId(
      int seq, List<int> conceptIds) async {
    return await lessonDao.getLessonsBelowSeqAndByConceptId(seq, conceptIds);
  }

  Future<List<Lesson>> getLessons() async {
    return await lessonDao.getLessons();
  }

  Future<List<Lesson>> getLessonsByHasOrder(int hasOrder) async {
    return await lessonDao.getLessonsByHasOrder(hasOrder);
  }
}
