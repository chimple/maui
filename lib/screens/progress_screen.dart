import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/models/performance.dart';
import 'package:random_string/random_string.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/db/entity/user.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, Performance> _performance;

  @override
  void initState() {
    super.initState();
    _performance = new Map();
    addDummyData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //_performance = AppStateContainer.of(context).performances;
  }

  void addDummyData() {
    Performance performance = new Performance(updates);
    _performance.putIfAbsent(
        randomString(10, from: 97, to: 122), () => performance);
  }

  void updates(PerformanceBuilder b) {
    b.studentId = randomString(10, from: 97, to: 122);
    b.gameId = randomString(10, from: 97, to: 122);
    b.correct = true;
    b.question = randomString(10, from: 97, to: 122);
    b.answer = randomString(10, from: 97, to: 122);
    b.endTime = DateTime.now();
    b.startTime = DateTime.now();
    b.level = 2;
    b.score = 100;
    b.total = 200;
    b.sessionId = randomString(10, from: 97, to: 122);
  }

  void changeData() {
    setState(() {
      Performance per = new Performance(updates);
      _performance.putIfAbsent(randomString(10, from: 97, to: 122), () => per);
    });
  }

  @override
  Widget build(BuildContext context) {
    var keys = _performance.keys.toList();

    var background = Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/Background_potriat.png'),fit: BoxFit.cover)
      ),
    );

    var padding = Padding(padding: EdgeInsets.all(8.0));

    var bodyContent = Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                return buildPerformanceCard(keys, index);
              }),
        ), //RaisedButton(child: Text('Add'), onPressed: changeData)
      ],
    );


    var scaffold = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white30, elevation: 2,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), color: Colors.white, onPressed: null)
        ],
      ),
      body: bodyContent,
    );


    return Stack(
      children: <Widget>[background, padding, scaffold],
    );
  }

  Card buildPerformanceCard(List<String> keys, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              child:
                  Expanded(flex: 1, child: buildCardLeftSection(keys, index))),
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

  Column buildCardLeftSection(List<String> keys, int index) {
    Widget imageIcon = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 70,
        height: 70,
        //Replace & add a Child CircleAvatar for image
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        imageIcon,
        Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 1, child: Icon(Icons.star, color: Colors.yellow)),
            Expanded(
              flex: 3,
              child: Text('200000',
                  style: TextStyle(fontSize: 20), overflow: TextOverflow.fade),
            )
          ],
        ),
        Text(_performance[keys[index]].studentId,
            style: TextStyle(fontSize: 20), overflow: TextOverflow.fade)
      ],
    );
  }

  /* @override
  Widget build(BuildContext context) {
    var keys = _performance.keys.toList();
    return Container(
        child: Column(
          children: <Widget>[
            ///Text(_performance.toString(), style: TextStyle(fontSize: 40)),
            Expanded(
              child: ListView.builder(
                itemCount: _performance.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Text(keys[index].toString(), style: TextStyle(fontSize: 40)),
                      Text(_performance[keys[index]].toString(),
                          style: TextStyle(fontSize: 40)),
                    ],
                  );
                },
              ),
            ),
            RaisedButton(child: Text('Add'), onPressed: changeData),
          ],
        ));
  }*/
}
