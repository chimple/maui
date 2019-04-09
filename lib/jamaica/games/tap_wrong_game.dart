import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  bool appear;
  bool isWrong;

  _ChoiceDetail(
      {this.choice,
      this.appear = true,
      this.isWrong = true,
      this.reaction = Reaction.enter});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear,isWrong: $isWrong, reaction: $reaction)';
}

class TapWrongGame extends StatefulWidget {
  final String image;
  final List<String> answer;
  final List<String> wrongChoice;

  const TapWrongGame({Key key, this.image, this.answer, this.wrongChoice})
      : super(key: key);

  @override
  _TapWrongGameState createState() => _TapWrongGameState();
}

class _TapWrongGameState extends State<TapWrongGame> {
  List<_ChoiceDetail> choiceDetails;
  int complete = 0;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.answer
        .map((c) => _ChoiceDetail(choice: c, isWrong: false))
        .toList();
    int i = 0;
    int wlen = widget.wrongChoice.length;
    int index;

    while (i < wlen) {
      index = Random().nextInt(choiceDetails.length);
      choiceDetails.insert(
          index, _ChoiceDetail(choice: widget.wrongChoice[i], isWrong: true));
      i++;
    }
  }

  Widget _buildButton(int index, _ChoiceDetail c) {
    return !c.appear
        ? Container(key: Key((index).toString()))
        : CuteButton(
            key: Key((index).toString()),
            child: Center(child: Text(c.choice ?? '')),
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 2300), () {
                if (mounted)
                  setState(() {
                    if (c.isWrong) {
                      var temp = choiceDetails.removeAt(index);
                      if (complete % 2 == 0) {
                        choiceDetails.insert(0, temp);
                      } else
                        choiceDetails.add(temp);
                      complete++;
                      c.appear = false;
                      return Reaction.success;
                    } else {
                      c.reaction = Reaction.failure;
                      return c.reaction;
                    }
                  });
              });
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Column(children: [
      Expanded(
          child: Image.asset(
        widget.image,
        key: Key(widget.image),
      )),
      Expanded(
        child: BentoBox(
          rows: 1,
          cols: choiceDetails.length,
          children: choiceDetails.map((c) => _buildButton(i++, c)).toList(),
          dragConfig: DragConfig.fixed,
        ),
      )
    ]);
  }
}
