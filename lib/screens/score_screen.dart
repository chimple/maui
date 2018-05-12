import 'package:flutter/material.dart';
import 'package:maui/components/user_item.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/db/entity/user.dart';

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
              child: new Text("Score data", style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    ),
      ),);
  }
}

// class ScoreScreen extends StatelessWidget {
//   String gameName;
//   GameDisplay gameDisplay;
//   User myUser;
//   User otherUser;
//   int myScore;
//   int otherScore;
//   List<Widget> otherscore;

//   ScoreScreen(
//       {Key key,
//       this.gameName,
//       this.gameDisplay,
//       this.myUser,
//       this.otherUser,
//       this.myScore,
//       this.otherScore})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> scores = [
//       new Container(
//         child: new Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             new UserItem(user: myUser), 
//             new Text('$myScore')])
//       )];
//     if (otherUser != null) {
//       scores.add(new Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//         new UserItem(user: otherUser),
//         new Text('$otherScore')
//       ]));
//     }
//     return new Scaffold(
//         backgroundColor: Theme.of(context).primaryColor,
//         body: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               new Container(
//                 child: new Row(
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
                  
//                   //First user's score
//                 new Container(
//                   child: new Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: scores),
//                 ),
                
                
                
//                 //Stars Being Displayed according to the score
//                 myScore <= 10 ? new Container(
//                   child: new Column(
//                   children: <Widget>[
//                     new Row(
//                       children: <Widget>[
//                         new Icon(Icons.star),
//                         new Icon(Icons.star_border),
//                         new Icon(Icons.star_border),
//                         new Icon(Icons.star_border),
//                       ])])) : (myScore>10 && myScore<=20) ? new Container(
//                         child: new Column(
//                         children: <Widget>[
//                         new Row(
//                           children: <Widget>[
//                             new Icon(Icons.star),
//                             new Icon(Icons.star),
//                             new Icon(Icons.star_border),
//                             new Icon(Icons.star_border)
//                           ])])) :  (myScore>20 && myScore<=30) ? new Container(
//                             child: new Column(
//                             children: <Widget>[
//                               new Row(
//                                 children: <Widget>[
//                                     new Icon(Icons.star),
//                                     new Icon(Icons.star),
//                                     new Icon(Icons.star),
//                                     new Icon(Icons.star_border),
//                           ])]))  : new Container(
//                             child: new Column(
//                             children: <Widget>[
//                               new Row(
//                                 children: <Widget>[
//                                     new Icon(Icons.star),
//                                     new Icon(Icons.star),
//                                     new Icon(Icons.star),
//                                     new Icon(Icons.star),
//                           ])])), 

//                 //OtherUser's Score
//                 otherUser != null ? new Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: otherscore) : new Column(),
                
//                 ],
//               ),
//               ),  
              
//               new Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   new Container(
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: new Border.all(
//                         color: Colors.white,
//                         width: 2.5,
//                       ),
//                       color: Colors.white
//                     ),
//                     child: IconButton(
//                     icon: new Icon(Icons.home),
//                     onPressed: () => Navigator.of(context).pushNamed('/tab'),
//                   )
//                   ),
//                   new Container(
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: new Border.all(
//                         color: Colors.white,
//                         width: 2.5,
//                       ),
//                       color: Colors.white
//                     ),
//                     child: IconButton(
//                     icon: new Icon(Icons.fast_forward),
//                     onPressed: () => Navigator.of(context).pushNamed('/tab'),
//                   ),
//                   ),
                  
//                   new Container(
//                     decoration: new BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: new Border.all(
//                         color: Colors.white,
//                         width: 2.5,
//                       ),
//                       color: Colors.white
//                     ),
//                     child: IconButton(
//                     icon: new Icon(Icons.refresh),
//                     onPressed: () => Navigator.of(context).pushNamed('/tab'),
//                   ),
//                   ),
//                 ],
//               )
//             ]));
//   }
// }
