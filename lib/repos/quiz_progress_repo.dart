import 'dart:async';

import 'package:maui/db/entity/quiz_progress.dart';
import 'package:maui/db/dao/quiz_progress_dao.dart';

class QuizProgressRepo {
  static final QuizProgressDao quizProgressDao = QuizProgressDao();

  const QuizProgressRepo();

  Future<QuizProgress> getQuizProgressByQuizProgressId(String id) async {
    return await quizProgressDao.getQuizProgressByQuizProgressId(id);
  }

  Future<QuizProgress> getQuizProgressByTopicAndQuizId(
      String topicId, String quizId) async {
    return await quizProgressDao.getQuizProgressByTopicAndQuizId(
        topicId, quizId);
  }

  Future<QuizProgress> getQuizProgressByTopicId(String topicId) async {
    return await quizProgressDao.getQuizProgressByTopicId(topicId);
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
