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
  List<Animation<Offset>> _animations = new List<Animation<Offset>>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.rows; i++) {
      final _controller = new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 500));
      _controllers.add(_controller);
      final CurvedAnimation curve =
          new CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
      _animations.add(new Tween<Offset>(
              begin: Offset(0.0, -2.0 * widget.rows), end: Offset(0.0, 0.0))
          .animate(curve));
      new Future.delayed(Duration(milliseconds: 500 + (widget.rows - i) * 300),
          () {
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
      tableRows.add(new SlideTransition(
          position: _animations[i],
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
