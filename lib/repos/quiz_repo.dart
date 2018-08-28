import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/dao/quiz_dao.dart';

class QuizRepo {
  static final QuizDao quizDao = new QuizDao();

  const QuizRepo();

  Future<List<Quiz>> getQuizzesByTopicId(String topicId) async {
    return await quizDao.getQuizzesByTopicId(topicId);
  }

  Future<Quiz> getQuiz(int id) async {
    return await quizDao.getQuiz(id);
  }
}
