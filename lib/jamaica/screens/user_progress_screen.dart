import 'dart:math';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:data/models/game_config.dart';
import 'package:data/models/game_status.dart';
import 'package:maui/jamaica/screens/collection_progress_indicator.dart';

final BuiltMap<String, GameConfig> _games = BuiltMap<String, GameConfig>({
  'Match the shape': GameConfig((b) => b
    ..name = 'Match the shape'
    ..image = 'match_the_shape.png'
    ..levels = 10),
  'Match the following': GameConfig((b) => b
    ..name = 'Match the following'
    ..image = 'match_the_following.png'
    ..levels = 10),
  'Memory match': GameConfig((b) => b
    ..name = 'Memory match'
    ..image = 'memory_match.png'
    ..levels = 10),
  'Alphabet': GameConfig((b) => b
    ..name = 'Alphabet'
    ..image = 'alphabet.png'
    ..levels = 10),
  'Basic Addition': GameConfig((b) => b
    ..name = 'Basic Addition'
    ..image = 'basic_addition.png'
    ..levels = 10),
});

class UserProgressScreen extends StatelessWidget {
  final BuiltMap<String, GameStatus> gameStatuses;
  UserProgressScreen({
    Key key,
    this.gameStatuses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width / 5;
    double widthSize = width / 5;
    double fontSize = min(widthSize, 23.0);
    List<Widget> widget = [];
    gameStatuses.forEach((key, v) {
      _games.forEach((k, value) {
        if (key == k) {
          widget.add(Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width,
                  child: Center(
                    child: Column(children: [
                      Image.asset(
                        value.image,
                        height: width * .8,
                        width: width * .8,
                      ),
                      Container(
                        width: width * 0.8,
                        child: Center(
                          child: Text("$k",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: fontSize * .75)),
                        ),
                      ),
                    ]),
                  ),
                ),
                Container(
                  width: width,
                ),
                Container(
                  width: width * .8,
                  child: Center(
                    child: Text("${v.currentLevel}",
                        style:
                            TextStyle(color: Colors.grey, fontSize: fontSize)),
                  ),
                ),
                Container(
                  width: width * .8,
                  child: Center(
                    child: Text("${v.maxScore}",
                        style:
                            TextStyle(color: Colors.grey, fontSize: fontSize)),
                  ),
                ),
                Container(
                    width: width * 1.2,
                    child: Center(child: _buildStars(3, fontSize)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 2.0,
                left: 5.0,
              ),
              child: CollectionProgressIndicator(
                progress: v.currentLevel / v.highestLevel,
                color: Colors.red,
                width: size.width - 10,
              ),
            ),
          ]));
        }
      });
    });

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width,
            child: Center(
              child: Text("Games",
                  style:
                      TextStyle(color: Colors.grey[400], fontSize: fontSize)),
            ),
          ),
          Container(
            width: width,
          ),
          Container(
            width: width * .8,
            child: Center(
              child: Text("Level",
                  style:
                      TextStyle(color: Colors.grey[400], fontSize: fontSize)),
            ),
          ),
          Container(
            width: width * .8,
            child: Center(
              child: Text("Coins",
                  style:
                      TextStyle(color: Colors.grey[400], fontSize: fontSize)),
            ),
          ),
          Container(
              width: width * 1.2,
              child: Center(
                  child: Text("Best Star",
                      style: TextStyle(
                          color: Colors.grey[400], fontSize: fontSize))))
        ],
      ),
      Expanded(child: ListView(children: widget))
    ]);
  }

  _buildStars(int star, double fontSize) {
    List dotLists = new List(star);
    List<Widget> rows = new List<Widget>();
    // final String assetName = 'assets/star_svg.svg';

    for (var i = 0; i < 1 + 1; ++i) {
      List<Widget> cells = dotLists.skip(i * 5).take(5).map((e) {
        // return new SvgPicture.asset(
        //   assetName,
        //   height: fontSize,
        //   width: fontSize,
        // );
        return Icon(
          Icons.star,
          color: Colors.yellow,
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
