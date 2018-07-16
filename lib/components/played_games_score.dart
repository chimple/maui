import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/score.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/score_repo.dart';
import 'package:maui/state/app_state_container.dart';

class PlayedGamesScoreDisplay extends StatefulWidget {
  @override
  PlayedGamesScoreDisplayState createState() {
    return new PlayedGamesScoreDisplayState();
  }
}

class PlayedGamesScoreDisplayState extends State<PlayedGamesScoreDisplay> {
  bool _isLoading = false;
  Map<String, List<Score>> _scores;
  int totalScore = 0;
  @override
    void initState() {
      super.initState();
      _initData();
    }

    void _initData() async {
    setState(() => _isLoading = true);
    final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
     Map<String, List<Score>> fetchData = await ScoreRepo().getScoreMapByUser(loggedInUser.id);
     print("Fetched Dataaaaaaaaaaaaaaaaaaaaaaaaa ${fetchData}");
    
    setState(() {
        _scores = fetchData;
        _isLoading = false;
    });
    }

  @override
 Widget build(BuildContext context) {  
     if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    var user = AppStateContainer.of(context).state.loggedInUser;
    List<Widget> scoreWidgets = List<Widget>();

    Widget scoreHistory(String myUser, String otherUser, int myScore, int otherScore, String game, int playedAt) {
      totalScore = 0;
      if(otherUser == null) {
          return new Row(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0),
                child:new Container(
                   decoration:  new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    border: new Border.all(
                      width: 3.0,
                      color: Colors.black
                    )
                  ),
                child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: new FileImage(new File(user.image)),
                  ),
                ),
              ),
              Expanded(
                child: new Container(
                    child: new Text('${myScore}',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),), 
                  ),
              ),
            ],
          );
      } else {
          return new Row(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0),
                child:new Container(
                   decoration:  new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    border: new Border.all(
                      width: 3.0,
                      color: Colors.black
                    )
                  ),
                child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: new FileImage(new File(user.image)),
                  ),
                ),
              ),

              new Expanded(
                child: new Container(
                  child: otherScore == null ? new Text('0',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),)
                      :new Text('${myScore}',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),), 
                ),
              ),

              new Expanded(
                  child: new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 5.0),
                  child: myScore >= otherScore 
                  ? myScore == otherScore 
                        ?  new Text('Its a Tie...!!',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),) 
                          :  new Text('You Won...!!',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),) 
                  :  new Text('You Loose...!!',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),) 
                ),
              ),

              new Container(
                  child: new Text('${otherScore}',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),), 
                ),

              new Container(
                margin: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0),
                child:new Container(
                   decoration:  new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    border: new Border.all(
                      width: 3.0,
                      color: Colors.black
                    )
                  ),
                child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: new FileImage(new File(user.image)),
                  ),
                ),
              ),
            ],
          );
      }
    }

    _scores.forEach((k,v){  

      v.map((f){
        totalScore = totalScore + f.myScore;
      }).toList(growable: false);

        scoreWidgets.add(
          new Container(
            margin: const EdgeInsets.all(0.0),
            color: SingleGame.gameColors[k][0],
            child: ExpansionTile( 
              leading: Image.asset('assets/hoodie/${k}.png',scale: 5.0,),
              title: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      child: new Text('$k',textAlign: TextAlign.left, style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 5.0),
                    child: new Text('${totalScore}',style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),),
                  )
                ], 
              ),
              children: v.map((f){
                return scoreHistory(f.myUser, f.otherUser, f.myScore, f.otherScore, f.game, f.playedAt);
              }).toList(growable: false)
            ),
          )
        );
     });
    return new ListView(
      children: scoreWidgets
    );                  
  }
}