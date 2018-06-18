import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:tuple/tuple.dart';

import 'concept_repo.dart';
import 'game_category_repo.dart';
import 'lesson_unit_repo.dart';
import 'lesson_repo.dart';
import 'unit_repo.dart';

enum Category { letter, number }

Future<List<String>> fetchSerialData(int lessonId) async {
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  return lessonUnits.map((e) => e.subjectUnitId).toList(growable: false);
}

Future<Tuple2<String, List<String>>> fetchSequenceData(
    int lessonId, int maxData) async {
  print('fetchSequenceData');
  var rand = new Random();
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  var start = rand.nextInt(max(1, lessonUnits.length - maxData));
  var sequence = lessonUnits
      .skip(start)
      .take(maxData)
      .map((e) => e.subjectUnitId)
      .toList(growable: false);
  var answer = sequence[rand.nextInt(sequence.length)];
  return new Tuple2(answer, sequence);
}

Future<Tuple2<String, List<String>>> fetchSequenceDataForCategory(
    int categoryId, int maxData) async {
  var rand = new Random();
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
  var maxNumber = 10;
  switch (category?.name) {
    case '0-9':
      maxNumber = 10;
      break;
    case '0-99':
      maxNumber = 100;
      break;
  }
  List<String> sequence = new List<String>();
  var start = rand.nextInt(maxNumber);
  for (int i = start; i < start + maxData; i++) {
    sequence.add(i.toString());
  }
  var answer = sequence[rand.nextInt(sequence.length)];
  return new Tuple2(answer, sequence);
}

Future<Map<String, String>> fetchPairData(int lessonId, int maxData) async {
  Lesson lesson = await new LessonRepo().getLesson(lessonId);
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  lessonUnits.shuffle();
  print(lessonUnits);
  //TODO: get only unique objects and subjects
  //TODO: cut across areaId to get concept->word
  return new Map<String, String>.fromIterable(
      lessonUnits.sublist(0, min(maxData, lessonUnits.length)),
      key: (e) => (lesson.conceptId == 3 || lesson.conceptId == 5)
          ? e.objectUnitId
          : e.subjectUnitId,
      value: (e) => (e.objectUnitId != null && e.objectUnitId.isNotEmpty)
          ? e.objectUnitId
          : e.subjectUnitId);
}

Future<Tuple3<String, String, bool>> fetchTrueOrFalse(int lessonId) async {
  Lesson lesson = await new LessonRepo().getLesson(lessonId);
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  lessonUnits.shuffle();
  var lu = lessonUnits[0];
  var boolAnswer = new Random().nextBool();
  String question;
  String answer;
  if (lesson.conceptId == 2) {
    question = lu.subjectUnitId;
    answer = boolAnswer ? lu.objectUnitId : lessonUnits[1].objectUnitId;
  } else if (lesson.conceptId == 3 || lesson.conceptId == 5) {
    question = lu.objectUnitId;
    answer = boolAnswer ? lu.objectUnitId : lessonUnits[1].objectUnitId;
  } else {
    question = lu.subjectUnitId;
    answer = boolAnswer ? lu.subjectUnitId : lessonUnits[1].subjectUnitId;
  }
  return new Tuple3(question, answer, boolAnswer);
}

