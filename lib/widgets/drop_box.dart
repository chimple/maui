import 'package:flutter/material.dart';

class DropBox extends StatelessWidget {
  final Color color;
  final Widget child;
  final DragTargetAccept<String> onAccept;
  final DragTargetWillAccept<String> onWillAccept;
  final DragTargetLeave<String> onLeave;
  const DropBox({
    Key key,
    @required this.child,
    this.onAccept,
    this.onLeave,
    this.color = Colors.blue,
    this.onWillAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return child ??
            Container(
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
            );
      },
      onAccept: onAccept,
      onWillAccept: onWillAccept,
      onLeave: onLeave,
    );
  }
}
