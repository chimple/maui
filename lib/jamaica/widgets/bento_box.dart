import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

enum DragConfig {
  fixed,
  draggableBounceBack,
  draggableNoBounceBack,
  draggableMultiPack
}

typedef CalculateLayout = void Function({
  int cols,
  int rows,
  List<Widget> children,
  int qCols,
  int qRows,
  List<Widget> qChildren,
  Map<Key, BentoChildDetail> childrenMap,
  Size size,
});

class BentoBox extends StatefulWidget {
  final List<Widget> children;
  final List<Widget> qChildren;
  final List<Widget> frontChildren;
  final int cols;
  final int rows;
  final int qCols;
  final int qRows;
  final CalculateLayout calculateLayout;
  final Axis axis;
  final DragConfig dragConfig;
  final bool grid;

  const BentoBox(
      {Key key,
      this.cols,
      this.rows,
      this.children,
      this.calculateLayout = calculateVerticalLayout,
      this.axis,
      this.dragConfig = DragConfig.fixed,
      this.frontChildren,
      this.qChildren,
      this.qCols = 0,
      this.qRows = 0,
      this.grid = false})
      : super(key: key);

  @override
  _BentoBoxState createState() => _BentoBoxState();

  static calculateVerticalLayout(
      {int cols,
      int rows,
      List<Widget> children,
      int qCols,
      int qRows,
      List<Widget> qChildren,
      Map<Key, BentoChildDetail> childrenMap,
      Size size}) {
    final allRows = rows + qRows;
    final allCols = max(cols, qCols);
    final childWidth = size.width / allCols;
    final childHeight = size.height / allRows;
    int i = 0;
    (qChildren ?? []).forEach((c) => childrenMap[c.key] = BentoChildDetail(
          child: c,
          offset: Offset(((allCols - qCols) / 2 + (i % qCols)) * childWidth,
              (i++ ~/ qCols) * childHeight + 10),
        ));
    i = 0;
    children.forEach((c) => childrenMap[c.key] = BentoChildDetail(
          child: c,
          offset: Offset(((allCols - cols) / 4 + (i % cols)) * childWidth,
              (qRows + (i++ ~/ cols)) * childHeight),
        ));
  }

  static calculateHorizontalLayout(
      {int cols,
      int rows,
      List<Widget> children,
      int qCols,
      int qRows,
      List<Widget> qChildren,
      Map<Key, BentoChildDetail> childrenMap,
      Size size}) {
    // final allRows = rows + qRows;
    // final allCols = max(cols, qCols);
    final allRows = max(rows, qRows);
    final allCols = cols + qCols;
    final childWidth = size.width / allCols;
    final childHeight = size.height / allRows;
    int i = 0;

    (qChildren ?? []).forEach((c) => childrenMap[c.key] = BentoChildDetail(
          child: c,
          offset: Offset((i ~/ qRows) * childWidth,
              ((allRows - qRows) / 2 + (i++ % qRows)) * childHeight),
        ));
    i = 0;
    (qChildren ?? []).forEach((c) => print('$c, <>'));
    children.forEach((c) => childrenMap[c.key] = BentoChildDetail(
          child: c,
          offset: Offset((qCols + (i ~/ qRows)) * childWidth,
              ((allRows - qRows) / 2 + (i++ % qRows)) * childHeight),
        ));
    (children ?? []).forEach((c) => print('$c, <<>>'));
  }

  static calculateOrderlyRandomizedLayout(
      {int cols,
      int rows,
      List<Widget> children,
      int qCols,
      int qRows,
      List<Widget> qChildren,
      Map<Key, BentoChildDetail> childrenMap,
      Size size}) {
    final childWidth = size.width / cols;
    final childHeight = size.height / rows;

    Random random = Random();
    (qChildren ?? []).forEach((c) => childrenMap[c.key] = BentoChildDetail(
        child: c,
        offset: Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height)));
    List<Offset> offsets = new List<Offset>();
    for (double i = 0; i <= size.width - childWidth; i += childWidth) {
      for (double j = 0; j <= size.height - childHeight; j += childHeight / 3)
        offsets.add(Offset(i, j));
    }
    for (final x in children) {
      var index = random.nextInt(offsets.length);
      childrenMap[x.key] = BentoChildDetail(child: x, offset: offsets[index]);
      offsets.removeAt(index);
    }
  }

  static calculateRandomizedLayout(
      {int cols,
      int rows,
      List<Widget> children,
      int qCols,
      int qRows,
      List<Widget> qChildren,
      Map<Key, BentoChildDetail> childrenMap,
      Size size}) {
    final childWidth = size.width / cols;
    final childHeight = size.height / rows;

    Random random = Random();
    (qChildren ?? []).forEach((c) => childrenMap[c.key] = BentoChildDetail(
        child: c,
        offset: Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height)));
    children.forEach((c) => childrenMap[c.key] = BentoChildDetail(
        child: c,
        offset: Offset(max(0, random.nextDouble() * size.width - childWidth),
            max(0, random.nextDouble() * size.height - childHeight))));
  }
}

class BentoChildDetail {
  final Widget child;
  Offset offset;
  bool moveImmediately;

  BentoChildDetail({this.child, this.offset, this.moveImmediately = false});

  @override
  String toString() =>
      '_ChildDetail(child: $child, offset: $offset, moveImmediately: $moveImmediately)';
}

