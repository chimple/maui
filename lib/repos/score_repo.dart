import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/score.dart';
import 'package:maui/db/dao/score_dao.dart';

class ScoreRepo {
  static final ScoreDao scoreDao = new ScoreDao();

  const ScoreRepo();

  Future<List<Score>> getScoresByUserByGame(String userId, String game) async {
    return await scoreDao.getScoresByUserByGame(userId, game);
  }

  Future<Map<String, int>> getScoreCountByUser(String userId) async {
    return await scoreDao.getScoreCountByUser(userId);
  }

  Future<Map<String, List<Score>>> getScoreMapByUser(String userId) async {
    return await scoreDao.getScoreMapByUser(userId);
  }

  Future<Score> insert(Score score) async {
    return scoreDao.insert(score);
  }
}
