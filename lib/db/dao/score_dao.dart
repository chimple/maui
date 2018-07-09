import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/score.dart';
import 'package:sqflite/sqflite.dart';

class ScoreDao {
  Future<List<Score>> getScoresByUserByGame(String userId, String game,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Score.table,
        columns: [
          Score.myUserCol,
          Score.otherUserCol,
          Score.myScoreCol,
          Score.otherScoreCol,
          Score.gameCol,
          Score.playedAtCol
        ],
        where: "${Score.myUserCol} = ? AND ${Score.gameCol} = ?",
        whereArgs: [userId, game]);
    return maps.map((scoreMap) => new Score.fromMap(scoreMap)).toList();
  }

  Future<Map<String, int>> getScoreCountByUser(String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Score.table,
        columns: [Score.gameCol, 'sum(${Score.myScoreCol}'],
        where: "${Score.myUserCol} = ?",
        groupBy: '${Score.gameCol}');
    Map<String, int> returnMap = Map<String, int>();
    maps.forEach(
        (n) => returnMap[n[Score.gameCol]] = n['sum(${Score.myScoreCol}']);
    return returnMap;
  }

  Future<Score> insert(Score score, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(Score.table, score.toMap());
    return score;
  }
}
