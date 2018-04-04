import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class ReactiveGridView extends StatelessWidget {
  List<Widget> children;
  final int rows;
  final int cols;
  final EdgeInsetsGeometry padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  ReactiveGridView(
      {@required this.children,
      @required this.rows,
      @required this.cols,
      this.padding = const EdgeInsets.all(4.0),
      this.mainAxisSpacing = 4.0,
      this.crossAxisSpacing = 4.0,
      this.childAspectRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      bool portrait = constraints.maxHeight > constraints.maxWidth;
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
              crossAxisCount: portrait ? rows : cols,
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
