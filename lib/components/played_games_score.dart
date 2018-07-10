import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/score_repo.dart';
import 'package:maui/state/app_state_container.dart';

class PlayedGamesScoreDisplay extends StatefulWidget {
  @override
  RandomState createState() {
    return new RandomState();
  }
}

class RandomState extends State<PlayedGamesScoreDisplay> {
  bool _isLoading = false;
  Map<String, int> _scores;
   Map<String, List<Color>> game ;
   List<String> gameName;
  @override
    void initState() {
      super.initState();
      _initData();
    }

    void _initData() async {
    _isLoading = true;
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
    Map<String, int> fetchData = await ScoreRepo().getScoreCountByUser(loggedInUser.id);
    print("Fetched Data ${fetchData}");
    setState(() {
        _scores = fetchData;
        _isLoading = false;
      });
    }

  @override
 Widget build(BuildContext context) {  
    if(_isLoading) {
      //return a spinner
      return Container();
    }
    List<Widget> scoreWidgets = List<Widget>();
    _scores.forEach((k, v) {
      scoreWidgets.add(
        new Container(
          margin: const EdgeInsets.all(0.0),
          color: SingleGame.gameColors[k][0],
          child: ExpansionTile( 
            leading: Image.asset('assets/hoodie/${k}.png',scale: 5.0,),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text('$k',textAlign: TextAlign.left, style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),),
                new Text('$v',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),),
              ],
            ),
            children: <Widget>[
                new Text('Hello World!!'),
                new Text('Hello World!!'),
                new Text('Hello World!!'),
                new Text('Hello World!!'),
                new Text('Hello World!!'),
            ],
          ),
        )
      );
    });
    return new ListView(
      children: scoreWidgets
    );                  
  }
}