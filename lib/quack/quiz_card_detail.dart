import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/quack/header_app_bar.dart';
import 'package:maui/quack/quiz_selection.dart';
import 'package:maui/repos/card_repo.dart';

enum QuizItemStatus { selectable, correct, incorrect, unselectable }

typedef CanProceed(List<QuizItem> quizItems);

class QuizItem {
  String text;
  QuizItemStatus status;
  bool isAnswer;
  int index;

  QuizItem({this.text, this.status, this.isAnswer, this.index});

  @override
  String toString() {
    return 'QuizItem{text: $text, status: $status, isAnswer: $isAnswer, index: $index}';
  }
}

class QuizCardDetail extends StatefulWidget {
  final QuackCard card;
  final List<QuizItem> quizItems;
  final String parentCardId;
  final CanProceed canProceed;
  final bool resultMode;

  const QuizCardDetail(
      {Key key,
      this.card,
      this.quizItems,
      this.parentCardId,
      this.canProceed,
      this.resultMode})
      : super(key: key);

  @override
  QuizCardDetailState createState() {
    return new QuizCardDetailState();
  }
}

class QuizCardDetailState extends State<QuizCardDetail> {
  Quiz _quiz;
  List<QuizItem> _quizItems;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _quiz = await CardRepo().getQuiz(widget.card.id);
    if (widget.quizItems == null) {
      int index = 0;
      _quizItems = _quiz.choices
          .map((s) => QuizItem(
              text: s,
              status: QuizItemStatus.selectable,
              isAnswer: false,
              index: index++))
          .toList();
      index = 0;
      _quizItems.addAll(_quiz.answers.map((s) => QuizItem(
          text: s,
          status: QuizItemStatus.selectable,
          isAnswer: true,
          index: index++)));
      _quizItems.shuffle();
    } else {
      _quizItems = widget.quizItems;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print(_quizItems);
    final scrollViewWidgets = <Widget>[
      HeaderAppBar(
        card: widget.card,
        parentCardId: widget.parentCardId,
        showBackButton: true,
      )
    ];
    scrollViewWidgets.add(SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: MarkdownBody(
          data: widget.card.content ?? '',
          styleSheet: new MarkdownStyleSheet(
              p: new TextStyle(fontSize: 16.0, color: Colors.black))),
    )));
    if (!_isLoading) {
      scrollViewWidgets.add(
        SliverToBoxAdapter(
            child: QuizSelection(
          quiz: _quiz,
          quizItems: _quizItems,
          canProceed: widget.canProceed,
          resultMode: widget.resultMode,
        )),
      );
    }
    return CustomScrollView(
      slivers: scrollViewWidgets,
    );
  }
}
