import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ResponsiveGridView extends StatelessWidget {
  List<Widget> children;
  final int cols;
  final int rows;
  final EdgeInsetsGeometry padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  ResponsiveGridView(
      {@required this.children,
      @required this.cols,
      @required this.rows,
      this.padding = const EdgeInsets.all(4.0),
      this.mainAxisSpacing = 4.0,
      this.crossAxisSpacing = 4.0,
      this.childAspectRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      bool portrait = constraints.maxHeight * cols > constraints.maxWidth * rows;
      if (!portrait) {
        var widgets = <Widget>[];
        for (int i = 0; i < cols; i++) {
          for (int j = 0; j < rows; j++) {
            widgets.add(children[j * cols + i]);
          }
        }
        print(widgets);
        children = widgets;
      }
      return new Center(
          child: new GridView.count(
              crossAxisCount: portrait ? cols : rows,
              shrinkWrap: true,
              padding: padding,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
              scrollDirection: portrait ? Axis.vertical : Axis.horizontal,
              children: children));
    });
  }
}
