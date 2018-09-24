import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => new _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return new Container(
          color: Colors.grey,
          height: 2.0,
        );
      },
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return new Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          child: new ListTile(
            key: new Key(index.toString()),
            subtitle: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: new RaisedButton(
                      shape: new RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.brown,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(20.0)),
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            flex: 1,
                            child: new Icon(
                              Icons.arrow_upward,
                              size: 30.0,
                              color: Colors.green,
                            ),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Text(
                              "2",
                              style: new TextStyle(fontSize: 30.0),
                            ),
                          )
                        ],
                      ),
                      elevation: 5.0,
                      onPressed: () {
                        print("liked");
                      },
                    ),
                  ),
                ),
                new Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: new RaisedButton(
                      shape: new RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.brown,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(20.0)),
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            flex: 1,
                            child: new Icon(
                              Icons.arrow_downward,
                              size: 30.0,
                              color: Colors.red,
                            ),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Text(
                              "0",
                              style: new TextStyle(fontSize: 30.0),
                            ),
                          )
                        ],
                      ),
                      elevation: 5.0,
                      onPressed: () {
                        print("disliked");
                      },
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new RaisedButton(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      shape: new RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.brown,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(20.0)),
                      elevation: 5.0,
                      onPressed: () => print("Commented"),
                      child: new Text(
                        "Comment",
                        style: new TextStyle(fontSize: 30.0),
                      )),
                ),
              ],
            ),
            title: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Expanded(
                      flex: 1,
                      child: new Icon(
                        Icons.airport_shuttle,
                        size: 50.0,
                        semanticLabel: "just testing",
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Icon(
                        Icons.access_alarm,
                        size: 50.0,
                        semanticLabel: "just testing",
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Expanded(
                      flex: 1,
                      child: new Icon(
                        Icons.airport_shuttle,
                        size: 50.0,
                        semanticLabel: "just testing",
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Icon(
                        Icons.access_alarm,
                        size: 50.0,
                        semanticLabel: "just testing",
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Expanded(
                      flex: 1,
                      child: new Icon(
                        Icons.airport_shuttle,
                        size: 50.0,
                        semanticLabel: "just testing",
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Icon(
                        Icons.access_alarm,
                        size: 50.0,
                        semanticLabel: "just testing",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () => print("I am busy"),
            contentPadding: const EdgeInsets.all(25.0),
            isThreeLine: true,
            enabled: true,
            dense: false,
          ),
        );
      },
    );
  }
}
