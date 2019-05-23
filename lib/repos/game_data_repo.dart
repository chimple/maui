import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter/services.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/models/display_item.dart';
import 'package:maui/models/game_data.dart';
import 'package:maui/models/multi_data.dart';
import 'package:maui/models/serializers.dart';
import 'package:tuple/tuple.dart';

import 'concept_repo.dart';
import 'game_category_repo.dart';
import 'lesson_repo.dart';
import 'lesson_unit_repo.dart';
import 'unit_repo.dart';

enum Category { letter, number }

const String basicCountingGame = 'BasicCountingGame';
const String bingoGame = 'BingoGame';
const String boxMatchingGame = 'BoxMatchingGame';
const String compareNumberGame = 'CompareNumberGame';
const String countingGame = 'CountingGame';
const String crosswordGame = 'CrosswordGame';
const String diceGame = 'DiceGame';
const String fillInTheBlanksGame = 'FillInTheBlanksGame';
const String findWordGame = 'FindWordGame';
const String fingerGame = 'FingerGame';
const String guessImageGame = 'GuessImageGame';
const String jumbledWordsGame = 'JumbledWordsGame';
const String madSentenceGame = 'MadSentenceGame';
const String matchTheShapeGame = 'MatchTheShapeGame';
const String matchWithImageGame = 'MatchWithImageGame';
const String mathOpGame = 'MathOpGame';
const String memoryGame = 'MemoryGame';
const String multipleChoiceGame = 'MultipleChoiceGame';
const String numberBalanceGame = 'NumberBalanceGame';
const String orderBySizeGame = 'OrderBySizeGame';
const String orderItGame = 'OrderItGame';
const String recognizeNumberGame = 'RecognizeNumberGame';
const String reflexGame = 'ReflexGame';
const String rhymeWordsGame = 'RhymeWordsGame';
const String rulerGame = 'RulerGame';
const String sequenceAlphabetGame = 'SequenceAlphabetGame';
const String sequenceTheNumberGame = 'SequenceTheNumberGame';
const String spinWheelGame = 'SpinWheelGame';
const String tapWrongGame = 'TapWrongGame';
const String tracingAlphabetGame = 'TracingAlphabetGame';
const String trueFalseGame = 'TrueFalseGame';
const String unitGame = 'UnitGame';

enum GameType {
  BasicCountingGame,
  BingoGame,
  BoxMatchingGame,
  CompareNumberGame,
  CountingGame,
  CrosswordGame,
  DiceGame,
  FillInTheBlanksGame,
  FindWordGame,
  FingerGame,
  GuessImageGame,
  JumbledWordsGame,
  MadSentenceGame,
  MatchTheShapeGame,
  MatchWithImageGame,
  MathOpGame,
  MemoryGame,
  MultipleChoiceGame,
  NumberBalanceGame,
  OrderBySizeGame,
  OrderItGame,
  RecognizeNumberGame,
  ReflexGame,
  RhymeWordsGame,
  RulerGame,
  SequenceAlphabetGame,
  SequenceTheNumberGame,
  SpinWheelGame,
  TapWrongGame,
  TracingAlphabetGame,
  TrueFalseGame,
  UnitGame
}

