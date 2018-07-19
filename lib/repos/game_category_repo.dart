import 'dart:async';
import 'dart:core';
import 'package:tuple/tuple.dart';

import 'package:maui/db/entity/game_category.dart';
import 'package:maui/db/dao/game_category_dao.dart';
import 'package:maui/db/dao/lesson_dao.dart';

class GameCategoryRepo {
  static final GameCategoryDao gameCategoryDao = new GameCategoryDao();
  static final LessonDao lessonDao = new LessonDao();

  static final List<String> mathGames = <String>[
    'abacus',
    'tables',
    'calculate_numbers',
    'fill_number',
    'connect_the_dots',
    'tap_home',
    'word_grid',
    'guess',
    'circle_word',
    'draw_challenge',
    'friend_word',
    'crossword',
    'picture_sentence',
    'clue_game',
    'identify'
  ];

  static final List<String> orderedGames = <String>['reflex', 'order_it'];

  const GameCategoryRepo();

  Future<List<Tuple3<int, int, String>>> getGameCategoriesByGame(
      String game) async {
    if (mathGames.contains(game)) {
      var gameCategories = await gameCategoryDao.getGameCategoriesByGame(game);
      return gameCategories
          .map((g) => new Tuple3(g.id, g.conceptId, g.name))
          .toList(growable: false);
    } else if (orderedGames.contains(game)) {
      var lessons = await lessonDao.getLessonsByHasOrder(1);
      return lessons
          .map((l) => new Tuple3(l.id, l.conceptId, l.title))
          .toList(growable: false);
    } else {
      var lessons = await lessonDao.getLessons();
      return lessons
          .map((l) => new Tuple3(l.id, l.conceptId, l.title))
          .toList(growable: false);
    }
  }

  Future<GameCategory> getGameCategory(int gameCategoryId) async {
    return await gameCategoryDao.getGameCategory(gameCategoryId);
  }
}
