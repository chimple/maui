import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  int choice;
  Reaction reaction;
  String position;
  int currentValue;
  bool success;

  _ChoiceDetail(
      {this.choice,
      this.position,
      this.reaction = Reaction.success,
      this.currentValue = 0,
      this.success = false});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice,  position:$position,currentValue:$currentValue,success:$success , reaction: $reaction)';
}

class UnitGame extends StatefulWidget {
  final int question;
  final OnGameOver onGameOver;

  const UnitGame({
    Key key,
    this.question,
    this.onGameOver,
  }) : super(key: key);

  @override
  _UnitGameState createState() => _UnitGameState();
}

class _UnitGameState extends State<UnitGame> {
  List<_ChoiceDetail> choiceDetails = [];
  List<_ChoiceDetail> answerDetails = [];
  int score = 5;
  String displayText = '';
  double unitBoxWidth = 0.0;
  double otherBoxWidth = 0.0;

  @override
  void initState() {
    super.initState();
    displayText = widget.question.toString();
    int i = 0;
    int j = displayText.length - 1;
    String position = '';
    while (i < 3) {
      switch (i) {
        case 0:
          position = 'U';
          break;
        case 1:
          position = 'T';
          break;
        case 2:
          position = 'H';
          break;
        default:
      }

      int choice = j < 0 ? -1 : int.parse(displayText[j]);
      answerDetails.add(_ChoiceDetail(choice: choice, position: position));
      choiceDetails.add(_ChoiceDetail(choice: choice, position: position));
      j--;
      i++;
    }
    answerDetails = answerDetails.reversed.toList();
    choiceDetails = choiceDetails.reversed.toList();
  }

  Widget _gridView(rows, cols, children) {
    List<Widget> tableRows = new List<Widget>();
    for (var i = 0; i < rows; ++i) {
      List<Widget> cells =
          children.skip(i * cols).take(cols).toList(growable: false);
      tableRows.add(Row(
        children: cells,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tableRows,
    );
  }

  List<Widget> _widgetItem(var item, double height) {
    int i = 0;
    List<Widget> widgets = [];
    while (i < item.currentValue) {
      widgets.add(Positioned(
          left: 0.0,
          right: 0.0,
          bottom: i == 0 ? 0.5 : i * 8.0,
          child: positionCard(item.position, height)));
      i++;
    }
    return widgets;
  }

  Widget positionCard(String data, double height) {
    int rows;
    int cols;
    double width;
    List<Widget> children = [];
    int i = 0;
    Widget circle = Padding(
        padding: EdgeInsets.all(height * .005),
        child: Container(
          height: height * .07,
          width: height * .07,
          decoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ));

    switch (data) {
      case 'H':
        rows = 10;
        cols = 10;
        width = otherBoxWidth;
        while (i < 100) {
          children.add(circle);
          i++;
        }
        break;
      case 'T':
        rows = 1;
        cols = 10;
        width = otherBoxWidth;
        height /= 10;
        while (i < 10) {
          children.add(circle);
          i++;
        }
        break;
      case 'U':
        rows = 1;
        cols = 1;
        width = unitBoxWidth;

        height /= 10;
        children.add(circle);
        break;
      default:
    }
    return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: height,
          width: width,
          margin: EdgeInsets.symmetric(horizontal: height * .02, vertical: 10),
          child: Center(
            child: _gridView(rows, cols, children),
          ),
        ));
  }

  Widget _draggable(var item, double height) {
    return Padding(
      padding: EdgeInsets.only(top: height * .2),
      child: Opacity(
        opacity: item.choice == -1 ? 0.5 : 1,
        child: Draggable(
          data: item.position.toString(),
          maxSimultaneousDrags: item.choice == -1 ? 0 : 1,
          child: positionCard(item.position, height * .68),
          feedback: positionCard(item.position, height * .68),
        ),
      ),
    );
  }

  Widget _dragTarget(item, height) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) => InkWell(
          onTap: () => setState(() => item.currentValue--),
          child: Container(
              height: height,
              decoration: new BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.bottomCenter,
                  children: _widgetItem(item, height * .68)))),
      onWillAccept: (String data) =>
          data == item.position && item.currentValue < 10,
      onAccept: (String data) => setState(() {
            item.currentValue++;
            if (item.currentValue == item.choice)
              item.success = true;
            else
              item.success = false;
            score++;
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(children: [
        Expanded(
          child: Center(
            child: Text(
              displayText,
              textScaleFactor: 4.0,
              style:
                  TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              double boxWidth = constraints.maxWidth * 0.88;
              unitBoxWidth = boxWidth * .11;
              otherBoxWidth = boxWidth * .42;
              return Table(
                columnWidths: {2: FractionColumnWidth(.15)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                      children: answerDetails
                          .map((f) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * .02),
                              child: _dragTarget(f, constraints.maxHeight / 2)))
                          .toList()),
                  TableRow(
                      children: choiceDetails
                          .map((f) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * .02),
                              child: _draggable(f, constraints.maxHeight / 2)))
                          .toList()),
                ],
              );
            }),
          ),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: InkWell(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    onTap: () {
                      bool isComplete = true;
                      answerDetails.forEach((e) {
                        if (!e.success) isComplete = false;
                      });
                      print('submit btn $isComplete');
                      if (isComplete) {
                        score += 5;
                        widget.onGameOver(score);
                      } else
                        score--;
                    }),
              )),
        ),
      ]),
    );
  }
}
