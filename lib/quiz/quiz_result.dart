import 'package:flutter/material.dart';
import 'package:maui/components/expansionTile.dart';
import 'package:maui/quiz/match_the_following.dart';
import 'package:maui/quiz/multiple_choice.dart';
import 'package:maui/quiz/grouping_quiz.dart';
import 'package:maui/quiz/true_or_false.dart';
import 'package:maui/quiz/sequence.dart';

class QuizResult extends StatefulWidget {
  List<Map<String, dynamic>> quizInputs;

  QuizResult({Key key, this.quizInputs}) : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  GlobalKey<ControlledExpansionTileState> _currentExpandedTile;

  Widget _buildAskedQuestionExpandableTile(
      Map<String, dynamic> q, BuildContext context) {
    GlobalKey<ControlledExpansionTileState> _expandableTileKey =
        new GlobalObjectKey(q['question']);
    return new Container(
      margin: new EdgeInsets.all(2.0),
      color: Colors.teal,
      child: new ControlledExpansionTile(
        leading: new Icon(Icons.check),
        key: _expandableTileKey,
        onExpansionChanged: (bool value) {
          if (value) {
            if (_currentExpandedTile != null) {
              _currentExpandedTile.currentState?.handleTap();
            }
            _currentExpandedTile = _expandableTileKey;
          } else {
            _currentExpandedTile = null;
          }
        },
        title: new Padding(
          padding: new EdgeInsets.all(5.0),
          child: new Container(
            height: 100.0,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 4,
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,
                    ),
                    child: new Center(
                      child: Text(
                        q['question'],
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.rectangle,
                    ),
                    child: new Center(
                      child: Text(
                        '${q['correct']} / ${q['total']}',
                        style: new TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        children: <Widget>[
          new MatchingGame(
            gameData: q,
            onEnd: null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListOfQuestionsAsked(BuildContext context) {
    List<Widget> _questionResults = [];
    widget.quizInputs
        .map(
          (q) => _questionResults.add(
                _buildAskedQuestionExpandableTile(q, context),
              ),
        )
        .toList(growable: false);

    return _questionResults;
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>...................<<<<<<<<<<<<<<<<<<,,");
    print(widget.quizInputs);
    return new ListView(
      children: _buildListOfQuestionsAsked(context),
    );
  }
}