class _BentoBoxState extends State<BentoBox> {
  Map<Key, BentoChildDetail> _children;
  Size size;
  int rows;
  int cols;

  @override
  void initState() {
    super.initState();
    _children = {};
    size = Size(1024.0, 1024.0); //Nominal size
    calculateLayout(true);
  }

  void calculateLayout(bool reCalculate) {
    int k = 0;
    if (widget.calculateLayout == BentoBox.calculateHorizontalLayout) {
      rows = max(widget.rows, widget.qRows);
      cols = widget.cols + widget.qCols;
    } else {
      rows = widget.rows + widget.qRows;
      cols = max(widget.cols, widget.qCols);
    }
    final childWidth = size.width / cols;
    final childHeight = size.height / rows;

    (widget.frontChildren ?? []).forEach((c) => _children[c.key] =
        BentoChildDetail(
            child: c,
            offset: Offset(
                ((cols - widget.frontChildren.length) / 2 + k++) * childWidth,
                (rows - 1) / 2 * childHeight)));
    if (reCalculate ||
        (widget.calculateLayout != BentoBox.calculateRandomizedLayout &&
            widget.calculateLayout !=
                BentoBox.calculateOrderlyRandomizedLayout)) {
      widget.calculateLayout(
          cols: widget.cols,
          rows: widget.rows,
          children: widget.children,
          qCols: widget.qCols,
          qRows: widget.qRows,
          qChildren: widget.qChildren,
          childrenMap: _children,
          size: size);
    } else {
      print("this is false reload");
    }
  }

  @override
  void didUpdateWidget(BentoBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.frontChildren != widget.frontChildren ||
        oldWidget.qChildren != widget.qChildren ||
        oldWidget.children != widget.children) {
      calculateLayout(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BentoBox:build');
    return LayoutBuilder(builder: (context, constraints) {
      var i = 0;
      final biggest = constraints.biggest;
      List<Widget> widgets = [Container()];
      Size childSize = Size(biggest.width / cols, biggest.height / rows);

      widgets.addAll((widget.qChildren ?? []).map((child) {
        final c = _children[child.key];
        if (size != biggest) {
          c.offset = c.offset
              .scale(biggest.width / size.width, biggest.height / size.height);
        }
        return c.child.key == null
            ? Positioned(
                child: buildChild(childSize, c, true),
                left: c.offset.dx,
                top: c.offset.dy)
            : AnimatedPositioned(
                key: ValueKey(c.child.key),
                child: buildChild(childSize, c, true),
                duration: c.moveImmediately
                    ? Duration.zero
                    : Duration(milliseconds: 500),
                left: c.offset.dx,
                top: c.offset.dy);
      }));

      widgets.addAll(widget.children.map((child) {
        final c = _children[child.key];
        if (c == null) {
          return Positioned(
            child: Container(),
          );
        }
        if (size != biggest) {
          c.offset = c.offset
              .scale(biggest.width / size.width, biggest.height / size.height);
        }
        return c.child.key == null
            ? Positioned(
                child: buildChild(childSize, c, true),
                left: c.offset.dx,
                top: c.offset.dy)
            : AnimatedPositioned(
                key: ValueKey(c.child.key),
                child: buildChild(childSize, c, false),
                duration: c.moveImmediately
                    ? Duration.zero
                    : Duration(milliseconds: 500),
                left: c.offset.dx,
                top: c.offset.dy);
      }));

      widgets.addAll((widget.frontChildren ?? []).map((child) {
        final c = _children[child.key];
        if (size != biggest) {
          c.offset = c.offset
              .scale(biggest.width / size.width, biggest.height / size.height);
        }
        return AnimatedPositioned(
          key: ValueKey(c.child.key),
          child: buildChild(childSize, c, true),
          duration: Duration(milliseconds: 500),
          left: c.offset.dx,
          top: c.offset.dy,
        );
      }));
      size = constraints.biggest;
      return Stack(
        overflow: Overflow.visible,
        children: widgets,
      );
    });
  }

  void onDragEnd(DraggableDetails d, BentoChildDetail c) {
    setState(() {
      if (!d.wasAccepted &&
          widget.dragConfig == DragConfig.draggableBounceBack) {
        final currentOffset = Offset(c.offset.dx, c.offset.dy);
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              c.offset = currentOffset;
              c.moveImmediately = false;
            }));
      }
      if (widget.dragConfig != DragConfig.draggableMultiPack) {
        c.offset =
            (context.findRenderObject() as RenderBox).globalToLocal(d.offset);
        c.moveImmediately = true;
      }
    });
  }

  Widget buildChild(Size size, BentoChildDetail childDetail, bool fixed) {
    print("this is the size $size");
    return childDetail.child is CuteButton
        ? CuteButtonWrapper(
            key: childDetail.child.key,
            axis: widget.axis,
            onDragEnd: (d) => onDragEnd(d, childDetail),
            dragConfig: fixed ? DragConfig.fixed : widget.dragConfig,
            size: widget.grid == true
                ? size + Offset(-6, 0)
                : size + Offset(-16, -16),
            child: childDetail.child,
          )
        : SizedBox(
            width: widget.grid == true ? size.height + 30 : size.width - 16,
            height: widget.grid == true ? size.height + 30 : size.height - 16,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: childDetail.child,
              ),
            ),
          );
  }
}
