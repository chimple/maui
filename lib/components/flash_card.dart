import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class FlashCard extends StatefulWidget {
  final String text;
  final String image;
  final VoidCallback onChecked;

  FlashCard({Key key, @required this.text, this.image, this.onChecked}) : super(key: key);

  @override
  _FlashCardState createState() {
    return new _FlashCardState();
  }
}

class _FlashCardState extends State<FlashCard> {
  Unit _unit;
  bool _isLoading = true;
 // String image = 'assets/apple.png';

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
    return new LayoutBuilder(builder: (context, constraints) {
      return new Card(
          color: Colors.purple,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(Radius.circular(constraints.maxHeight * 0.02 ))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.volume_up),
                    iconSize: constraints.maxHeight * 0.18,
                    color: Colors.white,
                    onPressed: () =>
                        AppStateContainer.of(context).play(widget.text)),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.arrow_left),
                        onPressed: widget.onChecked,
                        iconSize: constraints.maxHeight * 0.12,
                        color: Colors.white),
                    new Expanded(child
                        : new SizedBox(  height:  constraints.maxHeight > constraints.maxWidth ? constraints.maxHeight * 0.4 : constraints.maxWidth * 0.3,
                        width: constraints.maxHeight > constraints.maxWidth ? constraints.maxWidth * 0.9 : constraints.maxHeight * 0.5,
                        child: widget.image == null ?
                        new Container(
                            alignment: const Alignment(0.0, 0.0),
                            child: new Text(widget.text,  style: new TextStyle(color: Colors.white, fontSize: constraints.maxHeight * 0.11, fontWeight: FontWeight.bold))) :
                        new Image.asset(widget.image))),
                    new IconButton(
                      icon: new Icon(Icons.arrow_right),
                      onPressed: widget.onChecked,
                      iconSize: constraints.maxHeight * 0.12,
                      color: Colors.white,
                    )
                  ],
                ),
                widget.image == null  ? new Container(
                    alignment: const Alignment(0.0, 0.0),
                    margin: new EdgeInsets.all(constraints.maxHeight * 0.04),
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(constraints.maxHeight * 0.015)),
                        shape: BoxShape.rectangle),
                    child: new Text("",
                        style: new TextStyle(color: Colors.white, fontSize: constraints.maxHeight * 0.1, fontWeight: FontWeight.bold ))) :
                new Container(
                    height: constraints.maxHeight * 0.2,
                    width: constraints.maxWidth * 0.9,
                    alignment: const Alignment(0.0, 0.0),
                    margin: new EdgeInsets.all(constraints.maxHeight * 0.04),
                    decoration: new BoxDecoration(
                        color: Colors.amber,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(constraints.maxHeight * 0.015)),
                        shape: BoxShape.rectangle),
                    child: new Text(_unit?.name ?? widget.text,
                        style: new TextStyle(color: Colors.white, fontSize: constraints.maxHeight * 0.1, fontWeight: FontWeight.bold )))

              ]));
    });
  }
}
