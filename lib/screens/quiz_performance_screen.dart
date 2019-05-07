import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/models/performance.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';

class QuizPerformanceScreen extends StatefulWidget {
  @override
  _QuizPerformanceScreenState createState() => _QuizPerformanceScreenState();
}

class _QuizPerformanceScreenState extends State<QuizPerformanceScreen> {
  List<String> _quizStudentsIds;
  List<User> _quizStudents = [];
  Map<String, Performance> _performances;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("QUIZ PERFORMANCE SCREEN DEPENDENCIES CHANGED.......................................................................................");
    _performances = AppStateContainer.of(context).quizPerformances;
    _quizStudentsIds = AppStateContainer.of(context).quizStudents.toList();
    _quizStudentsIds.forEach((String userID) {
      queryUser(userID);
    });
    super.didChangeDependencies();
  }

  Future<void> queryUser(String userID) async {
    await UserRepo().getUser(userID).then((User user) {
      if (user != null) {
        if (user.userType == UserType.student &&
            !_quizStudents.contains(user)) {
          setState(() {
            _quizStudents.add(user);
          });
        }
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    var bodyContent = Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: _quizStudents.length,
              itemBuilder: (context, index) {
                return buildPerformanceCard(index);
              }),
        ), //RaisedButton(child: Text('Add'), onPressed: changeData)
      ],
    );

    return MaterialApp(
      title: "Quiz Performance Screen",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Quiz Performance Screen"),
        ),
        body: bodyContent,
      ),
    );
  }

  Card buildPerformanceCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              child: Expanded(flex: 1, child: buildCardLeftSection(index))),
          Container(child: Expanded(flex: 4, child: buildCardRightSection(index)))
        ],
      ),
    );
  }

  Column buildCardRightSection(int index) {

    print('Building Right Section.................................................................................');
    return Column(
      children: <Widget>[
        Text('Game Name', style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: progressIndicator(index)
          ),
        )
      ],
    );
  }

  List<Widget> progressIndicator(int index){

    List<Widget> _myProgressIndicator = [];

    _performances.forEach((studentID, performance){
      if(studentID == _quizStudents[index].id){
        performance.subScores.forEach((subScore){
          _myProgressIndicator.add(new SubScoreProgress(isComplete: subScore.complete));
          _myProgressIndicator.add(new Container(width: 3));
        });
      }
    });

    return _myProgressIndicator;
  }

  Column buildCardLeftSection(int index) {
    Widget imageIcon = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 70,
        height: 70,
        //Replace & add a Child CircleAvatar for image
        decoration: BoxDecoration(
          image: DecorationImage(
              image: FileImage(File(_quizStudents[index].image)),
              fit: BoxFit.fill),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        imageIcon,
        Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(Icons.star, color: Colors.yellow)), //Star Icon
            Expanded(
              flex: 3,
              child: Text(getScore(index),
                  style: TextStyle(fontSize: 20), overflow: TextOverflow.fade),
            ) //Score
          ],
        ),
        Text(_quizStudents[index].name,
            style: TextStyle(fontSize: 20), overflow: TextOverflow.fade)
      ],
    );
  }

  String getScore(int index) {
    String score = 0.toString();
    _performances
        .forEach((studentID, performance) {
      if (studentID == _quizStudents[index].id) {
        score = performance.score.toString();
      }
    });
    return score;
  }
}

class SubScoreProgress extends StatelessWidget {
  final bool isComplete;

  SubScoreProgress({this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: SizedBox(
          height: 20,
          child: LinearProgressIndicator(
              value: 1.0,
              valueColor: isComplete != null ? AlwaysStoppedAnimation(
                  isComplete ? Colors.green : Colors.red) : null)),
    ));
  }
}
