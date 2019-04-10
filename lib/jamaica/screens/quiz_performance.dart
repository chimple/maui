import 'package:maui/models/class_students.dart';
import 'package:maui/models/quiz_update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/quiz_score_screen.dart';
import 'package:maui/jamaica/state/state_container.dart';

class QuizPerformance extends StatelessWidget {
  final int length;
  const QuizPerformance({Key key, this.length}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("here lets check....$length");
    ClassStudents classStudents;
    classStudents = StateContainer.of(context).classStudents;
    final quizSession = StateContainer.of(context).quizSession;
    QuizUpdate studentsPerformance = StateContainer.of(context).quizUpdate;
    List<Widget> studentsList = [];
    final status = studentsPerformance.status;
    int i = 1;
    studentsPerformance.performances.forEach((sp) {
      classStudents.students.forEach((e) {
        String studentId = sp.studentId.toString();
        String mydata = e.id.toString();
        if (studentId == mydata) {
          Widget card = Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20.0,
                        child: Image.asset("assets/score/star.png"),
                        //  Image.asset(e.photo),
                        backgroundColor: Colors.transparent,
                      ),
                      Text("${i++}"),
                    ],
                  ),
                ),
                Text(e.name),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20.0,
                        child: Image.asset("assets/score/star.png"),
                        //  Image.asset(e.photo),
                        backgroundColor: Colors.transparent,
                      ),
                      Text("${sp.score}"),
                    ],
                  ),
                )
              ],
            ),
          );
          studentsList.add(card);
        }
      });
    });

    return status != StatusEnum.end
        ? Material(
            color: Colors.blue,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(children: studentsList),
                ),
                quizSession.gameData.length - 1 >= length
                    ? Center(
                        child: SizedBox(
                          height: 40.0,
                          width: 100.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("click to go"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ))
        : QuizScoreScreen();
  }
}
