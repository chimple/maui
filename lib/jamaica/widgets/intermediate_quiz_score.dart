import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';

class IntermediateQuizScore extends StatefulWidget {
  final Function onTap;

  const IntermediateQuizScore({Key key, this.onTap}) : super(key: key);

  @override
  _IntermediateQuizScoreState createState() => _IntermediateQuizScoreState();
}

class _IntermediateQuizScoreState extends State<IntermediateQuizScore> {
  List<User> studnetObjs = [];
  List<int> studentsScores = [];
  List<String> titles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppStateContainer.of(context)
        .quizPerformances
        .forEach((studentId, performance) async {
      if (performance.studentId != null) {
        await queryUser(performance.studentId);
        studentsScores.add(performance.score);
        titles.add(performance.title);
      } else {
        print("Student Id NULL");
      }
    });
  }

  Future<void> queryUser(String studentId) async {
    await UserRepo().getUser(studentId).then((User user) {
      if (user != null) {
        setState(() {
          isLoading = false;
          studnetObjs.add(user);
        });
      } else {
        print('Student Not Found');
      }
    });
  }

  Widget studentsScoreList(int index) {
    if(isLoading) {
      return new CircularProgressIndicator(
        backgroundColor: Colors.black,
      );
    } else {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            new Expanded(
              flex: 10,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      flex: 2,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            height: 50.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    image:  new FileImage(File(studnetObjs[index].image)),
                                    fit: BoxFit.fill)),
                          ),
                          new Container(
                            child: new Text(
                              "${studnetObjs[index].name}",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: new Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                new Container(
                                  child: new Text("${studentsScores[index]}",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  new Divider(
                    height: 5.0,
                  ),
                  new Expanded(
                    flex: 8,
                    child: new Container(
                      margin: EdgeInsets.only(left: 10.0),
                        height: 50.0,
                        child: new Text("${titles[index]}",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            )
          ],
        ),
        new Divider(
          height: 5.0,
          color: Colors.black,
        )
      ],
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
                itemCount: studnetObjs.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: studentsScoreList(index),
                  );
                }),
          ),
          new RaisedButton(
            onPressed: widget.onTap,
            child: new Text("Next"),
          )
        ],
      ),
    );
  }
}
