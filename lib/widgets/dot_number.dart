import 'dart:math';

import 'package:flutter/material.dart';

class DotNumber extends StatelessWidget {
  final int number;
  final bool showNumber;

  const DotNumber({Key key, this.number, this.showNumber = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    if (showNumber) {
      widgets.add(Flexible(
        flex: 4,
        child: Center(
            child: Text(
          number.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        )),
      ));
    }
    widgets.add(Flexible(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = min(constraints.maxWidth / 8, constraints.maxHeight / 3);
          final padding = min(constraints.maxWidth / 5 - size,
                  constraints.maxHeight / 2 - size) /
              2;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: List<Widget>.generate(
                  5,
                  (i) => Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: i < number
                                ? ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                ),
              ),
              Row(
                children: List<Widget>.generate(
                  5,
                  (i) => Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: i < number - 5
                                ? ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                ),
              ),
            ],
          );
        },
      ),
    ));
    return Column(
      children: widgets,
    );
  }
}