Map<ConceptType, List<GameType>> conceptGames = {
  ConceptType.upperCaseLetter: [
//    GameType.BingoGame,
//    GameType.BoxMatchingGame,
//    GameType.MemoryGame,
    GameType.MultipleChoiceGame,
//    GameType.SpinWheelGame,
    GameType.TracingAlphabetGame,
    GameType.MatchTheShapeGame,
//    GameType.TrueFalseGame,
//    GameType.JumbledWordsGame
  ],
  ConceptType.upperCaseToLowerCase: [
//    GameType.BingoGame,
//    GameType.BoxMatchingGame,
//    GameType.MemoryGame,
//    GameType.SpinWheelGame,
    GameType.MultipleChoiceGame,
    GameType.TracingAlphabetGame,
    GameType.MatchTheShapeGame,
//    GameType.TrueFalseGame,
//    GameType.JumbledWordsGame
  ],
  ConceptType.lowerCaseLetterToWord: [
//    GameType.BingoGame,
//    GameType.MemoryGame,
    GameType.TracingAlphabetGame,
    GameType.MatchTheShapeGame,
    GameType.MultipleChoiceGame,
//    GameType.TrueFalseGame,
//    GameType.FindWordGame,
//    GameType.JumbledWordsGame,
//    GameType.MatchWithImageGame,
//    GameType.SequenceAlphabetGame,
//    GameType.TapWrongGame,
  ],
  ConceptType.syllableToWord: [
//    GameType.BingoGame,
//    GameType.MemoryGame,
    GameType.TracingAlphabetGame,
    GameType.MatchTheShapeGame,
    GameType.MultipleChoiceGame,
//    GameType.TrueFalseGame,
//    GameType.FindWordGame,
//    GameType.JumbledWordsGame,
//    GameType.MatchWithImageGame,
//    GameType.SequenceAlphabetGame,
//    GameType.TapWrongGame,
  ],
  ConceptType.upperCaseLetterToWord: [
//    GameType.BingoGame,
//    GameType.MemoryGame,
    GameType.TracingAlphabetGame,
    GameType.MatchTheShapeGame,
    GameType.MultipleChoiceGame,
//    GameType.TrueFalseGame,
//    GameType.FindWordGame,
//    GameType.JumbledWordsGame,
//    GameType.MatchWithImageGame,
//    GameType.SequenceAlphabetGame,
//    GameType.TapWrongGame,
  ],
  ConceptType.lowerCaseLetter: [
//    GameType.BingoGame,
//    GameType.BoxMatchingGame,
//    GameType.MemoryGame,
//    GameType.SpinWheelGame,
    GameType.TracingAlphabetGame,
    GameType.MatchTheShapeGame,
    GameType.MultipleChoiceGame,
//    GameType.TrueFalseGame,
//    GameType.JumbledWordsGame
  ],
  ConceptType.singleDigitAdditionWithoutCarryover: [],
  ConceptType.singleDigitAdditionWithCarryover: [],
  ConceptType.doubleDigitAdditionWithoutCarryover: [],
  ConceptType.doubleDigitAdditionWithCarryover: [],
  ConceptType.tripleDigitAdditionWithoutCarryover: [],
  ConceptType.tripleDigitAdditionWithCarryover: [],
  ConceptType.singleDigitSubtractionWithoutBorrow: [],
  ConceptType.singleDigitSubtractionWithBorrow: [],
  ConceptType.doubleDigitSubtractionWithoutBorrow: [],
  ConceptType.doubleDigitSubtractionWithBorrow: [],
  ConceptType.tripleDigitSubtractionWithoutBorrow: [],
  ConceptType.tripleDigitSubtractionWithBorrow: [],
  ConceptType.singleDigitMultiplication: [],
  ConceptType.singleDigitWithDoubleDigitMultiplication: [],
  ConceptType.doubleDigitMultiplication: [],
  ConceptType.tables1: [],
  ConceptType.tables2: [],
  ConceptType.tables3: [],
  ConceptType.tables4: [],
  ConceptType.tables5: [],
  ConceptType.tables6: [],
  ConceptType.tables7: [],
  ConceptType.tables8: [],
  ConceptType.tables9: [],
  ConceptType.tables10: [],
  ConceptType.number1: [],
  ConceptType.number2: [],
  ConceptType.number3: [],
  ConceptType.number4: [],
  ConceptType.number5: [],
  ConceptType.number6: [],
  ConceptType.number7: [],
  ConceptType.number8: [],
  ConceptType.number9: [],
  ConceptType.number10: [],
  ConceptType.numbers0to9: [],
  ConceptType.numbers0to99: [],
};

