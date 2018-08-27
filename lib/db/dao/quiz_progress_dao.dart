import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import 'package:sqflite/sqflite.dart';

class QuizProgressDao {
  Future<QuizProgress> getQuizProgress(String id, {Database db}) async {
    print("QuizProgress Dao get QuizProgress - $id");
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
        print("QuizprogressDao maps value - $maps");
    if (maps.length > 0) {
      print("Map return QuizProgressDao - $maps");
      return QuizProgress.fromMap(maps.first);
    }
    return null;
  }
}
