import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/models/display_item.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';
import 'package:maui/widgets/drop_box.dart';
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
  final BuiltList<DisplayItem> choices;
  final OnGameUpdate onGameUpdate;

  const FillInTheBlanksGame(
      {Key key, this.onGameUpdate, this.question, this.choices})
      : super(key: key);

  @override
  _FillInTheBlanksGameState createState() => _FillInTheBlanksGameState();
}

class _FillInTheBlanksGameState extends State<FillInTheBlanksGame> {
  List<_QuestionDetail> questionDetails = [];
  List<DisplayItem> dragBoxData = [];
  List<String> questionWords = [];
  List<int> index = [];
  int complete = 0, score = 0, tries = 0, total = 0;
  final int wrongAttempts = 2;

  @override
  void initState() {
    super.initState();
    questionWords.addAll(widget.question.trim().split(' '));
    int i = 1;
    while (questionWords.contains('$i' + '_')) {
      complete++;
      total++;
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
                                // onWillAccept: (data) =>
                                //     data.substring(1) == f.choice,
                                onAccept: (data) {
                                  if (data.substring(1) == f.choice)
                                    setState(() {
                                      score += 2;
                                      tries = 0;
                                      if (--complete == 0)
                                        widget.onGameUpdate(
                                            score: score,
                                            max: total * 2,
                                            gameOver: true,
                                            star: true);
                                      f.reaction = Reaction.success;
                                      f.appear = true;
                                    });
                                  else {
                                    score--;
                                    if (++tries == wrongAttempts)
                                      widget.onGameUpdate(
                                          score: score,
                                          max: total * 2,
                                          gameOver: true,
                                          star: false);
                                  }
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
                      key: Key((i++).toString() + c.item),
                      child: Center(child: Text(c.item)),
                    ))
                .toList(growable: false),
            dragConfig: DragConfig.draggableBounceBack,
          ),
        ),
      ],
    );
  }
}
