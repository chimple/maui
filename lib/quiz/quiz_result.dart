import 'package:flutter/material.dart';
import 'package:maui/components/expansionTile.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/quiz/match_the_following.dart';
import 'package:maui/quiz/multiple_choice.dart';
import 'package:maui/quiz/grouping_quiz.dart';
import 'package:maui/quiz/true_or_false.dart';
import 'package:maui/quiz/sequence.dart';
import 'quiz_pager.dart';

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
  double tileSize = 100.0;
  double buttonSize = 0.0;
  var countTile = 0;
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
            height: tileSize,
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

    widget.quizInputs.map((q) {
      buttonSize = buttonSize + tileSize;
      countTile = countTile + 1;
      _questionResults.add(
        _buildAskedQuestionExpandableTile(q, _quizIndex++, context),
      );
    }).toList(growable: false);
    double containerSize;
    double marginSide;
    double marginTop;
    if (buttonSize < size.height - media.size.height / 8.0) {
      containerSize = (size.height - media.size.height / 8.0 - buttonSize - 7)/1.5;
      marginSide = containerSize *0.18;
      marginTop = containerSize*0.1;
      print(
          "in if condition is....... ::$containerSize..... and margin is.....$marginSide");
      // containerSize = containerSize / 3;
      // marginSide = containerSize /2;
      marginTop = marginSide;
      if (containerSize <= tileSize) {
        containerSize = 100.0;
       marginSide = containerSize *0.18;
      marginTop = containerSize*0.1;
      }
      print("afetr some diving hieght is.....::$containerSize");
    } else {
      print("else is........");
      containerSize = tileSize;
     marginSide = containerSize *0.18;
      marginTop = containerSize*0.1;
    }

    print(
        "its my width margin is.........::$marginSide........... container hiegt...::$containerSize.");
    print(
        "hieght of the button is,....::$buttonSize......... real hieght is.......::${size.height}");
    _questionResults.add(Container(
      height: containerSize,
      alignment: Alignment.bottomCenter,
      // padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(
        left: marginSide, right: marginSide,
        top: marginTop,
        // bottom: marginTop
      ),
      child: GestureDetector(
        onTap: () {
          widget.onEnd();
          widget.onScore(scoreIs);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80.0,
            width: media.size.height /3,
            // color: Colors.white,
            decoration: new BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
            ),

            child: Center(child: Text("Next")),
          ),
        ),
      ),
    ));

    return _questionResults;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _buildListOfQuestionsAsked(context),
    );
  }
}
