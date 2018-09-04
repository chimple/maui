import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import 'package:sqflite/sqflite.dart';

class QuizProgressDao {
  Future<double> getScoreSummaryByTopicId(String topicId, {Database db}) async {
    print("Topic Id received by Quiz Progress Dao - $topicId");
    db = db ?? await new AppDatabase().getDb();
    
    List maxScoreSum = (await db.query(QuizProgress.table,
        columns: ['sum(${QuizProgress.maxScoreCol})'],
        where: "${QuizProgress.topicIdCol} = ?",
        whereArgs: [topicId]));

    List outOfTotalScoreSum = (await db.query(
        QuizProgress.table,
        columns: ['sum(${QuizProgress.outOfTotalCol})'],
        where: "${QuizProgress.topicIdCol} = ?",
        whereArgs: [topicId]));

    print("Value of maxScoreSum = ${maxScoreSum[0]["sum(maxScore)"]}");
    print("Value of outOfTotalScoreSum = ${outOfTotalScoreSum[0]["sum(outOfTotal)"]}");

    if(maxScoreSum[0]["sum(maxScore)"] != null){
      return (maxScoreSum[0]["sum(maxScore)"] / outOfTotalScoreSum[0]["sum(outOfTotal)"]);
    }
    else{
    return null;
    }
  }
}
