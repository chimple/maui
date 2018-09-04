import 'package:flutter/material.dart';
import 'package:maui/components/expansionTile.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/quiz_progress_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'quiz_pager.dart';
import 'package:uuid/uuid.dart';

class QuizResult extends StatefulWidget {
  List<Map<String, dynamic>> quizInputs;
  List<Quiz> quizzes;
  Function onEnd;
  Function onScore;
  QuizResult({Key key, this.quizInputs, this.quizzes, this.onEnd, this.onScore})
      : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  GlobalKey<ControlledExpansionTileState> _currentExpandedTile;
  var scoreIs = 0;
  Widget _buildAskedQuestionExpandableTile(
      Map<String, dynamic> q, int _quizIndex, BuildContext context) {
    scoreIs = scoreIs + _quizIndex;
    GlobalKey<ControlledExpansionTileState> _expandableTileKey =
        new GlobalObjectKey(q['question']);
    return new Container(
      margin: new EdgeInsets.all(2.0),
      color: Colors.white,
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
          QuizPager.createQuiz(
              quiz: widget.quizzes[_quizIndex],
              input: widget.quizInputs[_quizIndex],
              onEnd: null)
        ],
      ),
    );
  }

  List<Widget> _buildListOfQuestionsAsked(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    List<Widget> _questionResults = [];
    int _quizIndex = 0;
    widget.quizInputs
        .map(
          (q) => _questionResults.add(
                _buildAskedQuestionExpandableTile(q, _quizIndex++, context),
              ),
        )
        .toList(growable: false);
    _questionResults.add(Container(
      // width: 60.0,
      height: size.height / 8,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(50.0),
      child: Card(
        child: RaisedButton(
            color: Colors.green,
            onPressed: () {
              widget.onEnd();
              widget.onScore(scoreIs);
            },
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(16.0))),
            child: Center(child: Text("Next"))
//         new IconButton(
//   icon: new Icon(Icons.accessible_forward),
//   tooltip: 'Increase volume by 10%',
//   onPressed: () { setState(() {  },);}
// ),
            ),
      ),
    ));

    return _questionResults;
  }

  void _initQuizProgressTable() async {
    List<Map> quizInputsMapList = widget.quizInputs;
    List<Quiz> quizzesMapList = widget.quizzes;
    User _user = AppStateContainer.of(context).state.loggedInUser;
    print("lion material");
    for (var i = 0; i < quizInputsMapList.length; i++) {
      print(await new QuizProgressRepo().insertOrUpdateQuizProgress(
          Uuid().v4(),
          _user.id,
          quizzesMapList[0].topicId,
          quizzesMapList[0].type,
          quizInputsMapList[0]["correct"],
          quizInputsMapList[0]["total"]));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initQuizProgressTable();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _buildListOfQuestionsAsked(context),
    );
  }
}