Future<List<List<String>>> fetchRollingData(
    int lessonId, int numChoices) async {
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  var lu = lessonUnits[new Random().nextInt(lessonUnits.length)];
  var word = lu.subjectUnitId.length > 1
      ? lu.subjectUnitId
      : (lu.objectUnitId?.length ?? 0) > 1 ? lu.objectUnitId : lu.subjectUnitId;
  return Future.wait(word.runes.map((r) async {
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
    int lessonId) async {
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  var rand = new Random();
  var lu = lessonUnits[rand.nextInt(lessonUnits.length)];
  var word = lu.subjectUnitId.length > 1
      ? lu.subjectUnitId
      : (lu.objectUnitId?.length ?? 0) > 1 ? lu.objectUnitId : lu.subjectUnitId;
  if (word.length == 1) {
    word = word.padRight(5, word);
  }
  var runes = word.runes;
  return Future.wait(runes.map((r) async {
    var rune = new String.fromCharCode(r);
    if (rand.nextBool()) {
      return new Tuple2('', rune);
    }
    var otherUnits = await new UnitRepo().getUnitsOfSameTypeAs(rune);
    return new Tuple2(rune, otherUnits[rand.nextInt(otherUnits.length)].name);
  }).toList(growable: false));
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
        table.add(new Tuple4(number, 'X', i, number * i));
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
  var rand = new Random();
  switch (rand.nextInt(2)) {
    case (0):
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
      break;
  }
  return new Tuple2([
    ['C', 'A', 'T', null, null, 'E'],
    [null, 'N', null, null, null, 'G'],
    [null, 'T', 'I', 'G', 'E', 'R'],
    [null, null, 'B', null, null, 'E'],
    [null, null, 'E', null, null, 'T'],
    [null, 'O', 'X', 'E', 'N', null]
  ], [
    new Tuple4('assets/apple.png', 0, 0, Direction.across),
    new Tuple4('assets/apple.png', 0, 1, Direction.down),
    new Tuple4('assets/apple.png', 0, 5, Direction.down),
    new Tuple4('assets/apple.png', 2, 1, Direction.across),
    new Tuple4('assets/apple.png', 2, 2, Direction.down),
    new Tuple4('assets/apple.png', 5, 1, Direction.across)
  ]);
}

Future<Tuple2<List<String>, String>> fetchCirclewrdData(int categoryId) async {

var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);

  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
   
  

  var rand = new Random();
  var startNum = rand.nextInt(max(0, 4));
  switch (0) {
    case 0:
      return new Tuple2([
        
          
          ' actings',
          'casing',
          'cast',
          'cat',
          'scat',
          'act',
          'ta',
          'st',
          'sat',
          'sac',
          'at',
          'tas',
          'as',
          	
"GEN",	
"GET",	
"GIE",	
"GIN",	
"GIS",	
"GIT",	
"ING",	
"NAG",	
"NEG",	
"SAG",	
"SEG",	
"SIG",	
"TAG",	
"TEG",	
"TIG",	
"AIN",	
"AIS",	
"AIT",		
"ANI",	
"ANS",	
"ANT",	
"ASS",	
"ATE",	
"ATS",	
"EAN",	
"EAS",	
"EAT",	
"ENS",	
"ESS",	
"EST",	
"ETA",	
"INS",	
"ITA",	
"ITS",	
"NAE",	
"NAS",	
"NAT",	


"ETAS",	
"ETNA",	
"ISNA",	
"ITAS",	
"NAES",	
"NATS",	
"NEAT",	
"NESS",	
"NEST",	
"NETS",	
"NIES",	
"NITE",	
"NITS",	
"SAIN",	
"SAIS",
"SANE",
"SANS",
"SANT",
"SATE",	
          'ats'
        
      ],'catseings');
      break;
    case 1:
      return new Tuple2(
        ['upsc', 'cusp', 'scup', 'cup', 'pus', 'sup', 'ups', 'up', 'us'],
       'upsc');
      break;
    case 2:
      return new Tuple2(
        ['ucts', 'scut', 'cut', 'uts', 'st', 'us', 'ut'],
      'ucts');
      break;
    case 3:
      return new Tuple2(
        [
          'hate',
          'eath',
          'haet',
          'heat',
          'thae',
          'eth',
          'hae',
          'hat',
          'het',
          'the',
          'ah',
          'eh',
          'ha',
          'he',
          'ate',
          'eat',
          'eta',
          'tae',
          'tea',
          'ae',
          'at',
          'ea',
          'et',
          'ta',
          'te'
        ],
       'hate');
      break;
  }
   return null;
}
}

Future<Tuple3<String, String, List<String>>> fetchMultipleChoiceData(
    int lessonId, int maxChoices) async {
  Lesson lesson = await new LessonRepo().getLesson(lessonId);
  List<LessonUnit> lessonUnits;
  lessonUnits = await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  lessonUnits.shuffle();
  String question;
  String answer;
  List<String> choices;
  if (lesson.conceptId == 3 || lesson.conceptId == 5) {
    question = lessonUnits[0].objectUnitId;
    answer = lessonUnits[0].objectUnitId;
    choices = lessonUnits
        .where((l) => l.objectUnitId != answer)
        .take(maxChoices)
        .map((l) => l.objectUnitId)
        .toList(growable: false);
  } else {
    question = lessonUnits[0].subjectUnitId;
    answer = (lessonUnits[0].objectUnitId?.length ?? 0) > 0
        ? lessonUnits[0].objectUnitId
        : lessonUnits[0].subjectUnitId;
    choices = lessonUnits
        .where((l) => l.subjectUnitId != question)
        .take(maxChoices)
        .map((l) => (l.objectUnitId?.length ?? 0) > 0
            ? l.objectUnitId
            : l.subjectUnitId)
        .toList(growable: false);
  }
  return new Tuple3(question, answer, choices);
}

Future<Tuple2<List<String>, List<String>>> fetchWordData(
    int lessonId, int maxLength, int otherLength) async {
  List<LessonUnit> lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  Lesson lesson = await new LessonRepo().getLesson(lessonId);
  lessonUnits.shuffle();
  List<String> words;
  List<String> wordLetters;
  if (lesson.conceptId == 3 || lesson.conceptId == 5) {
    words = lessonUnits.map((l) => l.objectUnitId).toList(growable: false);
  } else {
    words = lessonUnits.map((l) => l.subjectUnitId).toList(growable: false);
  }
  String word = words.firstWhere((w) => w.length <= maxLength);

  if (lesson.conceptId == 1 || lesson.conceptId == 2 || lesson.conceptId == 6) {
    word = word.padRight(maxLength, word);
  }

  wordLetters =
      word.runes.map((r) => new String.fromCharCode(r)).toList(growable: false);

  var otherUnits = await new UnitRepo().getUnitsOfSameTypeAs(wordLetters[0]);
  otherUnits.shuffle();
  var otherLetters = otherUnits
      .where((u) => !wordLetters.contains(u.name))
      .take(otherLength)
      .map((u) => u.name)
      .toList(growable: false);
  return new Tuple2(wordLetters, otherLetters);
}

Future<Tuple2<List<String>, List<String>>> fetchConsecutiveData(
    int categoryId, int maxLength, int otherLength) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
    var rand = new Random();
    switch (category?.name) {
      case '0-9':
        var startNum = rand.nextInt(max(0, 9 - maxLength));
        List<String> consecutive = new List<String>();
        for (int i = startNum; i < startNum + maxLength; i++) {
          consecutive.add(i.toString());
        }
        List<String> other = new List<String>();
        for (int i = 0; i < otherLength; i++) {
          var nextNum =
              (startNum + maxLength + 1 + rand.nextInt(max(0, 9 - maxLength))) %
                  10;
          if (nextNum == startNum - 1) {
            nextNum = startNum + maxLength + 1 + nextNum;
          }
          other.add(nextNum.toString());
        }
        return new Tuple2(consecutive, other);
        break;
      case '0-99':
        var startNum = rand.nextInt(max(0, 99 - maxLength));
        List<String> consecutive = new List<String>();
        for (int i = startNum; i < startNum + maxLength; i++) {
          consecutive.add(i.toString());
        }
        List<String> other = new List<String>();
        for (int i = 0; i < otherLength; i++) {
          var nextNum = (startNum +
                  maxLength +
                  1 +
                  rand.nextInt(max(0, 99 - maxLength))) %
              100;
          other.add(nextNum.toString());
        }
        return new Tuple2(consecutive, other);
        break;
    }
  }
  return null;
}