Future<GameData> fetchLiteracyGameData(
    {GameType gameType, Lesson lesson}) async {
  DisplayTypeEnum subjectType;
  DisplayTypeEnum objectType;

  switch (lesson.conceptId ?? ConceptType.dummy) {
    case ConceptType.dummy:
      subjectType = DisplayTypeEnum.sentence;
      objectType = DisplayTypeEnum.sentence;
      break;
    case ConceptType.upperCaseLetter:
    case ConceptType.upperCaseToLowerCase:
    case ConceptType.lowerCaseLetter:
      subjectType = DisplayTypeEnum.letter;
      objectType = DisplayTypeEnum.letter;
      break;
    case ConceptType.lowerCaseLetterToWord:
    case ConceptType.upperCaseLetterToWord:
      subjectType = DisplayTypeEnum.letter;
      objectType = DisplayTypeEnum.word;
      break;
    case ConceptType.syllableToWord:
      subjectType = DisplayTypeEnum.syllable;
      objectType = DisplayTypeEnum.word;
      break;
    case ConceptType.singleDigitAdditionWithoutCarryover:
    case ConceptType.singleDigitAdditionWithCarryover:
    case ConceptType.doubleDigitAdditionWithoutCarryover:
    case ConceptType.doubleDigitAdditionWithCarryover:
    case ConceptType.tripleDigitAdditionWithoutCarryover:
    case ConceptType.tripleDigitAdditionWithCarryover:
    case ConceptType.singleDigitSubtractionWithoutBorrow:
    case ConceptType.singleDigitSubtractionWithBorrow:
    case ConceptType.doubleDigitSubtractionWithoutBorrow:
    case ConceptType.doubleDigitSubtractionWithBorrow:
    case ConceptType.tripleDigitSubtractionWithoutBorrow:
    case ConceptType.tripleDigitSubtractionWithBorrow:
    case ConceptType.singleDigitMultiplication:
    case ConceptType.singleDigitWithDoubleDigitMultiplication:
    case ConceptType.doubleDigitMultiplication:
    case ConceptType.tables1:
    case ConceptType.tables2:
    case ConceptType.tables3:
    case ConceptType.tables4:
    case ConceptType.tables5:
    case ConceptType.tables6:
    case ConceptType.tables7:
    case ConceptType.tables8:
    case ConceptType.tables9:
    case ConceptType.tables10:
    case ConceptType.number1:
    case ConceptType.number2:
    case ConceptType.number3:
    case ConceptType.number4:
    case ConceptType.number5:
    case ConceptType.number6:
    case ConceptType.number7:
    case ConceptType.number8:
    case ConceptType.number9:
    case ConceptType.number10:
    case ConceptType.numbers0to9:
    case ConceptType.numbers0to99:
  }
  switch (gameType) {
    case GameType.BasicCountingGame:
      break;
    case GameType.BingoGame:
      final data = await _fetchPairData(lesson.id, 9);
      final List<DisplayItem> answers = [];
      final List<DisplayItem> choices = [];
      data.forEach((k, v) {
        answers.add(DisplayItem((b) => b
          ..item = k.name
          ..displayType = subjectType
          ..image = k.image
          ..audio = k.sound));
        choices.add(DisplayItem((b) => b
          ..item = v.name
          ..displayType = subjectType
          ..image = v.image
          ..audio = v.sound));
      });
      return MultiData((b) => b
        ..gameId = bingoGame
        ..answers.addAll(answers)
        ..choices.addAll(choices));
      break;
    case GameType.BoxMatchingGame:
      final data = await _fetchPairData(lesson.id, 4);
      final List<DisplayItem> answers = [];
      final List<DisplayItem> choices = [];
      data.forEach((k, v) {
        answers.add(DisplayItem((b) => b
          ..item = k.name
          ..displayType = subjectType
          ..image = k.image
          ..audio = k.sound));
        choices.add(DisplayItem((b) => b
          ..item = v.name
          ..displayType = subjectType
          ..image = v.image
          ..audio = v.sound));
      });
      return MultiData((b) => b
        ..gameId = boxMatchingGame
        ..answers.addAll(answers)
        ..choices.addAll(choices));
      break;
    case GameType.CompareNumberGame:
      break;
    case GameType.CountingGame:
      break;
    case GameType.CrosswordGame:
      break;
    case GameType.DiceGame:
      break;
    case GameType.FillInTheBlanksGame:
      break;
    case GameType.FindWordGame:
      break;
    case GameType.FingerGame:
      break;
    case GameType.GuessImageGame:
      break;
    case GameType.JumbledWordsGame:
      final data = await _fetchMultipleChoiceData(lesson.id, 3);
      return MultiData((b) => b
        ..gameId = jumbledWordsGame
        ..answers.add(DisplayItem((b) => b
          ..item = data.item1.name
          ..displayType = subjectType
          ..image = data.item1.image
          ..audio = data.item1.sound))
        ..choices.update((b) => b
          ..addAll(data.item3.map((u) => DisplayItem((b) => b
            ..item = u.name
            ..displayType = objectType
            ..image = u.image
            ..audio = u.sound)))
          ..add(DisplayItem((b) => b
            ..item = data.item2.name
            ..displayType = objectType
            ..image = data.item2.image
            ..audio = data.item2.sound))
          ..shuffle()));
      break;
    case GameType.MadSentenceGame:
      break;
    case GameType.MatchTheShapeGame:
      final data = await _fetchPairData(lesson.id, 4);
      final List<DisplayItem> answers = [];
      final List<DisplayItem> choices = [];
      data.forEach((k, v) {
        answers.add(DisplayItem((b) => b
          ..item = k.name
          ..displayType = subjectType
          ..image = k.image
          ..audio = k.sound));
        choices.add(DisplayItem((b) => b
          ..item = v.name
          ..displayType = subjectType
          ..image = v.image
          ..audio = v.sound));
      });
      return MultiData((b) => b
        ..gameId = matchTheShapeGame
        ..answers.addAll(answers)
        ..choices.addAll(choices));
      break;
    case GameType.MatchWithImageGame:
      break;
    case GameType.MathOpGame:
      break;
    case GameType.MemoryGame:
      final data = await _fetchPairData(lesson.id, 8);
      final List<DisplayItem> answers = [];
      final List<DisplayItem> choices = [];
      data.forEach((k, v) {
        answers.add(DisplayItem((b) => b
          ..item = k.name
          ..displayType = subjectType
          ..image = k.image
          ..audio = k.sound));
        choices.add(DisplayItem((b) => b
          ..item = v.name
          ..displayType = subjectType
          ..image = v.image
          ..audio = v.sound));
      });
      return MultiData((b) => b
        ..gameId = memoryGame
        ..answers.addAll(answers)
        ..choices.addAll(choices));
      break;
    case GameType.MultipleChoiceGame:
      final data = await _fetchMultipleChoiceData(lesson.id, 3);
      return MultiData((b) => b
        ..gameId = multipleChoiceGame
        ..question.update(((b) => b
          ..item = data.item1.name
          ..displayType = subjectType
          ..image = data.item1.image
          ..audio = data.item1.sound))
        ..answers.add(DisplayItem((b) => b
          ..item = data.item1.name
          ..displayType = subjectType
          ..image = data.item1.image
          ..audio = data.item1.sound))
        ..choices.update((b) => b
          ..addAll(data.item3.map((u) => DisplayItem((b) => b
            ..item = u.name
            ..displayType = objectType
            ..image = u.image
            ..audio = u.sound)))
          ..add(DisplayItem((b) => b
            ..item = data.item2.name
            ..displayType = objectType
            ..image = data.item2.image
            ..audio = data.item2.sound))
          ..shuffle()));

      break;
    case GameType.NumberBalanceGame:
      break;
    case GameType.OrderBySizeGame:
      break;
    case GameType.OrderItGame:
      break;
    case GameType.RecognizeNumberGame:
      break;
    case GameType.ReflexGame:
      break;
    case GameType.RhymeWordsGame:
      break;
    case GameType.RulerGame:
      break;
    case GameType.SequenceAlphabetGame:
      break;
    case GameType.SequenceTheNumberGame:
      break;
    case GameType.SpinWheelGame:
      final data = await _fetchPairData(lesson.id, 8);
      final List<DisplayItem> answers = [];
      final List<DisplayItem> choices = [];
      data.forEach((k, v) {
        answers.add(DisplayItem((b) => b
          ..item = k.name
          ..displayType = subjectType
          ..image = k.image
          ..audio = k.sound));
        choices.add(DisplayItem((b) => b
          ..item = v.name
          ..displayType = subjectType
          ..image = v.image
          ..audio = v.sound));
      });
      return MultiData((b) => b
        ..gameId = spinWheelGame
        ..answers.addAll(answers)
        ..choices.addAll(choices));
      break;
    case GameType.TapWrongGame:
      break;
    case GameType.TracingAlphabetGame:
      final data = await _fetchSequenceData(lesson.id, 4);
      return MultiData((b) => b
        ..gameId = tracingAlphabetGame
        ..answers.addAll(data.item2.map((u) => DisplayItem((b) => b
          ..item = u.name
          ..displayType = subjectType
          ..image = u.image
          ..audio = u.sound))));
      break;
    case GameType.TrueFalseGame:
      final data = await _fetchPairData(lesson.id, 2);
      final rand = Random();
      final tOrF = rand.nextBool();
      final List<DisplayItem> answers = [];
      final List<DisplayItem> choices = [];
      data.forEach((k, v) {
        answers.add(DisplayItem((b) => b
          ..item = k.name
          ..displayType = subjectType
          ..image = k.image
          ..audio = k.sound));
        choices.add(DisplayItem((b) => b
          ..item = v.name
          ..displayType = subjectType
          ..image = v.image
          ..audio = v.sound));
      });
      return MultiData((b) => b
        ..gameId = trueFalseGame
        ..question.replace(answers.first)
        ..choices.add(tOrF ? choices.first : choices.last)
        ..answers.add(DisplayItem((b) => b
          ..item = tOrF ? 'True' : 'False'
          ..displayType = DisplayTypeEnum.letter)));
      break;
    case GameType.UnitGame:
      break;
  }
}

