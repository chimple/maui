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
  List<Offset> finalOffsets = [];
  List<Offset> randomOffsets = [];
  List<Widget> widgets = [];
  int trackTheClick = 0;
  bool initialCalculation = false;
  bool clickOnScreenDelay = true;
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    var childWidth = size.height / 8;
    if (initialCalculation == false) {
      var rng = new Random();
      for (int i = 1; i <= 30; i++) {
        randomOffsets.add(Offset(
            (i ~/ 6) * childWidth, ((5 - 4) / 2 + (i % 6)) * childWidth));
      }
      print("lengfht of the offset...${randomOffsets.length}");
      for (int i = 1; i <= 10; i++) {
        int min = 1, max = randomOffsets.length - 1;
        int randomIndex = min + rng.nextInt(max - min);
        print("object..... offsets.....randomIndex...$randomIndex");
        finalOffsets.add(randomOffsets[randomIndex]);
        randomOffsets.removeAt(randomIndex);
        intialOffsets.add(Offset((i % 2) * size.width, (i % 3) * size.height));
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
        if (trackTheClick < widget.choice && clickOnScreenDelay) {
          initialCalculation = true;
          setState(() {
            clickOnScreenDelay = false;
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
        intialOffsets.removeAt(trackTheClick);
        intialOffsets.insert(trackTheClick, finalOffsets[trackTheClick]);
        widgets.removeAt(trackTheClick);
        widgets.insert(
            trackTheClick,
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              left: intialOffsets[trackTheClick].dx,
              top: intialOffsets[trackTheClick].dy,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: Card(
                      color: Colors.blue,
                      elevation: 10.0,
                      child: Center(child: Text("${trackTheClick + 1}..data"))),
                ),
              ),
            ));
        if (trackTheClick == widget.choice) {
          setState(() {
            widget.onGameUpdate(score: 2, max: 2, gameOver: true, star: true);
          });
        }
        trackTheClick = trackTheClick + 1;
      });
    });
    new Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        clickOnScreenDelay = true;
      });
    });
  }
}
