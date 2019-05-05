import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
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
  final OnGameUpdate onGameUpdate;

  const UnitGame({
    Key key,
    this.question,
    this.onGameUpdate,
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
  String statusKind = '';
  Timer timer;
  List<String> noDragItems = [];

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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
    double bottom = 0.0;
    String status;
    while (i < item.currentValue) {
      bottom =
          i == 0 ? 0.1 : item.position == 'H' ? i * height * .14 : i * 18.0;
      widgets.add(Positioned(
          left: 0.0,
          right: 0.0,
          bottom: bottom,
          child: positionCard(item.position, height)));
      i++;
    }

    if (item.currentValue > 0 && statusKind == item.position) {
      if (item.position == 'H')
        status = (item.currentValue * 100).toString();
      else if (item.position == 'T')
        status = (item.currentValue * 10).toString();
      else
        status = item.currentValue.toString();
      widgets.add(Positioned(
          bottom:
              10 + bottom + (item.position == 'H' ? height : 15 + height / 10),
          child: Container(
            height: 25,
            alignment: Alignment(0, 0),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              status,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )));
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
        padding: EdgeInsets.symmetric(
            horizontal: data != 'U' ? otherBoxWidth * .018 : 0,
            vertical: height * .01),
        child: Container(
          height: height * .08,
          width: height * .08,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: height,
          width: width,
          margin: EdgeInsets.symmetric(vertical: data == 'H' ? 2 : 10),
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
          maxSimultaneousDrags:
              (item.choice == -1 || noDragItems.contains(item.position))
                  ? 0
                  : 1,
          child: positionCard(item.position, height * .6),
          feedback: positionCard(item.position, height * .6),
        ),
      ),
    );
  }

  _removeBadge(String kind) {
    if (timer != null) timer.cancel();
    timer = Timer(Duration(seconds: 1), () {
      setState(() {
        statusKind = '';
      });
    });
  }

  Widget _dragTarget(item, height) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) => InkWell(
          onTap: () => item.currentValue > 0
              ? setState(() {
                  statusKind = item.position;
                  _removeBadge(item.position);
                  noDragItems.remove(item.position);
                  item.currentValue--;
                })
              : null,
          child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: _widgetItem(item, height * .4)))),
      onWillAccept: (String data) =>
          data == item.position && item.currentValue < 9,
      onAccept: (String data) => setState(() {
            statusKind = data;
            _removeBadge(data);
            item.currentValue++;
            if (item.currentValue == 9) noDragItems.add(data);
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
                              child:
                                  _dragTarget(f, constraints.maxHeight * .6)))
                          .toList()),
                  TableRow(
                      children: choiceDetails
                          .map((f) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * .02),
                              child: _draggable(f, constraints.maxHeight * .4)))
                          .toList()),
                ],
              );
            }),
          ),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(maxHeight: 50),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                child: InkWell(
                    child: FittedBox(
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
                        widget.onGameUpdate(
                            score: score,
                            max: score,
                            gameOver: true,
                            star: true);
                      } else
                        score--;
                    }),
              )),
        ),
      ]),
    );
  }
}
