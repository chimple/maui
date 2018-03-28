import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'game_category_repo.dart';
import 'lesson_unit_repo.dart';
import 'unit_repo.dart';

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
        lessonUnits.sublist(0, min(maxData, lessonUnits.length)),
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
      return new Tuple2(
          '${lessonUnits[0].subjectUnitId} for ${lessonUnits[0].objectUnitId}',
          true);
    } else {
      var alternateQuestion = lessonUnits
          .skip(1)
          .firstWhere((l) => lessonUnits[0].subjectUnitId != l.subjectUnitId);
      return new Tuple2(
          '${lessonUnits[0].subjectUnitId} for ${alternateQuestion.objectUnitId}',
          false);
    }
  }
  return null;
}

Future<List<List<String>>> fetchRollingData(
    int categoryId, int numChoices) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    var lu = lessonUnits[new Random().nextInt(lessonUnits.length)];
    return Future.wait(lu.subjectUnitId.runes.map((r) async {
      var rune = new String.fromCharCode(r);
      var otherUnits = await new UnitRepo().getUnitsOfSameTypeAs(rune);
      var otherRunes = otherUnits.map((u) => u.name).toList(growable: false);
      var index = otherRunes.indexOf(rune);
      if (index < 0) {
        otherUnits = await new UnitRepo().getUnits();
        otherRunes = otherUnits.map((u) => u.name).toList(growable: false);
        return [rune]
          ..addAll(otherRunes.sublist(0, numChoices - 1))
          ..add(rune);
      }
      int start = max(0, index - (numChoices / 2).round());
      int end = min(otherRunes.length, start + numChoices);
      return [rune]..addAll(otherRunes.sublist(start, end));
    }).toList(growable: false));
  }
  //TODO: gameCategory.conceptId
  return null;
}

Future<Tuple2<String, String>> fetchFillInTheBlanksData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    var lu = lessonUnits[new Random().nextInt(lessonUnits.length)];
    return new Tuple2(lu.subjectUnitId, lu.objectUnitId);
  }
  return null;
}
