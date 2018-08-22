import 'package:flutter/material.dart';
import 'package:maui/components/expansionTile.dart';

class QuizResult extends StatefulWidget {
  List<Map<String, dynamic>> quizInputs;

  QuizResult({Key key, this.quizInputs}) : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  GlobalKey<ControlledExpansionTileState> currentExpandedTile;

  Widget _buildAskedQuestionExpandableTile(Map<String, dynamic> q) {
    GlobalKey<ControlledExpansionTileState> expansionKey =
        new GlobalObjectKey(q['question']);
    return new Container(
      margin: new EdgeInsets.all(2.0),
      color: Colors.teal,
          child: new ControlledExpansionTile(
        key: expansionKey,
        onExpansionChanged: (bool value) {
          if (value) {
            if (currentExpandedTile != null) {
              currentExpandedTile.currentState?.handleTap();
            }
            currentExpandedTile = expansionKey;
          } else {
            currentExpandedTile = null;
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
          new Container(
            height: 500.0,
            color: Colors.yellow,
            child: new Center(child: new Text("data")),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListOfQuestionsAsked() {
    List<Widget> _questionResults = [];
    widget.quizInputs
        .map(
          (q) => _questionResults.add(
                _buildAskedQuestionExpandableTile(q),
              ),
        )
        .toList(growable: false);

    return _questionResults;
  }

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      shrinkWrap: false,
      primary: true,
      controller: null,
      slivers: <Widget>[
        new SliverList(
          delegate: new SliverChildListDelegate(_buildListOfQuestionsAsked()),
        ),
      ],
    );
  }
}
