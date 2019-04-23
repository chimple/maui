import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:maui/components/simple_drawing.dart';

class TracingAlphabet extends StatefulWidget {
  final List<String> alphabets;
  TracingAlphabet({Key key, this.alphabets});

  @override
  _TracingAlphabetState createState() => _TracingAlphabetState();
}

class _TracingAlphabetState extends State<TracingAlphabet> {
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
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              GridView.count(
                physics: new NeverScrollableScrollPhysics(),
                key: new Key('tracing_alphabet'),
                primary: true,
                crossAxisCount: sqrt(widget.alphabets.length).toInt(),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: media.size.width / (media.size.height),
                children: widget.alphabets
                    .map((t) => LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            color: Colors.grey,
                            child: Center(
                              child: Text(
                                t,
                                // style: Theme.of(context).textTheme.display4,
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: constraints.maxHeight * .7),
                              ),
                            ),
                          );
                        }))
                    .toList(growable: false),
              ),
              Painter(_controller),
            ],
          ),
        ),
      ],
    );
  }
}
