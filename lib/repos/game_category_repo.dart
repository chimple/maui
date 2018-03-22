import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/game_category.dart';
import 'package:maui/db/dao/game_category_dao.dart';

class GameCategoryRepo {
  static final GameCategoryDao gameCategoryDao = new GameCategoryDao();

  const GameCategoryRepo();

  Future<List<GameCategory>> getGameCategoriesByGame(String game) async {
    return await gameCategoryDao.getGameCategoriesByGame(game);
  }
}