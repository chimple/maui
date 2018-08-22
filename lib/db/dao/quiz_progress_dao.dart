import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/db/entity/topic.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:sqflite/sqflite.dart';

class QuizProgressDao {
  Future<QuizProgress> getQuizprogress(String id, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuizProgress.table,
        columns: [
          QuizProgress.idCol,
          QuizProgress.userIdCol,
          QuizProgress.topicIdCol,
          QuizProgress.quizIdCol,
          QuizProgress.doneCol
        ],
        where: "${QuizProgress.idCol} = ? ",
        whereArgs: [id]);
    if (maps.length > 0) {
      return QuizProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<QuizProgress>> getQuizProgressByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps =
        await db.query('${QuizProgress.table} a,${Topic.table} t', columns: [
      'a.${QuizProgress.idCol}',
      'a.${QuizProgress.userIdCol}',
      'a.${QuizProgress.topicIdCol}',
      'a.${QuizProgress.quizIdCol}',
      'a.${QuizProgress.doneCol}',
    ], where: '''
      a.${QuizProgress.topicIdCol} = t.${Topic.idCol} 
      AND  a.${QuizProgress.topicIdCol} = ?
        ''', whereArgs: [
      topicId
    ]);
    return maps.map((el) => new QuizProgress.fromMap(el)).toList();
  }

  Future<List<QuizProgress>> getQuizProgressByUserId(String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps =
        await db.query('${QuizProgress.table} a,${User.table} u', columns: [
      'a.${QuizProgress.idCol}',
      'a.${QuizProgress.userIdCol}',
      'a.${QuizProgress.topicIdCol}',
      'a.${QuizProgress.quizIdCol}',
      'a.${QuizProgress.doneCol}',
    ], where: '''
      a.${QuizProgress.topicIdCol} = u.${User.columnId} 
      AND  a.${QuizProgress.userIdCol} = ?
        ''', whereArgs: [
      userId
    ]);
    return maps.map((el) => new QuizProgress.fromMap(el)).toList();
  }

  Future<List<QuizProgress>> getQuizProgressByQuizId(String quizId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps =
        await db.query('${QuizProgress.table} a,${Quiz.table} q', columns: [
      'a.${QuizProgress.idCol}',
      'a.${QuizProgress.userIdCol}',
      'a.${QuizProgress.topicIdCol}',
      'a.${QuizProgress.quizIdCol}',
      'a.${QuizProgress.doneCol}',
    ], where: '''
      a.${QuizProgress.quizIdCol} = q.${Quiz.idCol} 
      AND  a.${QuizProgress.quizIdCol} = ?
        ''', whereArgs: [
      quizId
    ]);
    return maps.map((el) => new QuizProgress.fromMap(el)).toList();
  }
}
