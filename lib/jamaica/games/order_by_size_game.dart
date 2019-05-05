import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;
  _Type type;

  _ChoiceDetail({
    this.number,
    this.type = _Type.choice,
    this.reaction = Reaction.enter,
  });
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, type: $type, reaction: $reaction)';
}

enum _Type { choice, answer }

class OrderBySizeGame extends StatefulWidget {
  final BuiltList<int> answers;
  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;

  const OrderBySizeGame(
      {Key key, this.answers, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _OrderBySizeGameState createState() => _OrderBySizeGameState();
}

class _OrderBySizeGameState extends State<OrderBySizeGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;
  var score = 0;
  int complete;

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c))
        .toList(growable: false);
    answerDetails = widget.answers
        .map((c) => choiceDetails.firstWhere((d) => d.number == c))
        .toList(growable: false);
    complete = answerDetails.length;
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      dragConfig: DragConfig.draggableBounceBack,
      rows: 1,
      cols: choiceDetails.length,
      children: choiceDetails
          .map((c) => c.type == _Type.choice
              ? CuteButton(
                  key: Key(c.number.toString()),
                  reaction: c.reaction,
                  child: Center(child: Text(c.number.toString())),
                )
              : Container())
          .toList(growable: false),
      qRows: 1,
      qCols: answerDetails.length,
      qChildren: answerDetails
          .map((a) => a.type == _Type.choice
              ? DragTarget<String>(
                  key: Key('choice_${a.number}'),
                  builder: (context, candidateData, rejectedData) => Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                      ),
                  onWillAccept: (data) {
                    return data == a.number.toString();
                  },
                  onAccept: (data) {
                    setState(() {
                      if (data == a.number.toString()) {
                        score++;
                        print("this my score$score");
                        if (--complete == 0)
                          widget.onGameUpdate(
                              score: score,
                              max: score,
                              gameOver: true,
                              star: true);
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => setState(() {
                                  a.type = _Type.answer;
                                  choiceDetails.forEach((c) => c.reaction =
                                      c.number == a.number
                                          ? Reaction.success
                                          : Reaction.enter);
                                }));
                      }
                      //  else
                      //   score--;
                    });
                  })
              : CuteButton(
                  key: Key(a.number.toString()),
                  reaction: a.reaction,
                  child: Center(child: Text(a.number.toString())),
                ))
          .toList(growable: false),
    );
  }
}
