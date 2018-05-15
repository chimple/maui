import 'dart:math';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ResponsiveGridView extends StatefulWidget {
  final List<Widget> children;
  final int cols;
  final int rows;
  final double padding;
  final double maxAspectRatio;

  ResponsiveGridView(
      {Key key,
      @required this.children,
      @required this.cols,
      @required this.rows,
      this.padding = 0.0,
      this.maxAspectRatio})
      : super(key: key);

  @override
  ResponsiveGridViewState createState() {
    return new ResponsiveGridViewState();
  }
}

class ResponsiveGridViewState extends State<ResponsiveGridView>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = new List<AnimationController>();
  List<Animation<double>> _animations = new List<Animation<double>>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.rows; i++) {
      final _controller = new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 500));
      _controllers.add(_controller);
      _animations.add(
          new CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
      new Future.delayed(Duration(milliseconds: 500 + (i) * 300), () {
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ResponsiveGridView.build');
    List<Widget> tableRows = new List<Widget>();
    for (var i = 0; i < widget.rows; ++i) {
      List<Widget> cells = widget.children
          .skip(i * widget.cols)
          .take(widget.cols)
          .toList(growable: false);
      tableRows.add(new ScaleTransition(
          scale: _animations[i],
          child: Row(
            children: cells,
            mainAxisAlignment: MainAxisAlignment.center,
          )));
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tableRows,
    );
  }

  @override
  void dispose() {
    _controllers.forEach((f) => f.dispose());
    super.dispose();
  }
}
