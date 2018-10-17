import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_selection.dart';

class QuizResult extends StatefulWidget {
  final List<QuackCard> quizzes;
  final Map<String, List<QuizItem>> quizItemMap;

  const QuizResult({Key key, this.quizzes, this.quizItemMap}) : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  int _expandedPanel = -1;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int panelIndex, bool isExpanded) {
          setState(() {
            _expandedPanel = isExpanded ? -1 : panelIndex;
          });
        },
        children: widget.quizzes
            .map(
              (q) => ExpansionPanel(
                    isExpanded: _expandedPanel == index++ ? true : false,
                    headerBuilder: (BuildContext context, bool isExpanded) =>
                        Text(q.content ?? ''),
                    body: QuizSelection(
                      quizItems: widget.quizItemMap[q.id],
                      resultMode: true,
                    ),
                  ),
            )
            .toList(growable: false),
        animationDuration: Duration(milliseconds: 250),
      ),
    );
  }
}
