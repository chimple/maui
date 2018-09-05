import 'dart:async';


import 'package:maui/db/entity/quiz_progress.dart';
import 'package:maui/db/dao/quiz_progress_dao.dart';

class QuizProgressRepo {
  static final QuizProgressDao quizProgressDao = QuizProgressDao();

  const QuizProgressRepo();

  Future<double> getScoreSummaryByTopicId(String topicId) async {
    print("Topic Id received by Quiz progressRepo = $topicId");
    return await quizProgressDao.getScoreSummaryByTopicId(topicId);
  }

  Future<QuizProgress> getQuizProgressByTopicAndQuizId(
      String topicId, String quizId) async {
    return await quizProgressDao.getQuizProgressByTopicAndQuizId(
        topicId, quizId);
  }


  Future<String> insertOrUpdateQuizProgress(String id, String userId,
      String topicId, String quizId, int maxScore, int outOfTotal) async {
    QuizProgress quizProgress =
        await quizProgressDao.getQuizProgressByTopicAndQuizId(topicId, quizId);
    if (quizProgress == null) {
      await quizProgressDao.insertQuizProgress(new QuizProgress(
        id: id,
        topicId: topicId,
        userId: userId,
        maxScore: maxScore,
        outOfTotal: outOfTotal,
        quizId: quizId,
      ));
      return "inserted";
    } else {
      if (quizProgress.maxScore < maxScore) {
        await quizProgressDao.updateQuizProgress(new QuizProgress(
          id: id,
          topicId: topicId,
          userId: userId,
          maxScore: maxScore,
          outOfTotal: outOfTotal,
          quizId: quizId,
        ));
        return "Current maxScore updated";
      } else {
        return "Current maxScore is less than or equal to the Previous maxScore";
      }
    }
  }
}
