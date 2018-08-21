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
        backgroundColor: Colors.teal,
      ),
      body: new ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  height: 200.0,
                                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          child: new Center(child: new Text("$index", style: new TextStyle( fontSize: 20.0 , fontWeight: FontWeight.bold),)),
                          decoration: new BoxDecoration(color: Colors.grey),
                        ),
                      ),
                      new Expanded(
                        flex: 3,
                        child: new Container(
                          child:
                              new Center(child: new Text("Questions" + "$index", style: new TextStyle( fontSize: 20.0 , fontWeight: FontWeight.bold),)),
                          decoration: new BoxDecoration(color: Colors.green),
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          child: new Center(child: new Text("Score" + "$index", style: new TextStyle( fontSize: 20.0 , fontWeight: FontWeight.bold),)),
                          decoration: new BoxDecoration(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ), );
  }
}
