import 'dart:async';

import 'package:maui/db/entity/quiz_progress.dart';
import 'package:maui/db/dao/quiz_progress_dao.dart';

class QuizProgressRepo {
  static final QuizProgressDao quizProgressDao = QuizProgressDao();

  const QuizProgressRepo();

  Future<double> getQuizProgressByTopicId(String topicId) async {
    return await quizProgressDao.getQuizProgressByTopicId(topicId);
  }
}