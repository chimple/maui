import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import 'package:sqflite/sqflite.dart';

class QuizProgressDao {

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

    List<int> maxScore = [];
    List<int> outOfTotal = [];
    int maxScoreTotal = 0, outOfTotalScore = 0;

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
