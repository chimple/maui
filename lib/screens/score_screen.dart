import 'package:flutter/material.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/db/entity/user.dart';

class ScoreScreen extends StatelessWidget {
  String gameName;
  GameDisplay gameDisplay;
  User myUser;
  User otherUser;
  int myScore;
  int otherScore;

  ScoreScreen(
      {Key key,
      this.gameName,
      this.gameDisplay,
      this.myUser,
      this.otherUser,
      this.myScore,
      this.otherScore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> scores = [
      new Column(
          children: <Widget>[new UserItem(user: myUser), new Text('$myScore')])
    ];
    if (otherUser != null) {
      scores.add(new Column(children: <Widget>[
        new UserItem(user: myUser),
        new Text('$myScore')
      ]));
    }
    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: scores),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: new Icon(Icons.home),
                    onPressed: () => Navigator.of(context).pushNamed('/tab'),
                  )
                ],
              )
            ]));
  }
}
