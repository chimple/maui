import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:maui/components/simple_drawing.dart';
import 'package:maui/jamaica/state/game_utils.dart';

class TracingAlphabetGame extends StatefulWidget {
  final List<String> alphabets;
  final OnGameOver onGameOver;
  TracingAlphabetGame({Key key, this.alphabets, this.onGameOver});

  @override
  _TracingAlphabetGameState createState() => _TracingAlphabetGameState();
}

class _TracingAlphabetGameState extends State<TracingAlphabetGame> {
  PaintController _controller;
  @override
  void initState() {
    super.initState();
    _controller = _newController();
  }

  PaintController _newController() {
    PaintController controller = new PaintController();
    controller.thickness = 10.0;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: GridView.count(
                    physics: new NeverScrollableScrollPhysics(),
                    key: new Key('tracing_alphabet'),
                    primary: true,
                    crossAxisCount: sqrt(widget.alphabets.length).toInt(),
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    // childAspectRatio: media.size.width / (media.size.height),
                    children: widget.alphabets
                        .map((t) => LayoutBuilder(builder:
                                (BuildContext context,
                                    BoxConstraints constraints) {
                              return Container(
                                // color: Colors.grey,
                                child: Center(
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      fontSize:
                                          orientation == Orientation.portrait
                                              ? constraints.maxHeight * .7
                                              : constraints.maxWidth * .7,
                                      foreground: Paint()
                                        ..strokeWidth = 2.0
                                        ..color = Colors.black
                                        ..style = PaintingStyle.stroke,
                                    ),
                                  ),
                                ),
                              );
                            }))
                        .toList(growable: false),
                  ),
                ),
              ),
              Center(
                child:AspectRatio(
                  aspectRatio: 1.0, 
                child: Painter(_controller)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
