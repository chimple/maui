import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'game_category_repo.dart';
import 'lesson_unit_repo.dart';
import 'unit_repo.dart';
import 'concept_repo.dart';

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

Future<List<Tuple2<String, String>>> fetchWordWithBlanksData(
    int categoryId) async {
  //TODO make sure that caps and non caps are not provided
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    var rand = new Random();
    var lu = lessonUnits[rand.nextInt(lessonUnits.length)];
    var runes = lu.subjectUnitId.runes;
    return Future.wait(runes.map((r) async {
      var rune = new String.fromCharCode(r);
      if (rand.nextBool()) {
        return new Tuple2('', rune);
      }
      var otherUnits = await new UnitRepo().getUnitsOfSameTypeAs(rune);
      return new Tuple2(rune, otherUnits[rand.nextInt(otherUnits.length)].name);
    }).toList(growable: false));
  }
  //TODO: gameCategory.conceptId
  return null;
}

Future<Tuple4<int, String, int, int>> fetchMathData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
    var rand = new Random();
    switch (category?.name) {
      case 'Single digit addition without carryover':
        var firstNum = rand.nextInt(8) + 1;
        var secondNum = rand.nextInt(9 - firstNum) + 1;
        var sum = firstNum + secondNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 'Single digit addition with carryover':
        var firstNum = rand.nextInt(9) + 1;
        var sum = rand.nextInt(firstNum) + 10;
        var secondNum = sum - firstNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 'Double digit addition without carryover':
        var firstNum = rand.nextInt(98) + 1;
        var secondNum = rand.nextInt(99 - firstNum) + 1;
        var sum = firstNum + secondNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 'Double digit addition with carryover':
        //TODO: no carry over at all
        var firstNum = rand.nextInt(98) + 1;
        var sum = rand.nextInt(firstNum) + 100;
        var secondNum = sum - firstNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 'Triple digit addition without carryover':
        var firstNum = rand.nextInt(998) + 1;
        var secondNum = rand.nextInt(999 - firstNum) + 1;
        var sum = firstNum + secondNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 'Triple digit addition with carryover':
        var firstNum = rand.nextInt(998) + 1;
        var sum = rand.nextInt(firstNum) + 1000;
        var secondNum = sum - firstNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 'Single digit subtraction without borrow':
        var firstNum = rand.nextInt(8) + 2;
        var secondNum = rand.nextInt(firstNum - 1) + 1;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 'Double digit subtraction without borrow':
        var firstNumTens = rand.nextInt(9) + 1;
        var firstNumUnits = rand.nextInt(9) + 1;
        var firstNum = firstNumTens * 10 + firstNumUnits;
        var secondNumTens = rand.nextInt(firstNumTens) + 1;
        var secondNumUnits = rand.nextInt(firstNumUnits) + 1;
        var secondNum = secondNumTens * 10 + secondNumUnits;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 'Double digit subtraction with borrow':
        var firstNumTens = rand.nextInt(8) + 2;
        var firstNumUnits = rand.nextInt(8) + 1;
        var firstNum = firstNumTens * 10 + firstNumUnits;
        var secondNumTens = rand.nextInt(firstNumTens - 1) + 1;
        var secondNumUnits =
            rand.nextInt(9 - firstNumUnits) + firstNumUnits + 1;
        var secondNum = secondNumTens * 10 + secondNumUnits;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 'Triple digit subtraction without borrow':
        var firstNumHundreds = rand.nextInt(9) + 1;
        var firstNumTens = rand.nextInt(9) + 1;
        var firstNumUnits = rand.nextInt(9) + 1;
        var firstNum =
            firstNumHundreds * 100 + firstNumTens * 10 + firstNumUnits;
        var secondNumHundreds = rand.nextInt(firstNumHundreds) + 1;
        var secondNumTens = rand.nextInt(firstNumTens) + 1;
        var secondNumUnits = rand.nextInt(firstNumUnits) + 1;
        var secondNum =
            secondNumHundreds * 100 + secondNumTens * 10 + secondNumUnits;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 'Triple digit subtraction with borrow':
        var firstNumHundreds = rand.nextInt(8) + 2;
        var firstNumTens = rand.nextInt(8) + 1;
        var firstNumUnits = rand.nextInt(8) + 1;
        var firstNum =
            firstNumHundreds * 100 + firstNumTens * 10 + firstNumUnits;
        var secondNumHundreds = rand.nextInt(firstNumHundreds - 1) + 1;
        var secondNumTens = rand.nextInt(9 - firstNumTens) + firstNumTens + 1;
        var secondNumUnits =
            rand.nextInt(9 - firstNumUnits) + firstNumUnits + 1;
        var secondNum =
            secondNumHundreds * 100 + secondNumTens * 10 + secondNumUnits;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 'Single digit multiplication':
        var firstNum = rand.nextInt(9) + 1;
        var secondNum = rand.nextInt(9) + 1;
        var product = firstNum * secondNum;
        return new Tuple4(firstNum, '*', secondNum, product);
        break;
      case 'Single digit with double digit multiplication':
        var firstNum = rand.nextInt(9) + 1;
        var secondNum = rand.nextInt(90) + 10;
        var product = firstNum * secondNum;
        return new Tuple4(firstNum, '*', secondNum, product);
        break;
      case 'Double digit multiplication':
        var firstNum = rand.nextInt(90) + 10;
        var secondNum = rand.nextInt(90) + 10;
        var product = firstNum * secondNum;
        return new Tuple4(firstNum, '*', secondNum, product);
        break;
    }
  }
  return null;
}

Future<List<Tuple4<int, String, int, int>>> fetchTablesData(
    int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
    var rand = new Random();
    if (category?.name.endsWith('Tables')) {
      var number = int.parse(category.name.substring(0, 1));
      var table = <Tuple4<int, String, int, int>>[];
      for (var i = 1; i <= 10; i++) {
        table.add(new Tuple4(number, '*', i, number * i));
      }
      return table;
    }
  }
  return null;
}

Future<List<List<int>>> fetchFillNumberData(int categoryId, int size) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
    var rand = new Random();
    var number = int.parse(category?.name);
    var fillNumbers = new List<List<int>>();
    for (var i = 0; i < size; i++) {
      fillNumbers.add(<int>[]);
      for (var j = 0; j < size; j++) {
        fillNumbers[i].add(rand.nextInt(number) + 1);
      }
    }
    return fillNumbers;
  }
  return null;
}

enum Direction { across, down }
Future<Tuple2<List<List<String>>, List<Tuple4<String, int, int, Direction>>>>
    fetchCrosswordData(int categoryId) async {
  return new Tuple2([
    ['E', null, null, null, null],
    ['A', null, null, null, null],
    ['T', 'I', 'G', 'E', 'R'],
    [null, null, null, null, 'A'],
    [null, null, null, null, 'T']
  ], [
    new Tuple4('assets/apple.png', 0, 0, Direction.down),
    new Tuple4('assets/apple.png', 2, 0, Direction.across),
    new Tuple4('assets/apple.png', 2, 4, Direction.down),
  ]);
}
