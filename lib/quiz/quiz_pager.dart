import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/components/hud.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/quiz_repo.dart';
import 'package:maui/db/entity/quiz.dart';
import 'match_the_following.dart';
import 'multiple_choice.dart';
import 'grouping_quiz.dart';
import 'quiz_scroller_pagger.dart';
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
 double _myProgress = 0.0;
   double _otherProgress = 0.0;
   int playTime = 10000;
   Function onGameEnd;
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
      {Quiz quiz, Map<String, dynamic> input, Function onEnd, Size size, Widget huda, optionTypeis}) {
        
       print("here quize type isss.... what i ma getting is.......${quiz.quizType}");
        print("inpu data is.......of from database is...$input");
    switch (quiz.quizType) {
    
      case QuizType.oneAtAtime:
     
        return Quizscroller_pagger(
          onEnd: onEnd,
          input: input,
          huda: huda,
          relation: optionTypeis,
        );
        break;
      case QuizType.pair:
        return Quizscroller_pagger(
          onEnd: onEnd,
          input: input,
          huda: huda,
          relation: optionTypeis,
        );
        break;
      case QuizType.oneAtAtime:
        return Quizscroller_pagger(
          onEnd: onEnd,
          input: input,
          huda: huda,
          relation: optionTypeis,
        );
        break;
      case QuizType.many:
      print("object");
        return Quizscroller_pagger(
          onEnd: onEnd,
          input: input,
          huda: huda,
          relation: optionTypeis,
        );
        break;
      case QuizType.many:
        return Quizscroller_pagger(
          onEnd: onEnd,
          input: input,
          huda: huda,
          relation: optionTypeis,
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
  var optionType;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    widget.gameConfig.topicId = 'lion'; //TODO: Link to topic
    _quizzes = await QuizRepo().getQuizzesByTopicId(widget.gameConfig.topicId);

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
    optionType=  _quizzes.map((quiz) {
      String dataoptional;
      try {
        print("this......is......quiz is.....${quiz.optionsType}");
        dataoptional = quiz.optionsType;
      } catch (e) {
        print(e);
        dataoptional =null;
      }
      return dataoptional;
    }).toList(growable: false);
    print("i am checking optional type is.....$optionType");
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
     final optionTypeis=optionType[_currentQuiz];


      print("hello this.... is..data of database is...${input}");
      var size=media.size;
      print(input);
      final mh2h = widget.gameConfig.gameDisplay == GameDisplay.myHeadToHead;
    final oh2h = widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead;
      Widget huda= Container(
       
        width:  widget.gameConfig.gameDisplay ==
                                    GameDisplay.localTurnByTurn ||
                                widget.gameConfig.gameDisplay ==
                                    GameDisplay.networkTurnByTurn?400.0:120.0,
        height: 140.0,
           decoration: new BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: const BorderRadius.all(const Radius.circular(40.0)
                                       ),
                                ),
        // height: 100.0,
        child: Stack(
          children: [Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hud(
                  user: widget.gameConfig.myUser,
                  height: media.size.height / 10,
                  gameMode: widget.gameMode,
                  playTime: widget.playTime,
                  onEnd: widget.onGameEnd,
                  progress: widget.gameConfig.amICurrentPlayer ? widget._myProgress : null,
                  start: !oh2h ,
                  score: widget.gameConfig.myScore,
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.red),
            ),

                  widget.gameConfig.gameDisplay ==
                                        GameDisplay.localTurnByTurn ||
                                    widget.gameConfig.gameDisplay ==
                                        GameDisplay.networkTurnByTurn?
                                      Hud(
                                        start: false,
                                        amICurrentUser: false,
                                        user: widget.gameConfig.otherUser,
                                        height: media.size.height / 10,
                                        gameMode: widget.gameMode,
                                        playTime: widget.playTime,
                                        onEnd: widget.onGameEnd,
                                        progress: widget._otherProgress,
                                        score:
                                            widget.gameConfig.otherScore,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.amber):Container()
            ]
          ),
             widget.gameConfig.gameDisplay ==
                                    GameDisplay.localTurnByTurn ||
                                widget.gameConfig.gameDisplay ==
                                    GameDisplay.networkTurnByTurn
                            ? new AnimatedPositioned(
                                key: ValueKey<String>('currentPlayer'),
                                left: widget.gameConfig.amICurrentPlayer
                                    ? 70.0
                                    : media.size.width -
                                        32.0 -
                                        media.size.height / 8.0 * 0.6,
                               bottom: 8.0,
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.elasticOut,
                                child: Container(
                                 
                                  color: Colors.blue,
                                  width: media.size.height / 9.0 * 0.3,
                                  height: 8.0,
                                ),
                              )
                            : Container(),
          ]
        ),
      );
      return QuizPager.createQuiz(quiz: quiz, input: input, onEnd: _onEnd,size:size,huda:huda,optionTypeis:optionTypeis);
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
