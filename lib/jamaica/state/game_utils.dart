import 'package:flutter/widgets.dart';
import 'package:maui/jamaica/games/basic_counting_game.dart';
import 'package:maui/jamaica/games/bingo_game.dart';
import 'package:maui/jamaica/games/box_matching_game.dart';
import 'package:maui/jamaica/games/counting_game.dart';
import 'package:maui/jamaica/games/crossword_game.dart';
import 'package:maui/jamaica/games/dice_game.dart';
import 'package:maui/jamaica/games/fill_in_the_blanks_game.dart';
import 'package:maui/jamaica/games/find_word_game.dart';
import 'package:maui/jamaica/games/finger_game.dart';
import 'package:maui/jamaica/games/jumbled_words_game.dart';
import 'package:maui/jamaica/games/match_the_shape_game.dart';
import 'package:maui/jamaica/games/match_with_image_game.dart';
import 'package:maui/jamaica/games/math_op_game.dart';
import 'package:maui/jamaica/games/memory_game.dart';
import 'package:maui/jamaica/games/order_by_size_game.dart';
import 'package:maui/jamaica/games/recognize_number_game.dart';
import 'package:maui/jamaica/games/rhyme_words_game.dart';
import 'package:maui/jamaica/games/sequence_alphabet_game.dart';
import 'package:maui/jamaica/games/sequence_the_number_game.dart';
import 'package:maui/jamaica/games/true_false_game.dart';
import 'package:maui/jamaica/widgets/story/activity/jumble_words.dart';
import 'package:maui/models/crossword_data.dart';
import 'package:maui/models/game_data.dart';
import 'package:maui/models/math_op_data.dart';
import 'package:maui/models/multi_data.dart';
import 'package:maui/models/num_multi_data.dart';

typedef void OnGameOver(int score);

Widget buildGame({GameData gameData, OnGameOver onGameOver}) {
  switch (gameData.gameId) {
    case 'BasicCountingGame':
      final gd = gameData as NumMultiData;
      return BasicCountingGame(
        answer: gd.answers[0],
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'BingoGame':
      final gd = gameData as MultiData;
      return BingoGame(
        choices: Map.fromIterables(gd.choices, gd.answers),
        onGameOver: onGameOver,
      );
      break;
    case 'BoxMatchingGame':
      final gd = gameData as MultiData;
      return BoxMatchingGame(
        choices: gd.choices,
        answers: gd.answers,
        onGameOver: onGameOver,
      );
      break;
    case 'CountingGame':
      final gd = gameData as NumMultiData;
      return CountingGame(
        answer: gd.answers[0],
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'CrosswordGame':
      final gd = gameData as CrosswordData;
      return CrosswordGame(
        data: gd.data,
        images: gd.images,
        onGameOver: onGameOver,
      );
      break;
    case 'DiceGame':
      final gd = gameData as NumMultiData;
      return DiceGame(
        question: gd.answers[0],
        answerPosition: gd.choices.indexOf(gd.answers[0]),
        choices: gd.choices,
        onGameOver: onGameOver,
      );
    case 'FillInTheBlanksGame':
      final gd = gameData as MultiData;
      return FillInTheBlanksGame(
        question: gd.question,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'FindWordGame':
      final gd = gameData as MultiData;
      return FindWordGame(
        image: gd.specials.first,
        answer: gd.answers,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'FingerGame':
      final gd = gameData as NumMultiData;
      return FingerGame(
        answer: gd.answers.first,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'JumbledWordsGame':
      final gd = gameData as MultiData;
      return JumbledWordsGame(
        answer: gd.answers.first,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'MatchTheShapeGame':
      final gd = gameData as MultiData;
      return MatchTheShapeGame(
        first: gd.choices,
        second: gd.answers,
        onGameOver: onGameOver,
      );
      break;
    case 'MatchWithImageGame':
      final gd = gameData as MultiData;
      return MatchWithImageGame(
        images: gd.specials,
        answers: gd.answers,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'MathOpGame':
      final gd = gameData as MathOpData;
      return MathOpGame(
        first: gd.first,
        second: gd.second,
        op: gd.op,
        answer: gd.answer,
        onGameOver: onGameOver,
      );
      break;
    case 'MemoryGame':
      final gd = gameData as MultiData;
      return MemoryGame(
        first: gd.choices,
        second: gd.answers,
        onGameOver: onGameOver,
      );
      break;
    case 'OrderBySizeGame':
      final gd = gameData as NumMultiData;
      return OrderBySizeGame(
        answers: gd.answers,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'RecognizeNumberGame':
      final gd = gameData as NumMultiData;
      return RecognizeNumberGame(
        answer: gd.answers.first,
        choices: gd.choices,
        onGameOver: onGameOver,
      );
      break;
    case 'RhymeWordsGame':
      final gd = gameData as MultiData;
      return RhymeWordsGame(
        questions: gd.choices,
        answers: gd.answers,
        onGameOver: onGameOver,
      );
      break;
    case 'SequenceAlphabetGame':
      final gd = gameData as MultiData;
      return SequenceAlphabetGame(
        answers: gd.answers,
        onGameOver: onGameOver,
      );
      break;
    case 'SequenceTheNumberGame':
      final gd = gameData as NumMultiData;
      return SequenceTheNumberGame(
        sequence: gd.answers,
        choices: gd.choices,
        blankPosition: gd.specials.first,
        onGameOver: onGameOver,
      );
      break;
    case 'TrueFalseGame':
      final gd = gameData as MultiData;
      return TrueFalseGame(
        question: gd.question,
        answer: gd.choices.first,
        right_or_wrong: gd.answers.first == 'True',
        onGameOver: onGameOver,
      );
      break;
    case 'JumbleWordsGame':
      final gd = gameData as MultiData;
      return JumbleWords(
        onGameOver: onGameOver,
        choices: gd.choices,
        answers: gd.answers,
      );
      break;
  }
  return Container();
}
