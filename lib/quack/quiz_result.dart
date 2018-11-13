import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_selection.dart';

class QuizResult extends StatefulWidget {
  final List<QuackCard> quizzes;
  final Map<String, List<QuizItem>> quizItemMap;
  final Map<String, List<QuizItem>> answersMap;
  final Map<String, List<QuizItem>> startChoicesMap;
  final Map<String, List<QuizItem>> endChoicesMap;

  const QuizResult(
      {Key key,
      this.quizzes,
      this.quizItemMap,
      this.answersMap,
      this.startChoicesMap,
      this.endChoicesMap})
      : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  int _expandedPanel = -1;

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
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
                    body: SizedBox(
                      height: media.size.height * 3 / 4,
                      child: QuizSelection(
                        quizItems: widget.quizItemMap[q.id],
                        answers: widget.answersMap[q.id],
                        startChoices: widget.startChoicesMap[q.id],
                        endChoices: widget.endChoicesMap[q.id],
                        resultMode: true,
                      ),
                    ),
                  ),
            )
            .toList(growable: false),
        animationDuration: Duration(milliseconds: 250),
      ),
    );
  }
}
