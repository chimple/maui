import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/drop_box.dart';
import 'package:tuple/tuple.dart';

class _QuestionDetail {
  String choice;
  Reaction reaction;
  bool appear;

  _QuestionDetail(
      {this.choice, this.appear = true, this.reaction = Reaction.enter});
  @override
  String toString() =>
      '_QuestionDetail(choice: $choice, appear: $appear, reaction: $reaction)';
}

class FillInTheBlanksGame extends StatefulWidget {
  final String question;
  final BuiltList<String> choices;
  final OnGameUpdate onGameUpdate;

  const FillInTheBlanksGame(
      {Key key, this.onGameUpdate, this.question, this.choices})
      : super(key: key);

  @override
  _FillInTheBlanksGameState createState() => _FillInTheBlanksGameState();
}

class _FillInTheBlanksGameState extends State<FillInTheBlanksGame> {
  List<_QuestionDetail> questionDetails = [];
  List<String> dragBoxData = [];
  List<String> questionWords = [];
  List<int> index = [];
  int complete = 0, score = 0;

  @override
  void initState() {
    super.initState();
    questionWords.addAll(widget.question.trim().split(' '));
    int i = 1;
    while (questionWords.contains('$i' + '_')) {
      complete++;
      index.add(questionWords.indexOf('$i' + '_'));
      i++;
    }
    dragBoxData = widget.choices.map((f) => f).toList(growable: false)
      ..shuffle();
    for (int p = 0, i = 1; p < questionWords.length; p++) {
      questionDetails.add(_QuestionDetail(
        choice: questionWords[p] == '$i' + '_'
            ? widget.choices[i - 1]
            : questionWords[p],
        appear: questionWords[p] == '$i' + '_' ? false : true,
      ));
      if (questionWords[p] == '$i' + '_') i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int i = 0;
    return Column(
      children: <Widget>[
        Expanded(
            flex: 3,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Wrap(
                    runSpacing: 18,
                    spacing: 12,
                    children: questionDetails
                        .map((f) => f.appear
                            ? Text(
                                f.choice,
                                textScaleFactor: width < 460 ? 1.8 : 2.5,
                                overflow: TextOverflow.ellipsis,
                                //  style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            : DropBox(
                                key: Key((i++).toString()),
                                child: Text(
                                  ' _________ ',
                                  textScaleFactor: width < 460 ? 1.8 : 2.5,
                                ),
                                onWillAccept: (data) =>
                                    data.substring(1) == f.choice,
                                onAccept: (data) {
                                  setState(() {
                                    score++;
                                    if (--complete == 0)
                                      widget.onGameUpdate(
                                          score: score,
                                          max: score,
                                          gameOver: true,
                                          star: true);
                                    f.reaction = Reaction.success;
                                    f.appear = true;
                                  });
                                }))
                        .toList(growable: false),
                  ),
                ))),
        Expanded(
          flex: 2,
          child: BentoBox(
            rows: 1,
            cols: dragBoxData.length,
            children: dragBoxData
                .map((c) => CuteButton(
                      key: Key((i++).toString() + c),
                      child: Center(child: Text(c)),
                    ))
                .toList(growable: false),
            dragConfig: DragConfig.draggableBounceBack,
          ),
        ),
      ],
    );
  }
}
