import 'dart:math';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final int maxChars;
  final int cols;
  final int rows;
  final double padding;
  final double maxAspectRatio;

  ResponsiveGridView(
      {@required this.children,
      @required this.cols,
      @required this.rows,
      this.padding = 4.0,
      this.maxChars = 24,
      this.maxAspectRatio});

  @override
  Widget build(BuildContext context) {
    print('ResponsiveGridView.build');
    return new LayoutBuilder(builder: (context, constraints) {
      print(constraints);
      List<Widget> tableRows = new List<Widget>();
      final aspectRatio = (constraints.maxWidth - padding * (cols + 1)) *
          rows /
          ((constraints.maxHeight - padding * (rows + 1)) * 0.85 * cols);
      final computedPadding =
          max(padding, constraints.maxWidth / 4.0 - 10.0 * maxChars);
      print(computedPadding);
      for (var i = 0; i < rows; ++i) {
        List<Widget> cells = children
            .skip(i * cols)
            .take(cols)
            .map((w) => new Expanded(
                child: new Padding(
                    padding: EdgeInsets.all(computedPadding / cols), child: w)))
            .toList(growable: false);
        tableRows.add(new Row(children: cells));
      }
      return new Padding(
          padding: EdgeInsets.all(padding),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tableRows,
          ));
    });
  }
}
