import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/lesson.dart';
import 'package:maui/db/dao/lesson_dao.dart';

class LessonRepo {
  static final LessonDao lessonDao = new LessonDao();

  const LessonRepo();

  Future<Lesson> getLesson(int gameCategoryId) async {
    return await lessonDao.getLesson(gameCategoryId);
  }

  Future<Lesson> getLessonsBySeq(int seq) async {
    return await lessonDao.getLessonBySeq(seq);
  }

  Future<List<Lesson>> getLessonsBelowSeqAndByConceptId(
      int seq, List<int> conceptIds) async {
    return await lessonDao.getLessonsBelowSeqAndByConceptId(seq, conceptIds);
  }
}