Future<Tuple2<List<String>, String>> fetchFirstWordData(int categoryId) async {
  var rand = new Random();
  var startNum = rand.nextInt(max(0, 3));
  switch (startNum) {
    case 0:
      return new Tuple2(
          ['cricket', 'tennis', 'golf', 'hockey', 'football'], 'SPORTS');
      break;
    case 1:
      return new Tuple2(['cat', 'dog', 'elephant', 'horse'], 'ANIMALS');
      break;
    case 2:
      return new Tuple2(['car', 'bus', 'train'], 'VEHICLES');
      break;
  }
  return null;
}

Future<Map<String, Map<String, List<String>>>> fetchClueGame(
    int categoryId) async {
  var completer = Completer<Map<String, Map<String, List<String>>>>();
  Map<String, List<String>> drink = {
    'water': ['wa', 'ter'],
    'milk': ['mi', 'lk'],
    'coke': ['co', 'ke'],
    'beer': ['be', 'er'],
  };
  Map<String, List<String>> travel = {
    'bus': ['bu', 's'],
    'car': ['ca', 'r'],
    'train': ['tr', 'ain'],
    'aeroplane': ['aero', 'plane'],
  };
  Map<String, List<String>> redfruit = {
    'apple': ['ap', 'ple'],
    'cheery': ['che', 'ery'],
    'litchi': ['lit', 'chi'],
    'tomoto': ['tom', 'oto'],
  };
  Map<String, List<String>> blackpet = {
    'cat': ['ca', 't'],
    'dog': ['do', 'g'],
    'panda': ['pa', 'nda'],
    'cow': ['co', 'w'],
  };
  Map<String, Map<String, List<String>>> value = {
    'drink': drink,
    'travel': travel,
    'redfruit': redfruit,
    'blackpet': blackpet
  };
  completer.complete(value);
  return completer.future;
}
Future <Tuple3<String,List<String>,List<String>>> fetchPictureSentenceData(int categoryId) async{

 String sentence1 = "MOUNT EVEREST is the highest _ in the _";
 //String sentence2 = "Today is_ ";
 List<String> answer = ['mountain','world'];
 List<String> option =['mountain','world','chair','home'];
 return new Tuple3(
   sentence1, 
   answer,
    option);

}
