import 'package:built_collection/built_collection.dart';
import 'package:maui/models/crossword_data.dart';
import 'package:maui/models/math_op_data.dart';
import 'package:maui/models/multi_data.dart';
import 'package:maui/models/num_multi_data.dart';
import 'package:maui/models/quiz_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/widgets/game.dart';
import 'package:storyboard/storyboard.dart';

class GameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Game(
          updateCoins: (coins) => print(coins),
          quizSession: QuizSession((b) => b
            ..title = 'SequenceAlphabetGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'SequenceAlphabetGame'
                ..answers.addAll(['A', 'P', 'P', 'L', 'E'])),
            ])
            ..title = 'SequenceTheNumberGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'SequenceTheNumberGame'
                ..specials.addAll([2])
                ..choices.addAll([3, 5, 6])
                ..answers.addAll([1, 2, 3, 4])),
            ])
            ..title = 'RhymeWordsGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'RhymeWordsGame'
                ..choices.addAll([
                  'Pin',
                  'Pet',
                  'Me',
                  'Bee',
                ])
                ..answers.addAll([
                  'Win',
                  'Wet',
                  'We',
                  'See',
                ])),
            ])
            ..title = 'TrueFalseGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'TrueFalseGame'
                ..choices.addAll(["pin"])
                ..question = 'win'
                ..answers.add("True")),
            ])
            ..title = 'RecognizeNumberGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'RecognizeNumberGame'
                ..answers.addAll([1])
                ..choices.addAll([2, 1, 4, 3])),
            ])
            ..title = 'OrderBySizeGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'OrderBySizeGame'
                ..answers.addAll([1, 7])
                ..choices.addAll([2, 7, 3, 1])),
            ])
            ..title = 'MathOpGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MathOpData((g) => g
                ..gameId = 'MathOpGame'
                ..first = 3
                ..second = 5
                ..op = '+'
                ..answer = 8),
            ])
            ..title = 'MatchTheShapeGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'MatchTheShapeGame'
                ..answers.addAll(['A', 'B', 'C', 'D'])
                ..choices.addAll(['A', 'B', 'C', 'D'])),
            ])
            ..title = 'MatchWithImageGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'MatchWithImageGame'
                ..specials.addAll([
                  'assets/accessories/apple.png',
                  'assets/accessories/camera.png',
                  'assets/accessories/fruit.png'
                ])
                ..answers.addAll([
                  'Apple',
                  'Camera',
                  'Fruit',
                ])
                ..choices.addAll([
                  'Apple',
                  'Camera',
                  'Fruit',
                ])),
            ])
            ..title = 'BingoGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'BingoGame'
                ..answers.addAll(['A', 'B', 'C', 'D'])
                ..choices.addAll(['A', 'B', 'C', 'D'])),
            ])
            ..title = 'JumbledWordsGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'JumbledWordsGame'
                ..answers.add('A')
                ..choices.addAll(['A', 'B', 'C', 'D', 'E', 'F', 'H'])),
            ])
            ..title = 'JumbledWordsGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'JumbledWordsGame'
                ..answers.add('A')
                ..choices.addAll(['A', 'B', 'C', 'D'])),
            ])
            ..title = 'FingerGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'FingerGame'
                ..answers.add(3)
                ..choices.addAll([2, 3])),
            ])
            ..title = 'FingerGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'FingerGame'
                ..answers.add(7)
                ..choices.addAll([6, 7, 8])),
            ])
            ..title = 'FindWordGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'FindWordGame'
                ..specials.add('assets/accessories/apple.png')
                ..answers.addAll(['A', 'P', 'P', 'L', 'E'])
                ..choices.addAll(['A', 'X', 'Y', 'P', 'E', 'B', 'L', 'W'])),
            ])
            ..title = 'DiceGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'DiceGame'
                ..answers.add(4)
                ..choices.addAll([1, 4, 5, 8])),
            ])
            ..title = 'FillInTheBlanksGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'FillInTheBlanksGame'
                ..question = ' Mount Everest is the highest 1_ in the 2_ .'
                ..choices.addAll(['mountain', 'earth', 'chair', 'ball'])),
            ])
            ..title = 'FillInTheBlanksGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'FillInTheBlanksGame'
                ..question =
                    ' The fact is Mount Everest is the highest 1_ in the earth followed by K2,located in the Himalayas.'
                ..choices.addAll(['mountain', 'earth', 'chair', 'ball'])),
            ])
            ..title = 'FillInTheBlanksGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'FillInTheBlanksGame'
                ..question = 'Lion is the king of the 1_ .'
                ..choices.addAll(['jungle', 'earth', 'chair', 'ball'])),
            ])
            ..title = 'BoxMatchingGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'BoxMatchingGame'
                ..answers.addAll(['A', 'B', 'C', 'D'])
                ..choices.addAll(
                    ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B'])),
            ])
            ..title = 'CrosswordGame'
            ..sessionId = '3'
            ..gameData.addAll([
              CrosswordData((g) => g
                ..gameId = 'CrosswordGame'
                ..data.addAll(([
                  BuiltList<String>(['E', '', '', '', '']),
                  BuiltList<String>(['A', '', '', '', '']),
                  BuiltList<String>(['T', 'I', 'G', 'E', 'R']),
                  BuiltList<String>(['', '', '', '', 'A']),
                  BuiltList<String>(['', '', '', '', 'T'])
                ]))
                ..images.addAll(([
                  ImageData((b) => b
                    ..image = 'assets/accessories/apple.png'
                    ..x = 0
                    ..y = 0),
                  ImageData((b) => b
                    ..image = 'assets/accessories/camera.png'
                    ..x = 2
                    ..y = 0),
                  ImageData((b) => b
                    ..image = 'assets/accessories/fruit.png'
                    ..x = 2
                    ..y = 4),
                ]))),
              CrosswordData((g) => g
                ..gameId = 'CrosswordGame'
                ..data.addAll(([
                  BuiltList<String>(['T', 'E', 'X', 'T']),
                  BuiltList<String>(['', '', 'M', '']),
                  BuiltList<String>(['J', 'O', 'I', 'N']),
                  BuiltList<String>(['', '', 'C', '']),
                ]))
                ..images.addAll(([
                  ImageData((b) => b
                    ..image = 'assets/accessories/join.png'
                    ..x = 2
                    ..y = 0),
                  ImageData((b) => b
                    ..image = 'assets/accessories/text.png'
                    ..x = 0
                    ..y = 0),
                  ImageData((b) => b
                    ..image = 'assets/accessories/mic.png'
                    ..x = 1
                    ..y = 2),
                ]))),
              CrosswordData((g) => g
                ..gameId = 'CrosswordGame'
                ..data.addAll(([
                  BuiltList<String>(['', 'A', '', 'T', '', 'G']),
                  BuiltList<String>(['M', 'P', '', 'E', '', 'R']),
                  BuiltList<String>(['I', 'P', '', 'X', '', 'A']),
                  BuiltList<String>(['C', 'L', 'O', 'T', 'H', 'I']),
                  BuiltList<String>(['', 'E', 'J', 'O', 'I', 'N']),
                  BuiltList<String>(['', '', '', '', '', 'S']),
                ]))
                ..images.addAll(([
                  ImageData((b) => b
                    ..image = 'assets/accessories/apple.png'
                    ..x = 0
                    ..y = 1),
                  ImageData((b) => b
                    ..image = 'assets/accessories/text.png'
                    ..x = 0
                    ..y = 3),
                  ImageData((b) => b
                    ..image = 'assets/accessories/grains.png'
                    ..x = 0
                    ..y = 5),
                  ImageData((b) => b
                    ..image = 'assets/accessories/clothes.png'
                    ..x = 3
                    ..y = 0),
                  ImageData((b) => b
                    ..image = 'assets/accessories/mic.png'
                    ..x = 1
                    ..y = 0),
                  ImageData((b) => b
                    ..image = 'assets/accessories/join.png'
                    ..x = 4
                    ..y = 2),
                ]))),
            ])
            ..title = 'CountingGame'
            ..sessionId = '2'
            ..gameData.addAll([
              NumMultiData((g) => g
                ..gameId = 'CountingGame'
                ..answers.addAll([5])
                ..choices.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])),
              NumMultiData((g) => g
                ..gameId = 'CountingGame'
                ..answers.addAll([3])
                ..choices.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])),
              NumMultiData((g) => g
                ..gameId = 'CountingGame'
                ..answers.addAll([8])
                ..choices.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9])),
            ])
            ..title = 'MovingTextGame'
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'MovingTextGame'
                ..choices.addAll(['He', 'Like', 'to', 'tease', 'people'])
                ..answers.addAll(['He', 'Like', 'to', 'tease', 'people'])),
            ])
            ..title = "MultipleChoiceGame"
            ..sessionId = '2'
            ..gameData.addAll([
              MultiData((g) => g
                ..gameId = 'MultipleChoiceGame'
                ..question = 'The largest land animal is _________________?'
                ..answers.addAll([
                  'African Bush Elephant',
                ])
                ..choices.addAll(['Lion', 'Whale', 'Panther']))
            ])),
        ),
      ];
}
