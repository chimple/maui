import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'game_category_repo.dart';
import 'lesson_unit_repo.dart';
import 'package:maui/db/entity/unit.dart';

enum Category { letter, number }

Future<List<String>> fetchSerialData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    return lessonUnits.map((e) => e.objectUnitId).toList(growable: false);
  }
  //TODO: gameCategory.conceptId
  return null;
}

Future<Map<String, String>> fetchPairData(int categoryId, int maxData) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    lessonUnits.shuffle();
    //TODO: get only unique objects and subjects
    return new Map<String, String>.fromIterable(
        lessonUnits.sublist(0, max(maxData - 1, lessonUnits.length - 1)),
        key: (e) => e.objectUnitId,
        value: (e) => e.subjectUnitId);
  }
  //TODO: gameCategory.conceptId
  return null;
}

Future<Tuple2<String, bool>> fetchTrueOrFalse(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    lessonUnits.shuffle();
    var lu = lessonUnits[0];
    return new Tuple2(lu.objectUnitId,
        lu.subjectUnitId.substring(0, 1).toUpperCase() == 'T' ? true : false);
  } else if (gameCategory.conceptId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsBelowSeqAndByConceptId(10, gameCategory.conceptId);
    lessonUnits.shuffle();
    var boolAnswer = new Random().nextBool();
    if (boolAnswer) {
      return new Tuple2('${lessonUnits[0].subjectUnitId} for ${lessonUnits[0].objectUnitId}', true);
    } else {
      var alternateQuestion = lessonUnits
          .skip(1)
          .firstWhere((l) => lessonUnits[0].subjectUnitId != l.subjectUnitId);
      return new Tuple2('${lessonUnits[0].subjectUnitId} for ${alternateQuestion.objectUnitId}', false);
    }
  }
  return null;
}
