import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';
import 'package:maui/components/gameaudio.dart';

class FlashCard extends StatefulWidget {
  final String text;
  final String image;
  final VoidCallback onChecked;

  FlashCard({Key key, @required this.text, this.image, this.onChecked})
      : super(key: key);

  @override
  _FlashCardState createState() {
    return new _FlashCardState();
  }
}

class _FlashCardState extends State<FlashCard> {
  Unit _unit;
  bool _isLoading = true;
  bool _containsNum = false;
  int i;

  @override
  void initState() {
    super.initState();
    _getData();
    _getNumberStatus();
  }

  void _getData() async {
    print('FlashCard getting unit: ${widget.text}');
    _unit = await new UnitRepo().getUnit(widget.text.trim().toLowerCase());
    setState(() => _isLoading = false);
  }

  void _getNumberStatus() async {
    for (i = 0; i < 10; i++) {
      if (widget.text.indexOf('${i}') != -1) {
        setState(() => _containsNum = true);
        print("$_containsNum");
        break;
      }
      print("coming");
      print("$_containsNum");
    }
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
    bool noImage = (_unit?.image?.length ?? 0) == 0;

    return new LayoutBuilder(builder: (context, constraints) {
      Color bgColor = Theme.of(context).accentColor;
      print("anuj");
      print(widget.text.indexOf("1"));
      print(_containsNum);
      print('Unit: $_unit');

      return new Card(
          color: bgColor,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(
                  Radius.circular(constraints.maxHeight * 0.08))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.volume_up),
                    iconSize: constraints.maxHeight * 0.18,
                    color: Colors.white,
                    onPressed: () {
                      AppStateContainer.of(context).playWord(widget.text);
                    }),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.arrow_left),
                        onPressed: () {
                          widget.onChecked();
                        },
                        iconSize: constraints.maxHeight * 0.2,
                        color: Colors.white),
                    new Expanded(
                        child: new SizedBox(
                            height: constraints.maxHeight > constraints.maxWidth
                                ? constraints.maxHeight * 0.2
                                : constraints.maxWidth * 0.2,
                            width: constraints.maxHeight > constraints.maxWidth
                                ? constraints.maxWidth * 0.5
                                : constraints.maxHeight * 0.5,
                            child: _containsNum
                                ? new Container(
                                    alignment: const Alignment(0.0, 0.0),
                                    child: new Text(widget.text,
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                constraints.maxHeight * 0.11,
                                            fontWeight: FontWeight.bold)))
                                : noImage
                                    ? new Container(
                                        alignment: const Alignment(0.0, 0.0),
                                        child: new Text(widget.text,
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.11,
                                                fontWeight: FontWeight.bold)))
                                    : Image.asset(_unit.image))),
                    new IconButton(
                      icon: new Icon(Icons.arrow_right),
                      onPressed: () {
                        widget.onChecked();
                      },
                      iconSize: constraints.maxHeight * 0.2,
                      color: Colors.white,
                    )
                  ],
                ),
                noImage
                    ? new Container(
                        alignment: const Alignment(0.0, 0.0),
                        margin:
                            new EdgeInsets.all(constraints.maxHeight * 0.04),
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(
                                    constraints.maxHeight * 0.015)),
                            shape: BoxShape.rectangle),
                        child: new Text("",
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: constraints.maxHeight * 0.1,
                                fontWeight: FontWeight.bold)))
                    : new Container(
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.9,
                        alignment: const Alignment(0.0, 0.0),
                        margin:
                            new EdgeInsets.all(constraints.maxHeight * 0.04),
                        decoration: new BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(
                                    constraints.maxHeight * 0.015)),
                            shape: BoxShape.rectangle),
                        child: new Text(_unit?.name ?? widget.text,
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: constraints.maxHeight * 0.085,
                                fontWeight: FontWeight.bold)))
              ]));
    });
  }
}
