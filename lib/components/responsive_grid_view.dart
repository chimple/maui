import 'dart:math';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final int cols;
  final int rows;
  final double padding;
  final double maxAspectRatio;

  ResponsiveGridView(
      {@required this.children,
      @required this.cols,
      @required this.rows,
      this.padding = 0.0,
      this.maxAspectRatio});

  @override
  Widget build(BuildContext context) {
    print('ResponsiveGridView.build');
    List<Widget> tableRows = new List<Widget>();
    for (var i = 0; i < rows; ++i) {
      List<Widget> cells =
          children.skip(i * cols).take(cols).toList(growable: false);
      tableRows.add(new Row(
        children: cells,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tableRows,
    );
  }
}
