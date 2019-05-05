import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';

class RulerGame extends StatefulWidget {
  final OnGameUpdate onGameUpdate;
  final List<String> sequence;
  final List<int> blankPosition;
  final List<int> answer;
  const RulerGame(
      {Key key,
      this.onGameUpdate,
      this.sequence,
      this.blankPosition,
      this.answer})
      : super(key: key);
  @override
  _RulerGameState createState() => _RulerGameState();
}

enum DraggableStatus {
  active,
  draggable,
  dragTarget,
}

class _RulerGameState extends State<RulerGame> {
  List<String> sequenceData = [];
  List<DraggableStatus> _statuses;
  List<String> formatData = [];
  List<Offset> offsets = [];
  List<int> ansDataDragging = [];
  bool translateAnimation = false;
  int maxScore;
  int score = 0;
  int wrongAttempt = 0;
  @override
  void initState() {
    super.initState();
    widget.answer.forEach((e) {
      ansDataDragging.add(e);
    });
    widget.sequence.forEach((e) {
      formatData.add(e);
      sequenceData.add(e);
    });
    maxScore = 2 * widget.blankPosition.length;
    _statuses = widget.answer
        .map((a) => DraggableStatus.active)
        .toList(growable: false);
    widget.blankPosition.forEach((e) {
      sequenceData.removeAt(e);
      sequenceData.insert(e, "?");
    });
  }

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print("..........${media.size.width}");
    double yAxis = media.size.height / 2;
    double xAxis = media.size.width / (ansDataDragging.length + 1);
    for (int i = 1; i <= ansDataDragging.length; i++) {
      offsets.add(Offset(xAxis * i, yAxis));
    }
    int j = 0, k = 0;
    double rulerHeight = media.size.height * 0.13;
    double fontSize = rulerHeight * 0.2;
    return Stack(children: [
      Positioned(
        top: media.size.height / 4,
        left: 0.0,
        child: SizedBox(
          height: rulerHeight,
          width: media.size.width,
          child: Card(
              color: Colors.pink,
              margin: EdgeInsets.all(5.0),
              child: Column(children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  child: Row(
                    children: sequenceData
                        .map((e) => _buildTarget(
                              e,
                              j,
                              formatData[j++],
                              fontSize,
                            ))
                        .toList(),
                  ),
                ),
              ])),
        ),
      ),
      Stack(
        children: ansDataDragging
            .map((e) => _buildDragable(
                  e,
                  k,
                  _statuses[k++],
                  fontSize,
                ))
            .toList(),
        // dragableChild,
      )
    ]);
  }

  Widget _buildTarget(String e, int index, String val, double fontSize) {
    return Expanded(
      flex: 1,
      child: DragTarget(
        builder: (context, List candidateData, rejectedData) => Column(
              children: <Widget>[
                Container(
                  child: e != val
                      ? Text(
                          "?",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "$val",
                          style: TextStyle(fontSize: fontSize),
                        ),
                ),
                Container(
                  height: fontSize - 1,
                  width: 2,
                  color: Colors.black,
                )
              ],
            ),
        onWillAccept: (values) {
          if (values.toString() == formatData[index]) {
            return true;
          } else {
            setState(() {
              print("wrong attept is....$wrongAttempt");
              // wrongAttempt = wrongAttempt + 1;

              translateAnimation = false;
            });
            return false;
          }
        },
        onAccept: (val) {
          setState(() {
            score = score + 2;
            int flag = 0;

            int ansIndex = ansDataDragging.indexOf(val);
            ansDataDragging.remove(val);
            ansDataDragging.insert(ansIndex, null);
            sequenceData.removeAt(index);
            sequenceData.insert(index, val.toString());
            sequenceData.forEach((e) {
              if (e == "?") {
                flag = 1;
              }
            });
            if (flag == 1) {
              setState(() {
                widget.onGameUpdate(
                    score: score, max: maxScore, gameOver: false, star: false);
              });
            } else {
              setState(() {
                widget.onGameUpdate(
                    score: score, max: maxScore, gameOver: true, star: true);
              });
            }
          });
        },
      ),
    );
  }

  Widget _buildDragable(e, int index, DraggableStatus status, double fontSize) {
    return AnimatedPositioned(
      top: offsets[index].dy,
      left: offsets[index].dx,
      duration:
          !translateAnimation ? Duration.zero : Duration(milliseconds: 500),
      child: Draggable(
        onDraggableCanceled: (v, o) {
          setState(() {
            translateAnimation = false;
          });
        },
        onDragEnd: (d) {
          wrongAttempt = wrongAttempt + 1;
          if (wrongAttempt <= 3) {
            setState(() {
              widget.onGameUpdate(
                  score: score - 1,
                  max: maxScore,
                  gameOver: false,
                  star: false);
            });
          } else {
            setState(() {
              widget.onGameUpdate(
                  score: score - 1, max: maxScore, gameOver: true, star: false);
            });
          }
          final currentOffset = Offset(offsets[index].dx, offsets[index].dy);
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                offsets[index] = currentOffset;
                translateAnimation = true;
              }));
          setState(() {
            offsets[index] = (context.findRenderObject() as RenderBox)
                .globalToLocal(d.offset);
          });
        },
        data: e,
        child: e == null
            ? Container()
            : Text(
                "$e",
                style: Theme.of(context).textTheme.display1,
              ),
        feedback: e == null
            ? Container()
            : Material(
                type: MaterialType.transparency,
                child: Text(
                  "$e",
                  style: TextStyle(fontSize: fontSize, color: Colors.black),
                )),
        childWhenDragging: Container(),
      ),
    );
  }
}
