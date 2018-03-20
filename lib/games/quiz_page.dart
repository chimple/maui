import 'package:flutter/material.dart';

import '../components/Quiz_components/question.dart';
import '../components/Quiz_components/quiz.dart';

import '../components/Quiz_components/answer_button.dart';
import '../components/Quiz_components/question_text.dart';
import '../components/Quiz_components/correct_wrong_overlay.dart';

import '../components/Quiz_components/score_page.dart'; 

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Apple", true),
    new Question("Zbera", false),
    new Question("Kite", true)
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
        mainAxisAlignment: MainAxisAlignment.end,       
           children: <Widget>[
             new Column(
               mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[new Column( 
               mainAxisAlignment: MainAxisAlignment.end,
             children: <Widget>[ 
               new QuestionText(questionText, questionNumber),
              new Padding(
              padding: new EdgeInsets.all(85.0),
            ),
             ]
           ),
              ],
             ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.all(15.0),
                  ),
                  new AnswerButton(true, () => handleAnswer(true)), //true button
                  new Padding(
                    padding: new EdgeInsets.all(15.0),
                  ),
                  new AnswerButton(false, () => handleAnswer(false)), 
                  new Padding(
                    padding: new EdgeInsets.all(15.0),
                  ),// false button
                ],
            ),
            new Padding(
              padding: new EdgeInsets.only(bottom: 100.0),
            ),
          ],
        ),
        overlayShouldBeVisible == true ? new CorrectWrongOverlay(
            isCorrect,
                () {
              if (quiz.length == questionNumber) {
                Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
                return;
              }
              currentQuestion = quiz.nextQuestion;
              this.setState(() {
                overlayShouldBeVisible = false;
                questionText = currentQuestion.question;
                questionNumber = quiz.questionNumber;
              });
            }
        ) : new Container()
      ],
    ),
    );
  }
    
}