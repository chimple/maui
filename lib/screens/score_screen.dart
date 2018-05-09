import 'package:flutter/material.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/db/entity/user.dart';

class ScoreScreen extends StatelessWidget {
  User myUser;
  User otherUser;
  int myScore;
  int otherScore;

  ScoreScreen(
      {Key key, this.myUser, this.otherUser, this.myScore, this.otherScore})
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
                children: <Widget>[
                  new Padding(
                padding: new EdgeInsets.only(left: 10.0),
              ),

              new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: scores),
                
                new Padding(
                  padding: new EdgeInsets.only(right: 10.0),
                ),
                
                myScore > 0 ? {(myScore>10 && myScore<20) ? new Icon(Icons.home) : new Icon(icon)} : 
                ],
              ),  
              
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.5,
                      ),
                      color: Colors.white
                    ),
                    child: IconButton(
                    icon: new Icon(Icons.home),
                    onPressed: () => Navigator.of(context).pushNamed('/tab'),
                  )
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.5,
                      ),
                      color: Colors.white
                    ),
                    child: IconButton(
                    icon: new Icon(Icons.fast_forward),
                    onPressed: () => Navigator.of(context).pushNamed('/tab'),
                  ),
                  ),
                  
                  new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.5,
                      ),
                      color: Colors.white
                    ),
                    child: IconButton(
                    icon: new Icon(Icons.refresh),
                    onPressed: () => Navigator.of(context).pushNamed('/tab'),
                  ),
                  ),
                ],
              )
            ]));
  }
}
