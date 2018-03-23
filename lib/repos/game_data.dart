import 'dart:async';
import 'dart:core';
import 'game_category_repo.dart';
import 'lesson_unit_repo.dart';
import 'package:maui/db/entity/unit.dart';

enum Category {
  letter,
  number
}

Future<List<Unit>> fetchSerialData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var eagerLessonUnits = await new LessonUnitRepo().getEagerLessonUnitsByLessonId(
        gameCategory.lessonId);
    return eagerLessonUnits.map((e) => e.objectUnit).toList(growable: false);
  }
  return null;
}
