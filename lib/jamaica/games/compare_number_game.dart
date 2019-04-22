import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  String number;
  Reaction reaction;
  _Type type;
  int index;

  _ChoiceDetail({
    this.number,
    this.type = _Type.choice,
    this.reaction = Reaction.success,
    this.index,
  });
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, type: $type, index: $index, reaction: $reaction)';
}

enum _Type { choice, question, answer }

class CompareNumberGame extends StatefulWidget {
  final String image;
  final List<String> choices;
  final String answer;
  final OnGameOver onGameOver;
  const CompareNumberGame(
      {Key key, this.image, this.choices, this.answer, this.onGameOver})
      : super(key: key);
  @override
  _CompareNumberGameState createState() => _CompareNumberGameState();
}

class _CompareNumberGameState extends State<CompareNumberGame>
    with SingleTickerProviderStateMixin {
  List<_ChoiceDetail> choiceDetails;
  _ChoiceDetail answerDetails;
  Animation<double> _animation;
  AnimationController _animationController;
  List<String> dragOperator = [">", "=", "<"];
  var questionList = [];
  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = dragOperator
        .map((c) => _ChoiceDetail(number: c, index: i++))
        .toList(growable: false);
    answerDetails =
        _ChoiceDetail(number: widget.answer, index: 99, type: _Type.question);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    _animation = Tween<double>(begin: 1.0, end: -4.0).animate(
      new CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceInOut,
      ),
    );
    ;
    _animation.addListener(() {
      setState(() {});
    });

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // _animationController
        //     .reverse(); //reverse the animation back here if its completed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> splitTheChoicesFirst = [];
    List<String> splitTheChoicesSecond = [];
    for (int j = 0; j < widget.choices[0].length; j++) {
      splitTheChoicesFirst.add(widget.choices[0][j]);
    }
    for (int k = 0; k < widget.choices[1].length; k++) {
      splitTheChoicesSecond.add(widget.choices[1][k]);
    }
    return BentoBox(
        dragConfig: DragConfig.draggableBounceBack,
        rows: 1,
        cols: choiceDetails.length,
        children: choiceDetails
            .map((c) => c.type == _Type.choice
                ? CuteButton(key: Key(c.number), child: Text(c.number))
                : Container())
            .toList(growable: false),
        qCols: 3,
        qRows: 1,
        qChildren: [
          Container(
            key: Key("data1"),
            child: Padding(
              padding: widget.answer == '>'
                  ? 8.0 * _animation.value >= 0
                      ? EdgeInsets.all(8.0 * _animation.value)
                      : EdgeInsets.all(0.0)
                  : EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: splitTheChoicesFirst
                          .map((e) => _buildWidget(e, widget.image))
                          .toList()),
                ),
              ),
            ),
          ),
          Padding(
            key: Key('ch'),
            padding: const EdgeInsets.all(8.0),
            child: DragTarget<String>(
              key: Key('choice'),
              builder: (context, candidateData, rejectedData) => Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: answerDetails.type == _Type.answer
                        ? Center(child: Text(widget.answer))
                        : Container(),
                  ),
              onWillAccept: (data) {
                print(data);

                return data == widget.answer;
              },
              onAccept: (data) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() => answerDetails.type = _Type.answer));
                setState(() {
                  choiceDetails.forEach((c) {
                    if (c.number == data) {
                      c.type = _Type.question;
                      _animationController.forward();
                    }
                  });
                });

                widget.onGameOver(1);
              },
            ),
          ),
          Container(
            key: Key("data2"),
            child: Padding(
              padding: widget.answer == '<'
                  ? 8.0 * _animation.value >= 0
                      ? EdgeInsets.all(8.0 * _animation.value)
                      : EdgeInsets.all(0.0)
                  : EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: splitTheChoicesSecond
                            .map((e) => _buildWidget(e, widget.image))
                            .toList())),
              ),
            ),
          ),
        ]);
  }

  Widget _buildWidget(String e, String image) {
    var value = int.tryParse(e);
    Widget widget;
    if (value != null) {
      List listWidget = new List(value);
      widget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List<Widget>.generate(
              5,
              (i) => i < listWidget.length
                  ? Image.asset(
                      image,
                      height: 30.0,
                      width: 30.0,
                    )
                  : Container(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              5,
              (i) => i < listWidget.length - 5
                  ? Image.asset(
                      image,
                      height: 30.0,
                      width: 30.0,
                    )
                  : Container(),
            ),
          ),
        ],
      );
    } else {
      widget = Text(e);
    }
    return widget;
  }
}
