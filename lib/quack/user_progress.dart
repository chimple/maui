import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_progress_indicator.dart';

class UserData {
  String gameName;
  String level;
  String coins;
  String star;
  String progress;
  Color color;
  UserData.fromJson(Map json) {
    this.gameName = json["Name"];
    this.level = json["Level"];
    this.coins = json["Coins"];
    this.star = json["Star"];
    this.progress = json["Progress"];
    this.color = json["Color"];
  }
}

class UserProgress extends StatelessWidget {
  final List<QuackCard> cards;

  UserProgress({Key key, this.cards}) : super(key: key);

  Map listOfGames = {
    "Users": [
      {
        "Name": "AAAAAA",
        "Progress": "0.1",
        "Level": "1",
        "Coins": "10",
        "Star": "3",
        "Color": Colors.pinkAccent,
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.2",
        "Level": "2",
        "Coins": "20",
        "Star": "3",
        "Color": Colors.green,
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.3",
        "Level": "3",
        "Coins": "20",
        "Star": "4",
        "Color": Colors.deepPurple,
      },
      {
        "Name": "AAAAAA",
        "Progress": "0.4",
        "Level": "1",
        "Coins": "10",
        "Star": "5",
        "Color": Colors.deepOrangeAccent,
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.5",
        "Level": "2",
        "Coins": "400",
        "Star": "3",
        "Color": Colors.brown,
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.6",
        "Level": "3",
        "Coins": "5",
        "Star": "4",
        "Color": Colors.yellow,
      },
      {
        "Name": "AAAAAA",
        "Progress": "0.3",
        "Level": "1",
        "Coins": "20",
        "Star": "3",
        "Color": Colors.cyanAccent,
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.8",
        "Level": "2",
        "Coins": "25",
        "Star": "3",
        "Color": Colors.amber,
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.9",
        "Level": "3",
        "Coins": "50",
        "Star": "4",
        "Color": Colors.pink,
      },
      {
        "Name": "AAAAAA",
        "Progress": "1.1",
        "Level": "1",
        "Coins": "30",
        "Star": "5",
        "Color": Colors.orange,
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.4",
        "Level": "2",
        "Coins": "20",
        "Star": "3",
        "Color": Colors.lime,
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.5",
        "Level": "3",
        "Coins": "20",
        "Star": "4",
        "Color": Colors.grey,
      },
    ]
  };
  UserData userData;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double width = size.width / 5;
    double widthSize = width / 5;
    double fontSize = min(widthSize, 30.0);

    return new ListView.builder(
        shrinkWrap: true,
        itemCount: listOfGames["Users"].length,
        itemBuilder: (BuildContext context, int index) {
          userData = new UserData.fromJson(listOfGames["Users"][index]);
          // return new Text("${userData.gameName}");

          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width,
                  child: Center(
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.access_alarm,
                            size: 75.0,
                            color: userData.color,
                          ),
                          // Image.asset("assets/apple.png"),
                          Text("${userData.gameName}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize * .5)),
                        ]),
                  ),
                ),
                Container(
                  width: width,
                ),
                Container(
                    width: width * .8,
                    child: Center(
                      child: Text("${userData.level}",
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize)),
                    )),
                Container(
                    width: width * .8,
                    child: Center(
                      child: Text("${userData.coins}",
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize)),
                    )),
                Container(
                    width: width * 1.2,
                    child: Center(child: _buildStars(userData.star, fontSize))),
              ],
            ),
            CollectionProgressIndicator(
              progress: double.tryParse(userData.progress),
              color: userData.color,
              width: size.width - 25,
            ),
          ]);
        });
  }

  _buildStars(String star, double fontSize) {
    int numberOfStar = int.parse(star);
    List dotLists = new List(numberOfStar);
    List<Widget> rows = new List<Widget>();
    final String assetName = 'assets/star_svg.svg';
    // final Widget svg = new SvgPicture.asset(
    //   assetName,
    //   // allowDrawingOutsideViewBox: false,
    //   color: Colors.yellow,
    // );

    for (var i = 0; i < 1 + 1; ++i) {
      List<Widget> cells = dotLists.skip(i * 5).take(5).map((e) {
        // return new Icon(
        //   Icons.star,
        //   color: Colors.yellow,
        //   size: fontSize,
        // );
        // return Container(child: svg);
        return new SvgPicture.asset(
          assetName,
          height: fontSize,
          width: fontSize,
          // color: Colors.yellow,
          // allowDrawingOutsideViewBox: true,
        );
      }).toList(growable: false);
      rows.add(Row(
        children: cells,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
    }

    return Column(
      children: rows,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
//TODO: Pass user's cards
// class UserProgress extends StatelessWidget {
//   final List<QuackCard> cards;

//   const UserProgress({Key key, this.cards}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context);
//     return new LayoutBuilder(
//       builder: (context, constraints) {
//         return ListView(
//             primary: true,
//             children: cards
//                 .map(
//                   (c) => Container(
//                         decoration: BoxDecoration(
//                             border: BorderDirectional(
//                                 bottom: BorderSide(
//                                     width: 2.0,
//                                     color: Colors.black.withOpacity(0.2)))),
//                         child: new Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             new Column(
//                               children: <Widget>[
//                                 new Container(
//                                   margin: EdgeInsets.only(
//                                       top: 4.0, bottom: 4.0, left: 15.0),
//                                   width: constraints.maxWidth * 0.21875,
//                                   height: constraints.maxHeight * 0.20902,
//                                   decoration: new BoxDecoration(
//                                     borderRadius:
//                                         new BorderRadius.circular(5.0),
//                                     border: new Border.all(
//                                         width: 3.0, color: Colors.grey),
//                                     shape: BoxShape.rectangle,
//                                   ),
//                                   child: new CardHeader(card: c),
//                                 ),
//                                 new Container(
//                                   margin: const EdgeInsets.only(
//                                       top: 4.0, bottom: 4.0, left: 15.0),
//                                   width: constraints.maxWidth * 0.21875,
//                                   child: new Text(
//                                     c.title,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: new TextStyle(
//                                         fontSize: 25.0,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Expanded(
//                                 child: new Padding(
//                               padding:
//                                   new EdgeInsets.only(left: 30.0, bottom: 25.0),
//                               child: CollectionProgressIndicator(
//                                 card: c,
//                               ),
//                             )),
//                           ],
//                         ),
//                       ),
//                 )
//                 .toList(growable: false));
//       },
//     );
//   }
// }
