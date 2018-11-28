import 'package:flutter/material.dart';
import 'package:maui/quack/quiz_card_detail.dart';

class QuizStack extends StatefulWidget {
  final List<QuizItem> answers;
  final List<QuizItem> choices;
  final Function onPressed;

  const QuizStack({Key key, this.answers, this.choices, this.onPressed})
      : super(key: key);

  @override
  QuizStackState createState() {
    return new QuizStackState();
  }
}

class QuizStackState extends State<QuizStack> {
  @override
  Widget build(BuildContext context) {
    final answersLength = widget.answers?.length ?? 0;
    final choicesLength = widget.choices?.length ?? 0;
    final numRows = (answersLength / 2).ceil() + (choicesLength / 2).ceil();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        final height = constraints.maxHeight / numRows;
        List<Widget> widgets = [
          Container(
            constraints: BoxConstraints.expand(),
          )
        ];
        int i = 0;
        for (; i < answersLength; i = i + 2) {
          widgets.add(_quizButton(
              quizItem: widget.answers[i],
              row: i ~/ 2,
              col: 0,
              width: width,
              height: height));
          if (i + 1 < answersLength)
            widgets.add(_quizButton(
                quizItem: widget.answers[i + 1],
                row: i ~/ 2,
                col: 1,
                width: width,
                height: height));
        }
        for (int j = 0; j < choicesLength; j = j + 2) {
          widgets.add(_quizButton(
              quizItem: widget.choices[j],
              row: (i + j) ~/ 2,
              col: 0,
              width: width,
              height: height));
          if (j + 1 < choicesLength)
            widgets.add(_quizButton(
                quizItem: widget.choices[j + 1],
                row: (i + j) ~/ 2,
                col: 1,
                width: width,
                height: height));
        }
        return Stack(
          children: widgets,
        );
      },
    );
  }

  Widget _quizButton(
      {QuizItem quizItem, int row, int col, double width, double height}) {
    return AnimatedPositioned(
      key: ObjectKey(quizItem),
      duration: Duration(milliseconds: 500),
      top: row * height,
      left: col * width,
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: widget.onPressed == null
              ? null
              : () => widget.onPressed(quizItem),
          child: (quizItem.text?.endsWith('jpg') ||
                  quizItem.text?.endsWith('jpeg') ||
                  quizItem.text?.endsWith('gif'))
              ? AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.asset(
                    quizItem.text,
                    fit: BoxFit.contain,
                  ))
              : Text(
                  quizItem.text,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
        ),
      ),
    );
  }
}
