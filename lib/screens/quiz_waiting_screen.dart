import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/jamaica/widgets/game.dart';
import 'package:maui/jamaica/widgets/slide_up_route.dart';
import 'package:maui/models/quiz_session.dart';
import 'package:maui/models/quiz_update.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/screens/quiz_performance_screen.dart';
import 'package:maui/state/app_state_container.dart';

class QuizWaitingScreen extends StatefulWidget {
  final QuizSession quizSession;
  QuizWaitingScreen({Key key, this.quizSession});

  @override
  _QuizWaitingScreenState createState() => _QuizWaitingScreenState();
}

class _QuizWaitingScreenState extends State<QuizWaitingScreen> {
  List<User> _joinedStudents = [];
  bool _isTeacher = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppStateContainer.of(context).state.loggedInUser.userType ==
            UserType.teacher
        ? _isTeacher = true
        : _isTeacher = false;
    if (AppStateContainer.of(context).quizStudents.length != 0) {
      AppStateContainer.of(context).quizStudents.forEach((String studentID) {
        queryUser(studentID);
      });
    }
    if (!_isTeacher) {
      AppStateContainer.of(context)
          .quizSessions
          .forEach((quizSession, quizStatus) {
        if (quizStatus == StatusEnum.start) {
          Navigator.of(context).push(SlideUpRoute(
            widgetBuilder: (context) => Game(quizSession: widget.quizSession),
          ));
        }
      });
    }
    super.didChangeDependencies();
  }

  Future<void> queryUser(String userID) async {
    await UserRepo().getUser(userID).then((User user) {
      if (user != null) {
        if (user.userType == UserType.student &&
            !_joinedStudents.contains(user)) {
          setState(() {
            _joinedStudents.add(user);
          });
        }
      } else {}
    });
  }

  void showAlertDialog(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Alert'),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text("YES"),
              onPressed: () {
                AppStateContainer.of(context).quizStudents.remove(AppStateContainer.of(context).state.loggedInUser.id);
              },
            ),
            new FlatButton(
              child: new Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Quiz Waiting Screen'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              if (_isTeacher) {
                Navigator.of(context).pop();
                AppStateContainer.of(context).endQuizSession();
              } else {
                //Student quit the quiz
                showAlertDialog('Do you want to exist');
              }
            }),
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: _joinedStudents.length != 0
            ? ListView.builder(
                itemCount: _joinedStudents.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 70,
                            height: 70,
                            //Replace & add a Child CircleAvatar for image
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(
                                        File(_joinedStudents[index].image)),
                                    fit: BoxFit.fill),
                                shape: BoxShape.circle),
                          ),
                        ),
                        Expanded(
                          child: Text(_joinedStudents[index].name,
                              style: TextStyle(fontSize: 20),
                              overflow: TextOverflow.fade),
                        )
                      ],
                    ),
                  );
                })
            : Container(child: CircularProgressIndicator()),
      ),
      floatingActionButton: _isTeacher
          ? RaisedButton(
              onPressed: () async {
                await AppStateContainer.of(context)
                    .startQuizSession(widget.quizSession)
                    .then((_) {
                  if (_isTeacher) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) =>
                            QuizPerformanceScreen()));
                  }
                });
              },
              disabledColor: Colors.grey.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: new Text('Start'),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
