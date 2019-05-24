import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';

class TappingGame extends StatefulWidget {
  const TappingGame({
    key,
    this.choice,
    this.onGameUpdate,
  }) : super(key: key);
  final int choice;
  final OnGameUpdate onGameUpdate;

  TappingGameState createState() => TappingGameState();
}

class TappingGameState extends State<TappingGame> {
  List<Offset> intialOffsets = [];
  List<Offset> destinationOffsets = [];
  List<Widget> widgets = [];
  int countTheClick = 0;
  bool withoutClick = false;
  bool clickOnScreen = true;
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    var childWidth = size.height / 8;
    Random random = Random();
    var childHeight = size.height / 4;
    if (withoutClick == false) {
      for (double i = 1; i <= 10; i++) {
        destinationOffsets.add(Offset(
            max(0, random.nextDouble() * size.width - childWidth),
            max(0, random.nextDouble() * size.height - childHeight)));
        intialOffsets.add(Offset((i % 2) * size.width, (i % 3) * size.height));
// Offset(
        //     (i ~/ 4) * childWidth, ((5 - 4) / 2 + (i % 4)) * childWidth)
        // Offset(max(0, random.nextDouble() * size.width - childWidth),
        //     max(0, random.nextDouble() * size.height - childHeight));
      }
      for (int i = 0; i < 10; i++) {
        widgets.add(AnimatedPositioned(
          duration: Duration.zero,
          left: intialOffsets[i].dx,
          top: intialOffsets[i].dy,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(),
          ),
        ));
      }
    }

    return GestureDetector(
      onTap: () {
        if (countTheClick < widget.choice && clickOnScreen) {
          withoutClick = true;
          setState(() {
            clickOnScreen = false;
          });
          _buildMovingWidget();
        }
      },
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Positioned(
              left: size.width / 2,
              top: 40.0,
              child: Text("clickAnyWhere...${widget.choice}..times")),
          widgets.isEmpty
              ? Container()
              : Stack(
                  children: widgets,
                )
        ],
      )),
    );
  }

  void _buildMovingWidget() {
    setState(() {
      setState(() {
        intialOffsets.removeAt(countTheClick);
        intialOffsets.insert(countTheClick, destinationOffsets[countTheClick]);
        widgets.removeAt(countTheClick);
        widgets.insert(
            countTheClick,
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              left: intialOffsets[countTheClick].dx,
              top: intialOffsets[countTheClick].dy,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Card(
                      color: Colors.blue,
                      elevation: 10.0,
                      child: Center(child: Text("${countTheClick + 1}..data"))),
                ),
              ),
            ));
        if (countTheClick == widget.choice) {
          setState(() {
            widget.onGameUpdate(score: 2, max: 2, gameOver: true, star: true);
          });
        }
        countTheClick = countTheClick + 1;
      });
    });
    new Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        clickOnScreen = true;
      });
    });
  }
}
