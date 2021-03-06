import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/games/basic_counting_game.dart';
import 'package:maui/games/bingo_game.dart';
import 'package:maui/games/box_matching_game.dart';
import 'package:maui/games/counting_game.dart';
import 'package:maui/games/crossword_game.dart';
import 'package:maui/games/dice_game.dart';
import 'package:maui/games/fill_in_the_blanks_game.dart';
import 'package:maui/games/find_word_game.dart';
import 'package:maui/games/finger_game.dart';
import 'package:maui/games/guess_image.dart';
import 'package:maui/games/jumbled_words_game.dart';
import 'package:maui/games/match_the_shape_game.dart';
import 'package:maui/games/match_with_image_game.dart';
import 'package:maui/games/math_op_game.dart';
import 'package:maui/games/memory_game.dart';
import 'package:maui/games/moving_text_game.dart';
import 'package:maui/games/order_by_size_game.dart';
import 'package:maui/games/recognize_number_game.dart';
import 'package:maui/games/rhyme_words_game.dart';
import 'package:maui/games/sequence_alphabet_game.dart';
import 'package:maui/games/sequence_the_number_game.dart';
import 'package:maui/games/spin_wheel_game.dart';
import 'package:maui/games/tracing_alphabet_game.dart';
import 'package:maui/games/true_false_game.dart';
import 'package:maui/models/crossword_data.dart';
import 'package:maui/models/game_data.dart';
import 'package:maui/models/image_label_data.dart';
import 'package:maui/models/math_op_data.dart';
import 'package:maui/models/multi_data.dart';
import 'package:maui/models/num_multi_data.dart';
import 'package:maui/games/multiple_choice_game.dart';
import 'package:maui/repos/game_data_repo.dart';

typedef void OnGameUpdate({int score, int max, bool gameOver, bool star});

Widget buildGame({GameData gameData, OnGameUpdate onGameUpdate}) {
  print('gameData: $gameData');
  switch (gameData.gameId) {
    case basicCountingGame:
      final gd = gameData as NumMultiData;
      return BasicCountingGame(
        answer: gd.answers[0],
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case bingoGame:
      final gd = gameData as MultiData;
      return BingoGame(
        choices: Map.fromIterables(gd.choices, gd.answers),
        onGameUpdate: onGameUpdate,
      );
      break;
    case boxMatchingGame:
      final gd = gameData as MultiData;
      return BoxMatchingGame(
        choices: gd.choices,
        answers: gd.answers,
        onGameUpdate: onGameUpdate,
      );
      break;
    case countingGame:
      final gd = gameData as NumMultiData;
      return CountingGame(
        answer: gd.answers[0],
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case crosswordGame:
      final gd = gameData as CrosswordData;
      return CrosswordGame(
        data: gd.data,
        images: gd.images,
        onGameUpdate: onGameUpdate,
      );
      break;
    case diceGame:
      final gd = gameData as NumMultiData;
      return DiceGame(
        // question: gd.answers[0],
        // answerPosition: gd.choices.indexOf(gd.answers[0]),
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
    case fillInTheBlanksGame:
      final gd = gameData as MultiData;
      return FillInTheBlanksGame(
        question: gd.question.item,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case findWordGame:
      final gd = gameData as MultiData;
      return FindWordGame(
        image: gd.question.image,
        answer: gd.answers,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case fingerGame:
      final gd = gameData as NumMultiData;
      return FingerGame(
        answer: gd.answers.first,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case jumbledWordsGame:
      final gd = gameData as MultiData;
      return JumbledWordsGame(
        answer: gd.answers.first,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case matchTheShapeGame:
      final gd = gameData as MultiData;
      return MatchTheShapeGame(
        first: gd.choices,
        second: gd.answers,
        onGameUpdate: onGameUpdate,
      );
      break;
    case matchWithImageGame:
      final gd = gameData as MultiData;
      return MatchWithImageGame(
        answers: gd.answers,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case mathOpGame:
      final gd = gameData as MathOpData;
      return MathOpGame(
        first: gd.first,
        second: gd.second,
        op: gd.op,
        answer: gd.answer,
        onGameUpdate: onGameUpdate,
      );
      break;
    case memoryGame:
      final gd = gameData as MultiData;
      return MemoryGame(
        first: gd.choices,
        second: gd.answers,
        onGameUpdate: onGameUpdate,
      );
      break;
    case orderBySizeGame:
      final gd = gameData as NumMultiData;
      return OrderBySizeGame(
        answers: gd.answers,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case recognizeNumberGame:
      final gd = gameData as NumMultiData;
      return RecognizeNumberGame(
        answer: gd.answers.first,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
    case rhymeWordsGame:
      final gd = gameData as MultiData;
      return RhymeWordsGame(
        questions: gd.choices,
        answers: gd.answers,
        onGameUpdate: onGameUpdate,
      );
      break;
    case sequenceAlphabetGame:
      final gd = gameData as MultiData;
      return SequenceAlphabetGame(
        answers: gd.answers,
        onGameUpdate: onGameUpdate,
      );
      break;
    case sequenceTheNumberGame:
      final gd = gameData as NumMultiData;
      return SequenceTheNumberGame(
        sequence: gd.answers,
        choices: gd.choices,
        blankPosition: gd.specials.first,
        onGameUpdate: onGameUpdate,
      );
      break;
    case spinWheelGame:
      final gd = gameData as MultiData;
      return SpinWheelGame(
        data: Map.fromIterables(
            gd.choices.map((d) => d.item), gd.answers.map((d) => d.item)),
        onGameUpdate: onGameUpdate,
        dataSize: gd.choices.length,
      );
      break;
    case tracingAlphabetGame:
      final gd = gameData as MultiData;
      return TracingAlphabetGame(
        alphabets: BuiltList<String>(gd.answers.map((d) => d.item)),
        onGameUpdate: onGameUpdate,
      );
      break;
    case trueFalseGame:
      final gd = gameData as MultiData;
      return TrueFalseGame(
        question: gd.question,
        answer: gd.choices.first,
        right_or_wrong: gd.answers.first.item == 'True',
        onGameUpdate: onGameUpdate,
      );
      break;
    case guessImageGame:
      final gd = gameData as ImageLabelData;
      return GuessImage(
        onGameUpdate: onGameUpdate,
        imageItemDetails: gd.imageItemDetails,
        imageName: gd.imageName,
      );
      break;
    case multipleChoiceGame:
      final gd = gameData as MultiData;
      return MultipleChoiceGame(
        question: gd.question,
        answers: gd.answers,
        choices: gd.choices,
        onGameUpdate: onGameUpdate,
      );
      break;
  }
  return Container();
}
