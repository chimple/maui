import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
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
  List<QuackCard> _quizzes;
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
    _quizzes = await CollectionRepo()
        .getKnowledgeAndQuizCardsInCollection(widget.cardId, CardType.question);
    if (_quizzes.first?.type == CardType.knowledge) mode = NavigatorMode.result;
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
    return _currentPageIndex >= _quizzes.length
        ? Scaffold(
            body: QuizResult(
            quizzes: _quizzes,
            quizItemMap: _quizItemMap,
            answersMap: _answersMap,
            startChoicesMap: _startChoicesMap,
            endChoicesMap: _endChoicesMap,
          ))
        : Navigator(
            onGenerateRoute: (RouteSettings settings) => CupertinoPageRoute(
                  builder: (BuildContext context) {
                    final card = _quizzes[_currentPageIndex];
                    return Scaffold(
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: card.type == CardType.knowledge
                                ? KnowledgeDetail(
                                    card: card,
                                    parentCardId: widget.cardId,
                                  )
                                : QuizCardDetail(
                                    card: card,
                                    answers: _answersMap[card.id],
                                    startChoices: _startChoicesMap[card.id],
                                    endChoices: _endChoicesMap[card.id],
                                    parentCardId: widget.cardId,
                                    canProceed: (
                                        {List<QuizItem> quizItems,
                                        List<QuizItem> answers,
                                        List<QuizItem> startChoices,
                                        List<QuizItem> endChoices}) {
                                      if (card.option == 'open') {
                                        mode = NavigatorMode.result;
                                        goToNext(context);
                                      } else {
                                        if (quizItems != null) {
                                          _quizItemMap[card.id] = quizItems;
                                          _answersMap[card.id] = answers;
                                          _startChoicesMap[card.id] =
                                              startChoices;
                                          _endChoicesMap[card.id] = endChoices;
                                        }
                                        setState(() {
                                          mode = NavigatorMode.checkable;
                                        });
                                      }
                                    },
                                    resultMode: mode == NavigatorMode.result,
                                  ),
                          ),
                          card.option == 'open'
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
                                      style: TextStyle(color: Colors.white, fontSize: 32.0),
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
      mode = _currentPageIndex < _quizzes.length &&
              _quizzes[_currentPageIndex].type == CardType.knowledge
          ? NavigatorMode.result
          : NavigatorMode.disabled;
    });
    Provider.dispatch<RootState>(
        context,
        AddProgress(
            cardId: _quizzes[_currentPageIndex].id,
            parentCardId: widget.cardId,
            index: _currentPageIndex + 1));

    Navigator.of(context).pushReplacementNamed('/current_quiz');
  }
}
