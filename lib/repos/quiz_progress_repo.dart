import 'dart:async';

import 'package:maui/db/dao/quiz_progress_dao.dart';

class QuizProgressRepo {
  static final QuizProgressDao quizProgressDao = QuizProgressDao();

  const QuizProgressRepo();

  Future<double> getScoreSummaryByTopicId(String topicId) async {
    print("Topic Id received by Quiz progressRepo = $topicId");
    return await quizProgressDao.getScoreSummaryByTopicId(topicId);
  }
}