import 'package:flutter/material.dart';
import 'package:maui/models/multi_data.dart';
import 'package:maui/models/quiz_session.dart';
import 'package:maui/repos/game_data_repo.dart';
import 'package:maui/repos/lesson_repo.dart';
import 'package:maui/screens/quiz_waiting_screen.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/models/performance.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/db/entity/user.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:built_collection/built_collection.dart';
import 'package:uuid/uuid.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, Performance> _performance;
  List<User> _students = [];
  List<String> _onlineStudents = [];
  String _latestUserID;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await UserRepo().getUsers().then((onValue) {
      setState(() {
        if (onValue != null) {
          onValue.forEach((User user) {
            if (user.userType == UserType.student) {
              _students.add(user);
            }
          });
        } else {
          Center(
            child: Container(
              child: Text('No Students'),
            ),
          );
        }
      });
    });
  }

  @override
  void didChangeDependencies() async {
    if (AppStateContainer.of(context).classStudents.isNotEmpty) {
      _latestUserID = AppStateContainer.of(context).classStudents.last;
      if (_latestUserID != null) {
        await queryUser(_latestUserID);
      }
    }
    super.didChangeDependencies();
  }

  Future<void> queryUser(String latestUserID) async {
    await UserRepo().getUser(latestUserID).then((User user) {
      if (user != null) {
        setState(() {
          if (user.userType == UserType.student && !_students.contains(user)) {
            _students.add(user);
            _onlineStudents.add(user.id);
          }
        });
      } else {
        print('Student not Found');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var background = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Background_potriat.png'),
              fit: BoxFit.cover)),
    );

    var padding = Padding(padding: EdgeInsets.all(8.0));

    var bodyContent = Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return buildPerformanceCard(index);
              }),
        ), //RaisedButton(child: Text('Add'), onPressed: changeData)
      ],
    );

    var scaffold = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 2,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                final lesson = await LessonRepo().getLesson(1);
                final gameData = await fetchGameData(lesson);

                QuizSession quizSession = new QuizSession((b) => b
                  ..sessionId = new Uuid().v4()
                  ..gameId = 'B'
                  ..level = 1
                  ..gameData.addAll(gameData));

                //QuizSession newQuizSession = addDummyData();
                AppStateContainer.of(context)
                    .createQuizSession(quizSession)
                    .then((_) {
                  Navigator.of(context).push(MaterialPageRoute<Null>(
                      builder: (BuildContext context) =>
                          QuizWaitingScreen(quizSession: quizSession)));
                });
              })
        ],
      ),
      body: bodyContent,
    );

    return Stack(
      children: <Widget>[background, padding, scaffold],
    );
  }

  Card buildPerformanceCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              child: Expanded(flex: 1, child: buildCardLeftSection(index))),
          Container(child: Expanded(flex: 4, child: buildCardRightSection()))
        ],
      ),
    );
  }

  Column buildCardRightSection() {
    return Column(
      children: <Widget>[
        Text('Game Name', style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(),
        )
      ],
    );
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
                image: FileImage(File(_students[index].image)),
                fit: BoxFit.fill),
            //shape: BoxShape.circle,
            borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
            border: new Border.all(
                color: _onlineStudents.length == 0
                    ? Colors.red
                    : _onlineStudents.contains(_students[index])
                        ? Colors.green
                        : Colors.red,
                width: 4.0)),
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
              child: Text('200000',
                  style: TextStyle(fontSize: 20), overflow: TextOverflow.fade),
            ) //Score
          ],
        ),
        Text(_students[index].name,
            style: TextStyle(fontSize: 20), overflow: TextOverflow.fade)
      ],
    );
  }
}
