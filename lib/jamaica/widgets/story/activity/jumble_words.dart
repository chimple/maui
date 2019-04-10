import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

TextStyle textStyle({double fSize = 25, color: Colors.red}) => TextStyle(
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

class JumbleWords extends StatefulWidget {
  final BuiltList choices;
  final BuiltList answers;
  final OnGameOver onGameOver;
  const JumbleWords({Key key, this.answers, this.choices, this.onGameOver})
      : super(key: key);

  @override
  _JumbleWordsState createState() => _JumbleWordsState();
}

class _JumbleWordsState extends State<JumbleWords> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;
  // final BuiltList<String> choices =
  //     BuiltList<String>(["He", 'Like', 'to', 'tease', 'peaope']);
  // final BuiltList<String> answers =
  //     BuiltList<String>(["He", 'Like', 'to', 'tease', 'peaope']);
  List<List<String>> addToBox = [];
  int complete, score = 0;
  List<bool> _colorStatus = [];
  @override
  void initState() {
    super.initState();
    int i = 0;
    int j = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c, index: i++))
        .toList(growable: false);
    complete = choiceDetails.length;
    answerDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, appear: false, index: j++))
        .toList(growable: false);
    for (int k = 0; k < answerDetails.length; k++) {
      addToBox.add([]);
      _colorStatus.add(true);
    }
  }

  Widget _dragTarget(String s, int index, bool c) {
    return DragTarget<String>(
        // key: Key('answer'),
        onAccept: (a) {
          if (a == s) {
            setState(() {
              answerDetails[widget.choices.indexOf(a)].appear = true;
              choiceDetails[widget.choices.indexOf(a)].appear = false;
            });
            score++;
            if (--complete == 0) {
              print('game over');
              widget.onGameOver(score);
            }
            // print('on accept ${widget.choices.indexOf(a)}, $answerDetails');
          }
        },
        onLeave: (s) {},
        onWillAccept: (data) => data == s,
        builder: (context, list, er) {
          return Container(
            child: Text(
              s,
              style: textStyle(
                  color: !c ? Colors.red[50] : Colors.red, fSize: textSize),
            ),
          );
        });
  }

  double textSize;
  @override
  Widget build(BuildContext context) {
    textSize = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width * .065
        : MediaQuery.of(context).size.height * .065;
    int index = 0;
    return Flow(
      // alignment: AlignmentDirectional.center,
      delegate: _FlowDelegate(),
      children: <Widget>[
        Center(
          child: Wrap(
            spacing: 15,
            children: answerDetails
                .map((s) => _dragTarget(s.choice, index++, s.appear))
                .toList(),
          ),
        ),
        BentoBox(
          calculateLayout: BentoBox.calculateOrderlyRandomizedLayout,
          dragConfig: DragConfig.draggableBounceBack,
          rows: 2,
          cols: 5,
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
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
