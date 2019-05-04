import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  int index;

  _ChoiceDetail({this.choice, this.reaction = Reaction.success, this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, reaction: $reaction, index: $index)';
}

class OrderItGame extends StatefulWidget {
  final List<String> answers;

  const OrderItGame({Key key, this.answers}) : super(key: key);

  @override
  _OrderItGameState createState() => _OrderItGameState();
}

class _OrderItGameState extends State<OrderItGame> {
  List<_ChoiceDetail> choiceDetails;
  var score = 0;
  int complete;

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, index: i++))
        .toList()
          ..shuffle();
    complete = choiceDetails.length;
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      calculateLayout: BentoBox.calculateVerticalLayout,
      axis: Axis.vertical,
      dragConfig: DragConfig.draggableBounceBack,
      cols: 1,
      rows: choiceDetails.length,
      children: choiceDetails
          .map((c) => CuteButton(
                key: Key(c.index.toString()),
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) =>
                      Center(child: Text(c.choice)),
                  // onWillAccept: (data) => true,
                  onAccept: (data) {
                    setState(() {
                      if (data != null) {
                        score++;
                        print("this my score$score");
                        if (--complete == 0)
                          // widget.onGameUpdate(score);
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(() {
                                    int currentIndex = choiceDetails.indexWhere(
                                        (ch) =>
                                            ch.index.toString() ==
                                            c.index.toString());
                                    int droppedIndex = choiceDetails.indexWhere(
                                        (ch) => ch.index.toString() == data);
                                    final droppedChoice =
                                        choiceDetails[droppedIndex];
                                    choiceDetails.removeAt(droppedIndex);
                                    choiceDetails.insert(
                                        currentIndex, droppedChoice);
                                  }));
                      } else
                        score--;
                    });
                  },
                ),
              ))
          .toList(growable: false),
    );
  }
}
