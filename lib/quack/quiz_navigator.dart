import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/quack/card_header.dart';
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
  int _currentPageIndex = 0;
  NavigatorMode mode = NavigatorMode.disabled;

  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _quizzes = await CollectionRepo()
        .getCardsInCollectionByType(widget.cardId, CardType.question);
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
    return Scaffold(
      body: _currentPageIndex >= _quizzes.length
          ? QuizResult(
              quizzes: _quizzes,
              quizItemMap: _quizItemMap,
            )
          : Navigator(
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                    builder: (BuildContext context) => Column(
                          children: <Widget>[
                            Expanded(
                              child: QuizCardDetail(
                                card: _quizzes[_currentPageIndex],
                                quizItems: _quizItemMap[
                                    _quizzes[_currentPageIndex].id],
                                parentCardId: widget.cardId,
                                canProceed: (List<QuizItem> quizItems) {
                                  _quizItemMap[_quizzes[_currentPageIndex].id] =
                                      quizItems;
                                  setState(() {
                                    mode = NavigatorMode.checkable;
                                  });
                                },
                                resultMode: mode == NavigatorMode.result,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: _onPressed(context),
                            )
                          ],
                        ),
                  ),
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
        return () {
          setState(() {
            _currentPageIndex++;
          });
          mode = NavigatorMode.disabled;
          Navigator.of(context).pushReplacementNamed('/current_quiz');
        };
    }
  }
}