Future<List<GameData>> fetchGameData(Lesson lesson, {int numData = 5}) async {
  if (lesson.data != null) {
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
    final gameString = await rootBundle.loadString(lesson.data);
    final json = jsonDecode(gameString);
    List<GameData> gameData = standardSerializers.deserialize(json);
    gameData..shuffle();
    return gameData.take(numData);
  } else {
    switch (lesson.conceptId ?? ConceptType.dummy) {
      case ConceptType.dummy:
        break;
      case ConceptType.upperCaseLetter:
      case ConceptType.upperCaseToLowerCase:
      case ConceptType.lowerCaseLetterToWord:
      case ConceptType.syllableToWord:
      case ConceptType.upperCaseLetterToWord:
      case ConceptType.lowerCaseLetter:
        List<GameData> returnData = [];
        List<GameType> gameTypes = conceptGames[lesson.conceptId];
        final rand = Random();
        for (int i = 0; i < numData; i++) {
          returnData.add(await fetchLiteracyGameData(
              lesson: lesson,
              gameType: gameTypes[rand.nextInt(gameTypes.length)]));
        }
        return returnData;
        break;
      case ConceptType.singleDigitAdditionWithoutCarryover:
        break;
      case ConceptType.singleDigitAdditionWithCarryover:
        break;
      case ConceptType.doubleDigitAdditionWithoutCarryover:
        break;
      case ConceptType.doubleDigitAdditionWithCarryover:
        break;
      case ConceptType.tripleDigitAdditionWithoutCarryover:
        break;
      case ConceptType.tripleDigitAdditionWithCarryover:
        break;
      case ConceptType.singleDigitSubtractionWithoutBorrow:
        break;
      case ConceptType.singleDigitSubtractionWithBorrow:
        break;
      case ConceptType.doubleDigitSubtractionWithoutBorrow:
        break;
      case ConceptType.doubleDigitSubtractionWithBorrow:
        break;
      case ConceptType.tripleDigitSubtractionWithoutBorrow:
        break;
      case ConceptType.tripleDigitSubtractionWithBorrow:
        break;
      case ConceptType.singleDigitMultiplication:
        break;
      case ConceptType.singleDigitWithDoubleDigitMultiplication:
        break;
      case ConceptType.doubleDigitMultiplication:
        break;
      case ConceptType.tables1:
        break;
      case ConceptType.tables2:
        break;
      case ConceptType.tables3:
        break;
      case ConceptType.tables4:
        break;
      case ConceptType.tables5:
        break;
      case ConceptType.tables6:
        break;
      case ConceptType.tables7:
        break;
      case ConceptType.tables8:
        break;
      case ConceptType.tables9:
        break;
      case ConceptType.tables10:
        break;
      case ConceptType.number1:
        break;
      case ConceptType.number2:
        break;
      case ConceptType.number3:
        break;
      case ConceptType.number4:
        break;
      case ConceptType.number5:
        break;
      case ConceptType.number6:
        break;
      case ConceptType.number7:
        break;
      case ConceptType.number8:
        break;
      case ConceptType.number9:
        break;
      case ConceptType.number10:
        break;
      case ConceptType.numbers0to9:
        break;
      case ConceptType.numbers0to99:
        break;
    }
  }
}

