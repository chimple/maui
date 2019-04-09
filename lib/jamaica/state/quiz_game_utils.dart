import 'dart:convert';
import 'package:built_value/standard_json_plugin.dart';
import 'package:data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/jamaica/state/state_container.dart';

sendQuizPerformance(
    {GameData gameData,
    int score,
    DateTime startTime,
    DateTime endTime,
    BuildContext context}) {
  final quizSession = StateContainer.of(context).quizSession;
  switch (gameData.gameId) {
    case 'BasicCountingGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);

      break;
    case 'BingoGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'BoxMatchingGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'CountingGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'CrosswordGame':
      final gd = gameData as CrosswordData;

      break;
    case 'DiceGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'FindWordGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'FingerGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'JumbledWordsGame':
      final gd = gameData as MultiData;

      return sendPerformance(quizSession, gd.answers.toString(), score,
          startTime, endTime, context);
      break;
    case 'MatchTheShapeGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'MatchWithImageGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'MathOpGame':
      final gd = gameData as MathOpData;

      //  return sendPerformnce(contestSession, gd.answers[0].toString(), score,
      //     startTime, endTime, context);
      break;
    case 'MemoryGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'OrderBySizeGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'RecognizeNumberGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'RhymeWordsGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'SequenceAlphabetGame':
      final gd = gameData as MultiData;

      return sendPerformance(
          quizSession, gd.answers[0], score, startTime, endTime, context);
      break;
    case 'SequenceTheNumberGame':
      final gd = gameData as NumMultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'TrueFalseGame':
      final gd = gameData as MultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
    case 'JumbleWordsGame':
      final gd = gameData as MultiData;

      return sendPerformance(quizSession, gd.answers[0].toString(), score,
          startTime, endTime, context);
      break;
  }
}

sendPerformance(QuizSession quizSession, String string, int score,
    DateTime startTime, DateTime endTime, BuildContext context) {
  final standardSerializers =
      (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
  bool correct = score != 0 ? true : false;
  final studentId = StateContainer.of(context).studentIdVal;
  final val = StateContainer.of(context).overView;
  if (val.isNotEmpty) {
    val.forEach((e) {
      if (studentId == e.studentId) {
        if (score <= e.score) {
          correct = false;
        } else {
          correct = true;
        }
      }
    });
  }
  var timeStart = new DateTime.utc(
      startTime.year,
      startTime.month,
      startTime.day,
      startTime.day,
      startTime.hour,
      startTime.minute,
      startTime.second,
      startTime.millisecond);
  var timeEnd = new DateTime.utc(
      endTime.year,
      endTime.month,
      endTime.day,
      endTime.day,
      endTime.hour,
      endTime.minute,
      endTime.second,
      endTime.millisecond);

  Performance performance = Performance((p) => p
    ..studentId = studentId
    ..gameId = quizSession.gameId
    ..sessionId = quizSession.sessionId
    ..level = quizSession.level
    ..question = "question we have to send"
    ..answer = string
    ..correct = correct
    ..score = score
    ..startTime = timeStart
    ..endTime = timeEnd);

  StateContainer.of(context).addPerformanceData(performance);
  final json = standardSerializers.serialize(performance);
  final jsonString = jsonEncode(json);
  final endPointId = StateContainer.of(context).quizSessionEndPointId;
  StateContainer.of(context).sendMessageTo(endPointId, jsonString);
}
