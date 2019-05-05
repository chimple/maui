import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

TextStyle textStyle({double fSize = 30, color: Colors.red}) => TextStyle(
        fontSize: fSize,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.black,
          )
        ]);

class _ChoiceDetail {
  String choice;
  int index;
  bool appear;

  _ChoiceDetail({this.choice, this.appear = true, this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear,index: $index, )';
}

class MovingTextGame extends StatefulWidget {
  final BuiltList<String> choices;
  final BuiltList<String> answers;
  final OnGameUpdate onGameUpdate;
  const MovingTextGame({Key key, this.answers, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _MovingTextGameState createState() => _MovingTextGameState();
}

class _MovingTextGameState extends State<MovingTextGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;

  List<List<String>> addToBox = [];
  int complete, score = 0, max = 0;
  double textSize = 50;
  @override
  void initState() {
    super.initState();
    int i = 0;
    int j = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c, index: i++))
        .toList(growable: false);
    answerDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, appear: false, index: j++))
        .toList(growable: false);
    complete = answerDetails.length;
    max = complete;
  }

  Widget _dragTarget(String s, int index, bool c) {
    return DragTarget<String>(
        // key: Key('answer'),
        onAccept: (a) {
          if (a == s) {
            score = score + 2;
            widget.onGameUpdate(
                score: score, max: max * 2, gameOver: false, star: true);
            setState(() {
              answerDetails[widget.choices.indexOf(a)].appear = true;
              choiceDetails[widget.choices.indexOf(a)].appear = false;
            });
            if (--complete == 0) {
              print('game over');
              widget.onGameUpdate(
                  score: score, max: max * 2, gameOver: true, star: true);
            }
          }
        },
        onLeave: (s) {},
        onWillAccept: (data) {
          if (data == s)
            return true;
          else {
            score--;
            if (score <= 0) score = 0;
            widget.onGameUpdate(
                score: score, max: max * 2, gameOver: false, star: false);
            return false;
          }
        },
        builder: (context, list, er) {
          return Container(
            child: Text(
              s,
              style: textStyle(
                  color: !c ? Colors.white : Colors.red, fSize: textSize),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // var maxChars = (widget.choices != null
    //     ? widget.choices .fold(
    //         1, (prev, element) => element.length > prev ? element.length : prev)
    //     : 1);
    // textSize = MediaQuery.of(context).orientation == Orientation.portrait
    //     ? MediaQuery.of(context).size.width * .065
    //     : MediaQuery.of(context).size.height * .065;
    //     textSize=textSize/maxChars*2;
    int index = 0;
    return Flow(
      delegate: _FlowDelegate(),
      children: <Widget>[
        Center(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 15,
            children: answerDetails
                .map((s) => _dragTarget(s.choice, index++, s.appear))
                .toList(),
          ),
        ),
        BentoBox(
          calculateLayout: BentoBox.calculateOrderlyRandomizedLayout,
          dragConfig: DragConfig.draggableBounceBack,
          rows: max,
          cols: max + 1,
          children: choiceDetails
              .map((c) => c.appear
                  ? CuteButton(
                      cuteButtonType: CuteButtonType.text,
                      key: Key("${(c.choice)}"),
                      child: Material(
                          color: Colors.transparent,
                          child: Text(c.choice,
                              style: textStyle(
                                  color: Colors.red, fSize: textSize))))
                  : Container(
                      key: Key("${(index).toString()}"),
                    ))
              .toList(growable: false),
        )
      ],
    );
  }
}

class _FlowDelegate extends FlowDelegate {
  final int index;
  _FlowDelegate({this.index});
  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++)
      context.paintChild(i,
          transform: Matrix4.translationValues(0.0, 0.0, 0.0));
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => true;
}
