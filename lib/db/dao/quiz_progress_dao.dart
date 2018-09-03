import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import 'package:sqflite/sqflite.dart';

class QuizProgressDao {
  Future<QuizProgress> getQuizProgressByQuizProgressId(String id,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuizProgress.table,
        columns: [
          QuizProgress.idCol,
          QuizProgress.userIdCol,
          QuizProgress.topicIdCol,
          QuizProgress.quizIdCol,
          QuizProgress.maxScoreCol,
          QuizProgress.outOfTotalCol
        ],
        where: "${QuizProgress.idCol} = ? ",
        whereArgs: [id]);
    if (maps.length > 0) {
      return QuizProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<double> getQuizProgressByTopicId(String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuizProgress.table,
        columns: [
          QuizProgress.idCol,
          QuizProgress.userIdCol,
          QuizProgress.topicIdCol,
          QuizProgress.quizIdCol,
          QuizProgress.maxScoreCol,
          QuizProgress.outOfTotalCol
        ],
        where: "${QuizProgress.topicIdCol} = ?",
        whereArgs: [topicId]);
    print("Topic Id received in QuizprogressDao - $topicId");
    List<int> maxScore = [];
    List<int> outOfTotal = [];
    int maxScoreTotal, outOfTotalScore;

    maxScore = maps.map((el) => new QuizProgress.fromMap(el).maxScore).toList();
    outOfTotal =
        maps.map((el) => new QuizProgress.fromMap(el).outOfTotal).toList();

    for (int i = 0; i < maxScore.length; i++) {
      maxScoreTotal = maxScoreTotal + maxScore[i];
      outOfTotalScore = outOfTotalScore + outOfTotal[i];
    }

    if (maps.length > 0) {
      return (maxScoreTotal / outOfTotalScore);
    }
    return null;
  }
}