Future<List<String>> _fetchSerialData(int lessonId) async {
  var lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  return lessonUnits.map((e) => e.subjectUnitId).toList(growable: false);
}

Future<Tuple2<Unit, List<Unit>>> _fetchSequenceData(
    int lessonId, int maxData) async {
  final rand = new Random();
  final lessonUnits =
      await LessonUnitRepo().getEagerLessonUnitsByLessonId(lessonId);
  final start = rand.nextInt(max(1, lessonUnits.length - maxData));
  final sequence = lessonUnits
      .skip(start)
      .take(maxData)
      .map((e) => e.subjectUnit)
      .toList(growable: false);
  final answer = sequence[rand.nextInt(sequence.length)];
  return new Tuple2(answer, sequence);
}

Future<Tuple2<String, List<String>>> _fetchSequenceDataForCategory(
    int categoryId, int maxData) async {
  var rand = new Random();
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
  var maxNumber = 10;
  switch (category?.id) {
    case 42:
      maxNumber = 10;
      break;
    case 43:
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

Future<Map<Unit, Unit>> _fetchPairData(int lessonId, int maxData) async {
  final lessonUnits =
      await LessonUnitRepo().getEagerLessonUnitsByLessonId(lessonId);
  lessonUnits.shuffle();
  //TODO: get only unique objects and subjects
  //TODO: cut across areaId to get concept->word
  return Map<Unit, Unit>.fromIterable(
      lessonUnits.sublist(0, min(maxData, lessonUnits.length)),
      key: (e) => e.subjectUnit,
      value: (e) => e.objectUnit);
}

Future<Tuple3<String, String, bool>> _fetchTrueOrFalse(int lessonId) async {
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

Future<List<List<String>>> _fetchRollingData(
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

Future<Tuple2<String, String>> _fetchFillInTheBlanksData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.lessonId != null) {
    var lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(gameCategory.lessonId);
    var lu = lessonUnits[new Random().nextInt(lessonUnits.length)];
    return new Tuple2(lu.subjectUnitId, lu.objectUnitId);
  }
  return null;
}

Future<List<Tuple2<String, String>>> _fetchWordWithBlanksData(
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

Future<Tuple4<int, String, int, int>> _fetchMathData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
    var rand = new Random();
    switch (category?.id) {
      case 7:
        var firstNum = rand.nextInt(8) + 1;
        var secondNum = rand.nextInt(9 - firstNum) + 1;
        var sum = firstNum + secondNum;
        if (sum > 7) {
          if (rand.nextInt(2) == 1) {
            firstNum = rand.nextInt(2) + 1;
            secondNum = rand.nextInt(3) + 1;
            sum = firstNum + secondNum;
          }
        }
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 8:
        var firstNum = rand.nextInt(9) + 1;
        var sum = rand.nextInt(firstNum) + 10;
        var secondNum = sum - firstNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 9:
        var firstNum = rand.nextInt(98) + 1;
        var secondNum = rand.nextInt(99 - firstNum) + 1;
        var sum = firstNum + secondNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 10:
        //TODO: no carry over at all
        var firstNum = rand.nextInt(98) + 1;
        var sum = rand.nextInt(firstNum) + 100;
        var secondNum = sum - firstNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 11:
        var firstNum = rand.nextInt(998) + 1;
        var secondNum = rand.nextInt(999 - firstNum) + 1;
        var sum = firstNum + secondNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 12:
        var firstNum = rand.nextInt(998) + 1;
        var sum = rand.nextInt(firstNum) + 1000;
        var secondNum = sum - firstNum;
        return new Tuple4(firstNum, '+', secondNum, sum);
        break;
      case 13:
        var firstNum = rand.nextInt(8) + 2;
        var secondNum = rand.nextInt(firstNum - 1) + 1;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 15:
        var firstNumTens = rand.nextInt(9) + 1;
        var firstNumUnits = rand.nextInt(9) + 1;
        var firstNum = firstNumTens * 10 + firstNumUnits;
        var secondNumTens = rand.nextInt(firstNumTens) + 1;
        var secondNumUnits = rand.nextInt(firstNumUnits) + 1;
        var secondNum = secondNumTens * 10 + secondNumUnits;
        var sum = firstNum - secondNum;
        return new Tuple4(firstNum, '-', secondNum, sum);
        break;
      case 16:
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
      case 17:
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
      case 18:
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
      case 19:
        var firstNum = rand.nextInt(9) + 1;
        var secondNum = rand.nextInt(9) + 1;
        var product = firstNum * secondNum;
        return new Tuple4(firstNum, '*', secondNum, product);
        break;
      case 20:
        var firstNum = rand.nextInt(9) + 1;
        var secondNum = rand.nextInt(90) + 10;
        var product = firstNum * secondNum;
        return new Tuple4(firstNum, '*', secondNum, product);
        break;
      case 21:
        var firstNum = rand.nextInt(90) + 10;
        var secondNum = rand.nextInt(90) + 10;
        var product = firstNum * secondNum;
        return new Tuple4(firstNum, '*', secondNum, product);
        break;
    }
  }
  return null;
}

Future<List<Tuple4<int, String, int, int>>> _fetchTablesData(
    int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var number = gameCategory.conceptId - 21; //22 is for 1 mult table
    var table = <Tuple4<int, String, int, int>>[];
    for (var i = 1; i <= 10; i++) {
      table.add(new Tuple4(number, 'X', i, number * i));
    }
    return table;
  }
  return null;
}

