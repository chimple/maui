import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/update_points.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_selection.dart';
import 'package:maui/repos/log_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:nima/nima_actor.dart';

class QuizResult extends StatefulWidget {
  final List<QuackCard> quizzes;
  final Map<String, List<QuizItem>> quizItemMap;
  final Map<String, List<QuizItem>> answersMap;
  final Map<String, List<QuizItem>> startChoicesMap;
  final Map<String, List<QuizItem>> endChoicesMap;

  const QuizResult(
      {Key key,
      this.quizzes,
      this.quizItemMap,
      this.answersMap,
      this.startChoicesMap,
      this.endChoicesMap})
      : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  int _expandedPanel = -1;
  int _textpanel = 0;
  String _animation = 'joy';
  bool paused = false;
  int score = 0;
  int total = 0;

  void _complete() {
    setState(() {
      paused = true;
      _animation = null;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.quizItemMap.forEach((k, v) {
      final correct = v.where((q) => q.status == QuizItemStatus.correct).length;
      final answer = v.where((q) => q.isAnswer).length;
      score += max(0, correct);
      total += answer;
    });
    writeLog('topic_score,$score,$total');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.dispatch<RootState>(context, UpdatePoints(points: score));
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    // var orient = orientation;
    var size = media.size;
    int index = 0;
    bool tileClick = false;
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  // color: Colors.green,

                  padding: EdgeInsets.only(bottom: 20.0),

                  height: Orientation.landscape == orientation
                      ? media.size.height * .9
                      : media.size.height * .55,

                  // margin: EdgeInsets.all(3.0),

                  child: Stack(
                    // overflow: Overflow.clip,

                    // fit: StackFit.expand,

                    children: <Widget>[
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: new Container(
                          // alignment: new FractionalOffset(0.0, 1.0),
                          child: FloatingActionButton(
                            heroTag: "Go to home",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            tooltip: 'Go to home',
                            child: Image.asset('assets/home_icon.png'),
                          ),
                        ),
                      ),
                      Transform.scale(
                        alignment: Alignment.center,
                        scale: .85,
                        child: Padding(
                          padding: new EdgeInsets.only(
                              right: media.size.width * 0.08),
                          child: new NimaActor(
                            "assets/quack",
                            alignment: Alignment.center,
                            paused: paused,
                            fit: BoxFit.scaleDown,
                            animation: _animation,
                            mixSeconds: 0.0,
                            completed: (_) => _complete(),
                          ),
                        ),
                      ),
                      total == 0
                          ? Container()
                          : Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Container(
                                height: 100.0,

                                width: 200.0,

                                // padding: EdgeInsets.only(bottom: 30.0),

                                decoration: ShapeDecoration(
                                    color: Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(40.0),
                                          right: Radius.circular(40.0)),
                                    )),
                                child: Center(
                                    child: Text(
                                  '$score / $total',
                                  style: TextStyle(
                                      fontSize: 40.0, color: Colors.white),
                                )),
                              ),
                            )
                    ],
                  ),
                ),
                Container(
                  height: media.size.height * .8,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        child: ExpansionPanelList(
                          expansionCallback: (int panelIndex, bool isExpanded) {
                            setState(() {
                              _expandedPanel = isExpanded ? -1 : panelIndex;
                              _textpanel = isExpanded ? -1 : panelIndex;
                            });
                          },
                          children: widget.quizzes
                              .where((q) => (q.type == CardType.question &&
                                  q.option != 'open'))
                              .map(
                                (q) => ExpansionPanel(
                                      isExpanded: (_expandedPanel == index++)
                                          ? true
                                          : false,
                                      headerBuilder: (BuildContext context,
                                              bool isExpanded) =>
                                          Container(
                                              height: 100.0,
                                              child: Center(
                                                  child: Text(q.title ?? ''))),
                                      body: Container(
                                        color: Colors.blueAccent,
                                        child: SizedBox(
                                          height: media.size.height,
                                          child: QuizSelection(
                                            quizItems: widget.quizItemMap[q.id],
                                            answers: widget.answersMap[q.id],
                                            startChoices:
                                                widget.startChoicesMap[q.id],
                                            endChoices:
                                                widget.endChoicesMap[q.id],
                                            resultMode: true,
                                          ),
                                        ),
                                      ),
                                    ),
                              )
                              .toList(growable: false),
                          animationDuration: Duration(milliseconds: 250),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   // color: Colors.green,

          //   padding: EdgeInsets.only(bottom: 20.0),
          //   height: media.size.height * .55,
          //   // margin: EdgeInsets.all(3.0),
          //   child: Stack(
          //     // overflow: Overflow.clip,

          //     // fit: StackFit.expand,
          //     children: <Widget>[
          //       Transform.scale(
          //         alignment: Alignment.center,
          //         scale: .85,
          //         child: new NimaActor(
          //           "assets/quack",

          //           alignment: Alignment.center,

          //           fit: BoxFit.scaleDown,

          //           animation: 'joy',

          //           mixSeconds: 0.0,

          //           // paused: true,
          //         ),
          //       ),
          //       Align(
          //         alignment: AlignmentDirectional.bottomCenter,
          //         child: Container(
          //           height: 100.0,

          //           width: 200.0,

          //           // padding: EdgeInsets.only(bottom: 30.0),

          //           decoration: ShapeDecoration(
          //               color: Colors.orangeAccent,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.horizontal(
          //                     left: Radius.circular(40.0),
          //                     right: Radius.circular(40.0)),
          //               )),

          //           child: Center(
          //               child: Text(
          //             "50",
          //             style: TextStyle(fontSize: 40.0, color: Colors.white),
          //           )),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Expanded(
          //   flex: 1,
          //   child: SingleChildScrollView(
          //     child: ExpansionPanelList(
          //       expansionCallback: (int panelIndex, bool isExpanded) {
          //         setState(() {
          //           _expandedPanel = isExpanded ? -1 : panelIndex;
          //         });
          //       },
          //       children: widget.quizzes
          //           .map(
          //             (q) => ExpansionPanel(
          //                   isExpanded: _expandedPanel == index++ ? true : false,
          //                   headerBuilder: (BuildContext context,
          //                           bool isExpanded) =>
          //                       InkWell(
          //                           onTap: () {
          //                             setState(() {
          //                               isExpanded = false;
          //                             });
          //                           },
          //                           child: Container(
          //                               height: 100.0,
          //                               child:
          //                                   Center(child: Text(q.title ?? '')))),
          //                   body: SizedBox(
          //                     height: media.size.height,
          //                     child: QuizSelection(
          //                       quizItems: widget.quizItemMap[q.id],
          //                       answers: widget.answersMap[q.id],
          //                       startChoices: widget.startChoicesMap[q.id],
          //                       endChoices: widget.endChoicesMap[q.id],
          //                       resultMode: true,
          //                     ),
          //                   ),
          //                 ),
          //           )
          //           .toList(growable: false),
          //       animationDuration: Duration(milliseconds: 250),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
