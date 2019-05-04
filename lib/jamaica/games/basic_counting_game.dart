import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/animated_scale.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  int choice;
  Reaction reaction;
  bool appear;
  _Escape escape;
  _ChoiceDetail(
      {this.choice,
      this.reaction,
      this.appear = true,
      this.escape = _Escape.no});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, reaction: $reaction, appear: $appear, escape: $escape)';
}

enum _Escape { no, escaping, escaped }

class BasicCountingGame extends StatefulWidget {
  final int answer;
  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;

  const BasicCountingGame(
      {Key key, this.answer, this.choices, this.onGameUpdate})
      : super(key: key);
  @override
  _BasicCountingGameState createState() => _BasicCountingGameState();
}

class _BasicCountingGameState extends State<BasicCountingGame> {
  List<_ChoiceDetail> choiceDetails;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c, reaction: Reaction.success))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> answers = [];
    for (var i = 0; i < widget.answer; i++) {
      answers.add(Expanded(
          child: Image.asset('assets/accessories/apple.png',
              fit: BoxFit.scaleDown)));
    }
    ;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Center(
              child: Row(
                children: answers,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: BentoBox(
            dragConfig: DragConfig.draggableBounceBack,
            rows: 3,
            cols: (choiceDetails.length / 3).round(),
            children: choiceDetails
                .map(
                  (c) => c.escape == _Escape.no
                      ? AnimatedScale(
                          key: Key(c.choice.toString()),
                          scale: c.appear ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: CuteButton(
                            child: Center(child: Text(c.choice.toString())),
                            onPressed: () {
                              setState(() {
//                              choiceDetails.forEach((cr) {
//                                cr.reaction = null;
//                                cr.appear = true;
//                                if (cr.choice != c.choice) {
//                                  cr.reaction = Reaction.failure;
//                                }
//                                if (cr.choice == c.choice) cr.appear = false;
//                              });
                                c.escape = _Escape.escaping;
                                Future.delayed(
                                    const Duration(milliseconds: 1000),
                                    () => setState(
                                        () => c.escape = _Escape.escaped));
                              });
                              return (c.choice == widget.answer)
                                  ? Reaction.success
                                  : Reaction.failure;
                            },
                            reaction: c.reaction,
                          ),
                        )
                      : Container(),
                )
                .toList(growable: false),
            frontChildren: choiceDetails
                .where((c) => c.escape == _Escape.escaping)
                .map((c) => AnimatedScale(
                      key: Key(c.choice.toString()),
                      scale: c.appear ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      child: CuteButton(
                        child: Center(child: Text(c.choice.toString())),
                        reaction: c.reaction,
                      ),
                    ))
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
