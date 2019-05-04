import 'package:maui/models/class_students.dart';
import 'package:maui/models/quiz_update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/collection_progress_indicator.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuizScoreScreen extends StatelessWidget {
  const QuizScoreScreen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final quizSession = StateContainer.of(context).quizSession;
    ClassStudents classStudents;
    classStudents = StateContainer.of(context).classStudents;
    QuizUpdate studentsPerformance = StateContainer.of(context).quizUpdate;
    Widget studentDatils, progress;
    List<Widget> overViewWidget = [];
    final sttudentIdVal = StateContainer.of(context).studentIdVal;
    final overViewData = StateContainer.of(context).overView;
    List<Widget> linearProgress = [];
    int i = 1;

    overViewData.forEach((e) {
      i++;
      progress = CollectionProgressIndicator(
        progress: 1.0,
        strokeCap: 2 == i || quizSession.gameData.length == i - 1
            ? LinearStrokeCap.round
            : LinearStrokeCap.butt,
//        color: e.correct == true ? Colors.green : Colors.red,
        color: Colors.green,
        width: size.width / quizSession.gameData.length - 5.0,
      );
      linearProgress.add(progress);
    });

    Widget card = SizedBox(
        height: 25.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: linearProgress,
          ),
        ));

    overViewData.forEach((e) {
      overViewWidget.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "- ${e.title} ?",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ));
    });

    studentsPerformance.performances.forEach((sp) {
      classStudents.students.forEach((e) {
        String studentId = sp.studentId.toString();
        String mydata = e.id.toString();
        if (studentId == mydata && sttudentIdVal == studentId) {
          studentDatils = Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: size.height * 0.05,
                ),
                CircleAvatar(
                  radius: 90.0,
                  child:
                      //  Image.asset(e.photo),
                      Image.asset("assets/score/star.png"),
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  e.name,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20.0,
                      child:
                          //  Image.asset(e.photo),
                          Image.asset("assets/score/star.png"),
                      backgroundColor: Colors.transparent,
                    ),
                    Text(
                      "${sp.score}",
                      style: TextStyle(fontSize: 28.0, color: Colors.white),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Overview",
                    style: TextStyle(fontSize: 22.0, color: Colors.yellow),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(20.0), child: card)
              ],
            ),
          );
        }
      });
    });

    return SafeArea(
      child: Material(
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: studentDatils,
              ),
              Expanded(
                child: ListView(
                  children: overViewWidget,
                ),
              )
            ],
          )),
    );
  }
}
