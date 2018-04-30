import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class FlashCard extends StatefulWidget {
  final String text;
  final VoidCallback onChecked;

  FlashCard({Key key, @required this.text, this.onChecked}) : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Container(
              alignment: const Alignment(0.0, 0.0),
              padding: const EdgeInsets.all(8.0),
              color: Colors.teal,
              child: new Text(_unit?.name ?? widget.text,
                  style: new TextStyle(color: Colors.white, fontSize: 24.0))),
          new Expanded(
              child: new Row(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.volume_up),
                  onPressed: () =>
                      AppStateContainer.of(context).play(widget.text)),
              new Expanded(child: new Image.asset('assets/apple.png')),
              new IconButton(
                  icon: new Icon(Icons.check), onPressed: widget.onChecked)
            ],
          ))
        ]));
  }
}
