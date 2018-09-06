import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/quiz_repo.dart';
import 'package:maui/db/entity/quiz.dart';
import 'match_the_following.dart';
import 'multiple_choice.dart';
import 'grouping_quiz.dart';
import 'true_or_false.dart';
import 'sequence.dart';
import 'quiz_result.dart';

class QuizPager extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  QuizPager(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.onTurn,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new QuizPagerState();

  static Widget createQuiz(
      {Quiz quiz, Map<String, dynamic> input, Function onEnd}) {
    switch (quiz.quizType) {
      case QuizType.multipleChoice:
        return Multiplechoice(
          onEnd: onEnd,
          input: input,
        );
        break;
      case QuizType.matchTheFollowing:
        return MatchingGame(
          onEnd: onEnd,
          gameData: input,
        );
        break;
      case QuizType.trueOrFalse:
        return TrueOrFalse(
          onEnd: onEnd,
          input: input,
        );
        break;
      case QuizType.grouping:
        return GroupingQuiz(
          onEnd: onEnd,
          input: input,
        );
        break;
      case QuizType.sequence:
        return SequenceQuiz(
          onEnd: onEnd,
          input: input,
        );
        break;
    }
  }
}

class QuizPagerState extends State<QuizPager> with TickerProviderStateMixin {
  List<Quiz> _quizzes;
  List<Map<String, dynamic>> _quizInputs;
  bool _isLoading = true;
  int _currentQuiz = 0;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    widget.gameConfig.topicId = 'lion'; //TODO: Link to topic
    _quizzes = await QuizRepo().getQuizzesByTopicId(widget.gameConfig.topicId);
    _quizInputs = _quizzes.map((quiz) {
      Map<String, dynamic> data;
      try {
        data = json.decode(quiz.content);
      } catch (e) {
        print(e);
        data = {};
      }
      return data;
    }).toList(growable: false);
    print(_quizInputs);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    if (_currentQuiz < _quizzes.length) {
      Quiz quiz = _quizzes[_currentQuiz];
      final input = _quizInputs[_currentQuiz];
      print(input);
      return QuizPager.createQuiz(quiz: quiz, input: input, onEnd: _onEnd);
    }
     else {
      return IntrinsicHeight(
        child: QuizResult(
          quizInputs: _quizInputs,
          quizzes: _quizzes,
           onEnd: widget.onEnd,
           onScore:widget.onScore
        ),
      );
    }
  }

  _onEnd(Map<String, dynamic> resultData) {
    if (resultData != null) _quizInputs[_currentQuiz].addAll(resultData);
    setState(() {
      widget.onProgress(++_currentQuiz / _quizzes.length);
    });
  }
}
