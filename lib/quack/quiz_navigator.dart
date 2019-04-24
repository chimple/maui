import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/db/entity/chapter.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/knowledge_detail.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_result.dart';
import 'package:maui/quack/quiz_selection.dart';
import 'package:maui/repos/collection_repo.dart';

enum NavigatorMode { disabled, checkable, result }

class QuizNavigator extends StatefulWidget {
  final String cardId;

  const QuizNavigator({Key key, this.cardId}) : super(key: key);

  @override
  QuizNavigatorState createState() {
    return new QuizNavigatorState();
  }
}

class QuizNavigatorState extends State<QuizNavigator> {
  bool _isLoading = true;
  Chapter _chapter;
  Map<String, List<QuizItem>> _quizItemMap = {};
  Map<String, List<QuizItem>> _answersMap = {};
  Map<String, List<QuizItem>> _startChoicesMap = {};
  Map<String, List<QuizItem>> _endChoicesMap = {};
  int _currentPageIndex = 0;
  NavigatorMode mode = NavigatorMode.disabled;

  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
//    _quizzes = await CollectionRepo()
//        .getKnowledgeAndQuizCardsInCollection(widget.cardId, CardType.question);
    final json =
        await rootBundle.loadString('assets/topic/${widget.cardId}.json');
    _chapter = Chapter.fromJson(jsonDecode(json) as Map<String, dynamic>);
    mode = NavigatorMode.result;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return _currentPageIndex >=
            _chapter.quizzes.length + _chapter.knowledges.length
        ? Scaffold(
            body: QuizResult(
            quizzes: _chapter.quizzes,
            quizItemMap: _quizItemMap,
            answersMap: _answersMap,
            startChoicesMap: _startChoicesMap,
            endChoicesMap: _endChoicesMap,
          ))
        : Navigator(
            onGenerateRoute: (RouteSettings settings) => CupertinoPageRoute(
                  builder: (BuildContext context) {
//                    final card = _quizzes[_currentPageIndex];
                    return Scaffold(
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: _currentPageIndex <
                                    _chapter.knowledges.length
                                ? KnowledgeDetail(
                                    card:
                                        _chapter.knowledges[_currentPageIndex],
                                    parentCardId: widget.cardId,
                                  )
                                : QuizCardDetail(
                                    quiz: _chapter.quizzes[_currentPageIndex -
                                        _chapter.knowledges.length],
                                    answers: _answersMap[_chapter
                                        .quizzes[_currentPageIndex -
                                            _chapter.knowledges.length]
                                        .id],
                                    startChoices: _startChoicesMap[_chapter
                                        .quizzes[_currentPageIndex -
                                            _chapter.knowledges.length]
                                        .id],
                                    endChoices: _endChoicesMap[_chapter
                                        .quizzes[_currentPageIndex -
                                            _chapter.knowledges.length]
                                        .id],
                                    parentCardId: widget.cardId,
                                    canProceed: (
                                        {List<QuizItem> quizItems,
                                        List<QuizItem> answers,
                                        List<QuizItem> startChoices,
                                        List<QuizItem> endChoices}) {
                                      if (_chapter
                                              .quizzes[_currentPageIndex -
                                                  _chapter.knowledges.length]
                                              .type ==
                                          QuizType.open) {
                                        mode = NavigatorMode.result;
                                        goToNext(context);
                                      } else {
                                        if (quizItems != null) {
                                          _quizItemMap[_chapter
                                              .quizzes[_currentPageIndex -
                                                  _chapter.knowledges.length]
                                              .id] = quizItems;
                                          _answersMap[_chapter
                                              .quizzes[_currentPageIndex -
                                                  _chapter.knowledges.length]
                                              .id] = answers;
                                          _startChoicesMap[_chapter
                                              .quizzes[_currentPageIndex -
                                                  _chapter.knowledges.length]
                                              .id] = startChoices;
                                          _endChoicesMap[_chapter
                                              .quizzes[_currentPageIndex -
                                                  _chapter.knowledges.length]
                                              .id] = endChoices;
                                        }
                                        setState(() {
                                          mode = NavigatorMode.checkable;
                                        });
                                      }
                                    },
                                    resultMode: mode == NavigatorMode.result,
                                  ),
                          ),
                          _currentPageIndex > _chapter.knowledges.length &&
                                  _chapter
                                          .quizzes[_currentPageIndex -
                                              _chapter.knowledges.length]
                                          .type ==
                                      QuizType.open
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(32.0))),
                                    color: Color(0xFF0E4476),
                                    padding: EdgeInsets.all(16.0),
                                    onPressed: _onPressed(context),
                                    child: Text(
                                      mode == NavigatorMode.result
                                          ? Loca.of(context).next
                                          : Loca.of(context).check,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 32.0),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
          );
  }

  Function _onPressed(BuildContext context) {
    switch (mode) {
      case NavigatorMode.disabled:
        return null;
        break;
      case NavigatorMode.checkable:
        return () => setState(() => mode = NavigatorMode.result);
        break;
      case NavigatorMode.result:
        return () => goToNext(context);
    }
  }

  void goToNext(BuildContext context) {
    setState(() {
      _currentPageIndex++;
      mode = _currentPageIndex < _chapter.knowledges.length
          ? NavigatorMode.result
          : NavigatorMode.disabled;
    });
//    Provider.dispatch<RootState>(
//        context,
//        AddProgress(
//            cardId: _quizzes[_currentPageIndex].id,
//            parentCardId: widget.cardId,
//            index: _currentPageIndex + 1));

    Navigator.of(context).pushReplacementNamed('/current_quiz');
  }
}
