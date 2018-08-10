import 'package:flutter/material.dart';

Map<String, dynamic> _selected = {};

class MatchingGame extends StatefulWidget {
  Map<String, dynamic> gameData;
  MatchingGame(
      {key,
      this.gameData = const {
        "image":
            "https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg",
        "question": "what is this game about?",
        "pairs": {
          "1": "string1",
          "2": "string2",
          "3": "string3",
          "4": "string4",
          "5": "string5",
          "6": "string6",
          "7": "string7",
          "8": "string8",
          "9": "string9",
          "10": "string10",
          "11": "string11",
          "12": "string12",
          "13": "string13",
          "14": "string14",
          "15": "string15",
          "16": "string16",
          "17": "string17",
          "18": "string18",
          "19": "string19",
          "20": "string20"
        }
      }})
      : super(key: key);
  @override
  _MatchingGameState createState() => new _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  String _leftItemTapped;

  List<String> _leftSideItems = [];
  List<String> _leftSideDisabledItems = [];
  List<dynamic> _rightSideDisabledItems = [];
  List<dynamic> _rightSideItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _leftSideItems = (widget.gameData["pairs"].keys.toList()..shuffle());
    _rightSideItems = (widget.gameData["pairs"].values.toList()..shuffle());
  }

  bool _checkItem(String i, String side) {
    if (side == "left") {
      return (_leftSideDisabledItems.indexOf(i) != -1) ? true : false;
    } else {
      return (_rightSideDisabledItems.indexOf(i) != -1) ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _leftItemTapped = '';
    if (_rightSideDisabledItems.length == widget.gameData["pairs"].length &&
        _leftSideDisabledItems.length == widget.gameData["pairs"].length) {
      _selected = new Map.fromIterables(
          _leftSideDisabledItems, _rightSideDisabledItems);
      print(_selected);
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Matching"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: new Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.lighten),
          image: new NetworkImage(widget.gameData["image"]),
        )),
        child: new Column(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.orange,
                    borderRadius: new BorderRadius.all(Radius.circular(10.0))),
                child: new Center(
                  child: new Text(
                    widget.gameData["question"],
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 7,
              child: new Container(
                child: new ListView.builder(
                  itemCount: widget.gameData["pairs"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            onPressed: _checkItem(_leftSideItems[index], "left")
                                ? null
                                : () {
                                    _leftItemTapped = _leftSideItems[index];
                                  },
                            padding: EdgeInsets.all(20.0),
                            child: new Center(
                              child: new Text(
                                _leftSideItems[index],
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            onPressed:
                                _checkItem(_rightSideItems[index], "right")
                                    ? null
                                    : () {
                                        print("correct");
                                        print(_leftItemTapped == ''
                                            ? "leftNotTapped"
                                            : _leftItemTapped);
                                        print(_rightSideItems[index]);
                                        if (_leftItemTapped != '') {
                                          setState(() {
                                            _leftSideDisabledItems
                                                .add(_leftItemTapped);
                                            print(_leftSideDisabledItems);
                                            _rightSideDisabledItems
                                                .add(_rightSideItems[index]);
                                            print(_rightSideDisabledItems);
                                            print(_selected);
                                          });
                                        }
                                      },
                            padding: EdgeInsets.all(20.0),
                            child: new Center(
                              child: new Text(
                                _rightSideItems[index],
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
