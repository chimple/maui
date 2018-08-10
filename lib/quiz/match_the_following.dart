import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

void main() => runApp(new MaterialApp(
      home: new MatchingGame(),
    ));

Future<String> _loadData() async {
  return await rootBundle.loadString('assets/GameData.json');
}

Map<String, dynamic> _decoded = {};
Map<String, dynamic> _selected = {};

class MatchingGame extends StatefulWidget {
  @override
  _MatchingGameState createState() => new _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  String _leftItemTapped;
  bool _isLoading = true;

  List<String> _leftSideItems = [];
  List<String> _leftSideDisabledItems = [];
  List<dynamic> _rightSideDisabledItems = [];
  List<dynamic> _rightSideItems = [];

  void _initData() async {
    _decoded = await json.decode(await _loadData());
    setState(() {
      print(_decoded);
      print(_decoded["pairs"].length);
      print(_decoded["pairs"]);
      print((_decoded["pairs"].keys.toList()..shuffle()));
      print(_decoded["pairs"].values.toList()..shuffle());
      _isLoading = false;
    });
    if (_isLoading == false) {
      _leftSideItems = (_decoded["pairs"].keys.toList()..shuffle());
      print(_leftSideItems);
      _rightSideItems = (_decoded["pairs"].values.toList()..shuffle());
      print(_rightSideItems);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
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
    if (_rightSideDisabledItems.length == _decoded["pairs"].length &&
        _leftSideDisabledItems.length == _decoded["pairs"].length) {
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
      body: _isLoading
          ? new CircularProgressIndicator()
          : new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.lighten),
                image: new NetworkImage(_decoded["image"]),
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
                          borderRadius:
                              new BorderRadius.all(Radius.circular(10.0))),
                      child: new Center(
                        child: new Text(
                          _decoded["question"],
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
                        itemCount: _decoded["pairs"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.all(10.0),
                                child: new RaisedButton(
                                  onPressed:
                                      _checkItem(_leftSideItems[index], "left")
                                          ? null
                                          : () {
                                              _leftItemTapped =
                                                  _leftSideItems[index];
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
                                  onPressed: _checkItem(
                                          _rightSideItems[index], "right")
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
