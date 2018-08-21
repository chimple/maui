import 'package:flutter/material.dart';

class ResultSummaryPage extends StatefulWidget {
  @override
  _ResultSummaryPageState createState() => new _ResultSummaryPageState();
}

class _ResultSummaryPageState extends State<ResultSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Result Summary Page"),
        centerTitle: true,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child:
                        new Container(child: new Center(child: new Text("1"))),
                  ),
                  new Expanded(
                    flex: 3,
                    child: new Container(
                        child: new Center(child: new Text("Questions1"))),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Center(child: new Text("Score1"))),
                  ),
                ],
              )),
          new Expanded(
              flex: 1,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child:
                        new Container(child: new Center(child: new Text("2"))),
                  ),
                  new Expanded(
                    flex: 3,
                    child: new Container(
                        child: new Center(child: new Text("Questions2"))),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Center(child: new Text("Score2"))),
                  ),
                ],
              )),
          new Expanded(
              flex: 1,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child:
                        new Container(child: new Center(child: new Text("3"))),
                  ),
                  new Expanded(
                    flex: 3,
                    child: new Container(
                        child: new Center(child: new Text("Questions3"))),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Center(child: new Text("Score3"))),
                  ),
                ],
              )),
          new Expanded(
              flex: 1,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child:
                        new Container(child: new Center(child: new Text("4"))),
                  ),
                  new Expanded(
                    flex: 3,
                    child: new Container(
                        child: new Center(child: new Text("Questions4"))),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Center(child: new Text("Score4"))),
                  ),
                ],
              )),
          new Expanded(
              flex: 1,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child:
                        new Container(child: new Center(child: new Text("5"))),
                  ),
                  new Expanded(
                    flex: 3,
                    child: new Container(
                        child: new Center(child: new Text("Questions5"))),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Container(
                        child: new Center(child: new Text("Score5"))),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
