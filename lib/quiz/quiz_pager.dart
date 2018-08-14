import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/quiz_repo.dart';
import 'package:maui/db/entity/quiz.dart';
import 'match_the_following.dart';
import 'multiple_choice.dart';
import 'grouping_quiz.dart';
import 'true_or_false.dart';

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
}

class QuizPagerState extends State<QuizPager> with TickerProviderStateMixin {
  List<Quiz> _quizzes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    widget.gameConfig.topicId = 'lion'; //TODO: Link to topic
    _quizzes = await QuizRepo().getQuizzesByTopicId(widget.gameConfig.topicId);
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
    Quiz quiz = _quizzes[widget.iteration % _quizzes.length];
    try {
      Map<String, dynamic> data = json.decode(quiz.content);
    } catch (e) {
      print(e);
    }
    switch (quiz.quizType) {
      case QuizType.multipleChoice:
        return Multiplechoice(onEnd: widget.onEnd);
        break;
      case QuizType.matchTheFollowing:
        return MatchingGame(
          onEnd: widget.onEnd,
        );
        break;
      case QuizType.trueOrFalse:
        return TrueOrFalse(
          onEnd: widget.onEnd,
        );
        break;
      case QuizType.grouping:
        return GroupingQuiz(onEnd: widget.onEnd);
        break;
    }
  }
}