Future<List<List<int>>> _fetchFillNumberData(int categoryId, int size) async {
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
    _fetchCrosswordData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
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
  return null;
}

Future<Tuple2<List<String>, String>> _fetchCirclewrdData(int categoryId) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);

  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);

    var rand = new Random();
    var startNum = rand.nextInt(max(0, 3));
    switch (startNum) {
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
        ], 'catseings');
        break;
      case 1:
        return new Tuple2([
          'puces',
          'ceps',
          'cups',
          'cusp',
          'pecs',
          'puce',
          'scup',
          'spec',
          'cep',
          'cup',
          'pec',
          'cues',
          'ecus',
          'spue',
          'supe',
          'cue',
          'ecu',
          'pes',
          'pus',
          'esc',
          'sup',
          'ups',
          'pe',
          'up',
          'sue',
          'use',
          'us'
        ], 'upsce');
        break;

      case 2:
        return new Tuple2([
          'ashet',
          'haets',
          'haste',
          'hates',
          'heats',
          'eath',
          'eths',
          'haes',
          'haet',
          'hast',
          'hate',
          'hats',
          'heat',
          'hest',
          'hets',
          'shat',
          'shea',
          'shet',
          'tash',
          'thae',
          'ahs',
          'ash',
          'eth',
          'hae',
          'has',
          'hat',
          'hes',
          'het',
          'sha',
          'she',
          'the',
          'he',
          'ates',
          'east',
          'eats',
          'etas',
          'sate',
          'seat',
          'taes',
          'tase',
          'teas',
          'ate',
          'ats',
          'eas',
          'eat',
          'est',
          'sae',
          'sat',
          'sea',
          'set',
          'tae',
          'tas',
          'tea',
          'tes',
          'as',
          'at',
          'st',
          'te'
        ], 'hates');
        break;
    }
    return null;
  }
}

