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
  List<String> _userIDs;
  List<User> _students = [];
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    await UserRepo().getUsers().then((onValue){
      setState(() {
        if(onValue != null){
          print('Getting Users............................................');
          onValue.forEach((User user){
            if(user.userType == UserType.student){
              _students.add(user);
            }
          });
        }
        else{
          print('No Users Found...........................................');
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('Dependencies Changed..................................................');
    String latestUserID = AppStateContainer.of(context).classStudents?.last;
    if(latestUserID != null){
      queryUser(latestUserID);
    }
  }

  void queryUser(String latestUserID) async {
    await UserRepo().getUser(latestUserID).then((User user){
      setState(() {
        print('setState calling.........................................................');
        _students.add(user);
        print('Added User to _students List.............................................${_students.toString()}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var keys = _performance.keys.toList();

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
              itemCount: _students.length,
              itemBuilder: (context, index) {
                print('Building List');
                return buildPerformanceCard(index);
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

  Card buildPerformanceCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              child:
              Expanded(flex: 1, child: buildCardLeftSection(index))),
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
            Expanded(flex: 1, child: Icon(Icons.star, color: Colors.yellow)), //Star Icon
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
