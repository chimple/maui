import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_progress_indicator.dart';

class UserData {
  String gameName;
  String level;
  String coins;
  String star;
  String progress;
  UserData.fromJson(Map json) {
    this.gameName = json["Name"];
    this.level = json["Level"];
    this.coins = json["Coins"];
    this.star = json["Star"];
    this.progress = json["Progress"];
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
        "Star": "3"
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.2",
        "Level": "2",
        "Coins": "20",
        "Star": "3"
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.3",
        "Level": "3",
        "Coins": "20",
        "Star": "4"
      },
      {
        "Name": "AAAAAA",
        "Progress": "0.4",
        "Level": "1",
        "Coins": "10",
        "Star": "5"
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.5",
        "Level": "2",
        "Coins": "40",
        "Star": "3"
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.6",
        "Level": "3",
        "Coins": "5",
        "Star": "4"
      },
      {
        "Name": "AAAAAA",
        "Progress": "0.3",
        "Level": "1",
        "Coins": "20",
        "Star": "3"
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.8",
        "Level": "2",
        "Coins": "25",
        "Star": "3"
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.9",
        "Level": "3",
        "Coins": "50",
        "Star": "4"
      },
      {
        "Name": "AAAAAA",
        "Progress": "1.1",
        "Level": "1",
        "Coins": "30",
        "Star": "5"
      },
      {
        "Name": "BBBBBB",
        "Progress": "0.4",
        "Level": "2",
        "Coins": "20",
        "Star": "3"
      },
      {
        "Name": "CCCCCC",
        "Progress": "0.5",
        "Level": "3",
        "Coins": "20",
        "Star": "4"
      },
    ]
  };
  UserData userData;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double width = size.width / 4;

    return new ListView.builder(
        shrinkWrap: true,
        itemCount: listOfGames["Users"].length,
        itemBuilder: (BuildContext context, int index) {
          userData = new UserData.fromJson(listOfGames["Users"][index]);
          // return new Text("${userData.gameName}");

          return Container(
              height: 180.0,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: width ,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: width,
                              child: Center(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          height: 100.0,
                                          width: width,
                                          color: Colors.teal,
                                          child: Icon(
                                            Icons.access_alarm,
                                            size: 75.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text("${userData.gameName}"),
                                      ),
                                    ]),
                              ),
                            ),
                            // Container(
                            //   width: width,
                            //   // margin:
                            //   //     EdgeInsets.only(bottom: 150 / 2.0),
                            //   child: CollectionProgressIndicator(
                            //     progress: double.tryParse(userData.progress),
                            //     width: width,
                            //   ),
                            // ),
                          ]),
                    ),
                    Container(
                        width: width,
                        child: Center(
                          child: Text("${userData.level}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        )),
                    Container(
                        width: width,
                        child: Center(
                          child: Text("${userData.coins}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        )),
                    Container(
                        width: width,
                        child: Center(child: _buildStars(userData.star))),
                  ],
                ),
                Container(
                  // margin:
                  //     EdgeInsets.only(bottom: 150 / 2.0),
                  child: CollectionProgressIndicator(
                    progress: double.tryParse(userData.progress),
                    width: size.width,
                  ),
                ),
              ]));
        });
  }

  _buildStars(String star) {
    int numberOfStar = int.parse(star);
    List dotLists = new List(numberOfStar);
    List<Widget> rows = new List<Widget>();

    for (var i = 0; i < 1 + 1; ++i) {
      List<Widget> cells = dotLists.skip(i * 5).take(5).map((e) {
        return new Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20.0,
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