Future<Tuple3<Unit, Unit, List<Unit>>> _fetchMultipleChoiceData(
    int lessonId, int maxChoices) async {
  final lessonUnits =
      await LessonUnitRepo().getEagerLessonUnitsByLessonId(lessonId);
  lessonUnits.shuffle();
  Unit question;
  Unit answer;
  List<Unit> choices;
  question = lessonUnits[0].subjectUnit;
  answer = lessonUnits[0].objectUnit;
  choices = lessonUnits
      .where((l) => l.subjectUnit != question)
      .take(maxChoices)
      .map((l) => l.objectUnit)
      .toList(growable: false);
  return new Tuple3(question, answer, choices);
}

Future<Tuple2<List<String>, List<String>>> _fetchWordData(
    int lessonId, int maxLength, int otherLength) async {
  List<LessonUnit> lessonUnits =
      await new LessonUnitRepo().getLessonUnitsByLessonId(lessonId);
  Lesson lesson = await new LessonRepo().getLesson(lessonId);
  lessonUnits.shuffle();
  List<String> words;
  List<String> wordLetters;
  if (lesson.conceptId == ConceptType.lowerCaseLetterToWord ||
      lesson.conceptId == ConceptType.upperCaseLetterToWord) {
    words = lessonUnits.map((l) => l.objectUnitId).toList(growable: false);
  } else {
    words = lessonUnits.map((l) => l.subjectUnitId).toList(growable: false);
  }
  String word = words.firstWhere((w) => w.length <= maxLength);

  if (lesson.conceptId == ConceptType.upperCaseLetter ||
      lesson.conceptId == ConceptType.upperCaseToLowerCase ||
      lesson.conceptId == ConceptType.lowerCaseLetter) {
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

Future<Tuple2<List<String>, List<String>>> _fetchConsecutiveData(
    int categoryId, int maxLength, int otherLength) async {
  var gameCategory = await new GameCategoryRepo().getGameCategory(categoryId);
  if (gameCategory.conceptId != null) {
    var category = await new ConceptRepo().getConcept(gameCategory.conceptId);
    var rand = new Random();
    switch (category?.id) {
      case 42:
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
      case 43:
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

Future<Tuple2<List<String>, String>> _fetchFirstWordData(int categoryId) async {
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

Future<String> _fetchData() async {
  List<String> gameViews = [
    "Colors",
    "Flowers",
    "HouseItems",
    "Birds",
    "Animals",
    "Body",
    "Scene",
    "Shapes",
    "Clothes",
    "Fruits"
  ];
  gameViews.shuffle();
  String s = gameViews[0];
  return await rootBundle.loadString("assets/$s.json");
}

Future<Map<String, Map<String, List<String>>>> _fetchClueGame(
    int categoryId) async {
  var completer = Completer<Map<String, Map<String, List<String>>>>();
  Map<String, List<String>> drink = {
    'milk': ['mi', 'lk'],
    'coffee': ['cof', 'fee'],
    'juice': ['jui', 'ce'],
  };
  Map<String, List<String>> travel = {
    'cycle': ['cyc', 'le'],
    'train': ['tr', 'ain'],
    'aeroplane': ['aero', 'plane'],
  };
  Map<String, List<String>> redfruit = {
    'apple': ['ap', 'ple'],
    'cherry': ['che', 'rry'],
    'tomato': ['tom', 'ato'],
  };
  Map<String, List<String>> blackpet = {
    'dog': ['do', 'g'],
    'panda': ['pa', 'nda'],
    'crow': ['cr', 'ow'],
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

Future<Tuple2<String, List<String>>> _fetchPictureSentenceData(
    int categoryId) async {
  var rand = new Random();
  var startNum = rand.nextInt(max(0, 8));
  switch (startNum) {
    case 0:
      return new Tuple2("Mount Everest is the highest 1_ in the 2_ .",
          ['mountain', 'earth', 'chair', 'ball']);
      break;
    case 1:
      return new Tuple2("Nile is the longest 1_ on  2_ .",
          ['river', 'earth', 'wall', 'waterfall']);
      break;
    case 2:
      return new Tuple2("Apple is 1_ and also 2_ in colour .",
          ['red', 'green', 'round', 'tube']);
      break;
    case 3:
      return new Tuple2(
          "1_ gives healthy 2_ .", ['cow', 'milk', 'vegetable', 'grass']);
      break;
    case 4:
      return new Tuple2("Fastest 1_ animal is 2_ .",
          ['running', 'cheetah', 'growing', 'monkey']);
      break;
    case 5:
      return new Tuple2(
          "I love eating 1_ and 2_ .", ['mango', 'grape', 'sun', 'moon']);
      break;
    case 6:
      return new Tuple2("Snowy is 1_ but I am trying to make her 2_ .",
          ['crying', 'laugh', 'crawling', 'chair']);
      break;
    case 7:
      return new Tuple2("1_ is a beautiful 2_ colour flower .",
          ['rose', 'red', 'ugly', 'black']);
      break;
  }
  return null;
}

Future<Tuple2<String, List<String>>> _fetchDrawingData(int categoryId) async {
  var rand = new Random();
  var startNum = rand.nextInt(max(0, 8));
  switch (startNum) {
    case 0:
      return new Tuple2("fruits name", ['banana', 'apple', 'grape', 'ball']);
      break;
    case 1:
      return new Tuple2("nature", ['bat', 'grape', 'rat', 'cat']);
      break;
    case 2:
      return new Tuple2("Colors", ['book', 'chair', 'table', 'pen']);
      break;
    case 3:
      return new Tuple2("animals .", ['milk', 'cow', 'snake', 'grass']);
      break;
    case 4:
      return new Tuple2("vegitables", ['onion', 'carrot', 'tomoto', 'chilli']);
      break;
    case 5:
      return new Tuple2("wild animals", ['lion', 'tiger', 'cheetah', 'monkey']);
      break;
    case 6:
      return new Tuple2("vehicles", ['bus', 'car', 'bike', 'train']);
      break;
    case 7:
      return new Tuple2("flowers", ['rose', 'television', 'home', 'jasmin']);
      break;
  }
  return null;
}
