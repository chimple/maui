import 'package:flutter/material.dart';

class ResultSummaryPage extends StatefulWidget {
  @override
  _ResultSummaryPageState createState() => new _ResultSummaryPageState();
}

class _ResultSummaryPageState extends State<ResultSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (context, constraints) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(flex: 1, child: new Row()),
            new Expanded(flex: 1, child: new Row()),
            new Expanded(flex: 1, child: new Row()),
            new Expanded(flex: 1, child: new Row()),
            new Expanded(flex: 1, child: new Row()),
          ],
        );
      },
    );
  }
}
