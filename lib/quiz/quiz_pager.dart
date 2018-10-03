import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/components/hud.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/quiz_repo.dart';
import 'package:maui/db/entity/quiz.dart';
import 'match_the_following.dart';
import 'multiple_choice.dart';
import 'grouping_quiz.dart';
import 'quiz_scroller_pager.dart';
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
  GameMode gameMode;
  bool isRotated;

  int playTime = 10000;
  Function onGameEnd;
  QuizPager(
      {key, this.onScore, this.onProgress,this.iteration, this.onEnd, this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new QuizPagerState();

  static Widget createQuiz({
    Quiz quiz,
    Map<String, dynamic> input,
    Function onEnd,
    Size size,
    Widget hud,
  }) {
    print(
        "here quize type isss.... what i ma getting is.......${quiz.quizType}");
    print("inpu data is.......of from database is...$input");
    switch (quiz.quizType) {
      case QuizType.oneAtATime:
        return QuizScrollerPager(
          onEnd: onEnd,
          input: input,
          hud: hud,
          relation: quiz.optionsType,
        );
        break;
      case QuizType.pair:
        return QuizScrollerPager(
          onEnd: onEnd,
          input: input,
          hud: hud,
          relation: quiz.optionsType,
        );
        break;

      case QuizType.many:
        return QuizScrollerPager(
          onEnd: onEnd,
          input: input,
          hud: hud,
          relation: quiz.optionsType,
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
  int maxIterations = 2;
  double _myProgress = 0.0;
  double _otherProgress = 0.0;
  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    // widget.gameConfig.topicId = 'tiger'; //TODO: Link to topic
    _quizzes = await QuizRepo().getQuizzesByTopicId('tiger');

    print("hello check the relation is....${_quizzes}");
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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
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

      print("hello this.... is..data of database is...${input}");
      var size = media.size;
      print(input);

      Widget hud = Container(
        width: 120.0,
        height: 140.0,
        decoration: new BoxDecoration(
          color: Colors.orange,
          borderRadius: const BorderRadius.all(const Radius.circular(40.0)),
        ),
        // height: 100.0,
        child: Stack(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            // _onProgress( progress),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(),
            ),

            // Hud(
            //     start: false,
            //     amICurrentUser: false,
            //     user: widget.gameConfig.otherUser,
            //     height: media.size.height * 0.1,
            //     gameMode: widget.gameMode,
            //     playTime: widget.playTime,
            //     onEnd: widget.onGameEnd,
            //     progress: _otherProgress,
            //     score: widget.gameConfig.otherScore,
            //     backgroundColor: Colors.red,
            //     foregroundColor: Colors.amber)
          ]),
        ]),
      );
      return QuizPager.createQuiz(
        quiz: quiz,
        input: input,
        onEnd: _onEnd,
        size: size,
        hud: hud,
      );
    } else {
      return IntrinsicHeight(
        child: Container(
          height: media.size.height,
          child: QuizResult(
              quizInputs: _quizInputs,
              quizzes: _quizzes,
              onEnd: widget.onEnd,
              onScore: widget.onScore),
        ),
      );
    }
  }

  _onEnd(Map<String, dynamic> resultData) {
    if (resultData != null) _quizInputs[_currentQuiz].addAll(resultData);
    // print(
    //     "genereal game mode is.......::${widget.gameConfig.amICurrentPlayer}");
    setState(() {
      _myProgress = (++_currentQuiz / _quizzes.length);
      print("object...... the myprogress.. ::$_myProgress");
    });
  }
}
