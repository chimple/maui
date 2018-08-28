import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:sqflite/sqflite.dart';

class QuizDao {
  Future<Quiz> getQuiz(int id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Quiz.table,
        columns: [
          Quiz.idCol,
          Quiz.topicIdCol,
          Quiz.levelCol,
          Quiz.typeCol,
          Quiz.contentCol
        ],
        where: "${Quiz.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Quiz.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Quiz>> getQuizzesByTopicId(String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Quiz.table,
        columns: [
          Quiz.idCol,
          Quiz.topicIdCol,
          Quiz.levelCol,
          Quiz.typeCol,
          Quiz.contentCol
        ],
        where: "${Quiz.topicIdCol} = ?",
        whereArgs: [topicId]);
    return maps.map((el) => new Quiz.fromMap(el)).toList();
  }
}
