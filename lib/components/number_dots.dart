import 'package:flutter/material.dart';

class NumberDots extends StatelessWidget {
  final int number;

  NumberDots({
    Key key,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rowSize = 1;
    int checkingNumber = this.number;

    if (checkingNumber > 9) {
      checkingNumber = 0;
    }

    if (checkingNumber > 0) {
      List dotLists = new List(checkingNumber);
      if (dotLists.length > 5) {
        rowSize = 2;
      } else {
        rowSize = 1;
      }

      List<Widget> rows = new List<Widget>();

      for (var i = 0; i < rowSize + 1; ++i) {
        List<Widget> cells = dotLists.skip(i * 5).take(5).map((e) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: new Icon(
              Icons.lens,
              color: Colors.black,
              size: 13.0,
            ),
          );
        }).toList(growable: false);
        rows.add(Row(
          children: cells,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
      }

      return Column(
        children: rows,
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      return Container();
    }
  }
}
