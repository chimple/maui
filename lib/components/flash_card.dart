import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';

class FlashCard extends StatefulWidget {
  final String text;

  FlashCard({Key key, @required this.text}) : super(key: key);

  @override
  _FlashCardState createState() {
    return new _FlashCardState();
  }

}

class _FlashCardState extends State<FlashCard> {
  Unit _unit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _unit = await new UnitRepo().getUnit(widget.text);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Card(
      child: new Column(
        children: <Widget>[
          new Image.asset('assets/apple.png'),
          new Container(
            alignment: const Alignment(0.0, 0.0),
            color: Colors.teal,
              child: new Text(_unit.name,
            style: new TextStyle(color: Colors.white, fontSize: 24.0)))
        ]
      ),
    );
  }
}