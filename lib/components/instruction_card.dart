import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class InstructionCard extends StatefulWidget {
  final String text;
  final String image;
  final VoidCallback onChecked;

  InstructionCard({Key key, @required this.text, this.image, this.onChecked})
      : super(key: key);

  @override
  _InstructionCardState createState() {
    return new _InstructionCardState();
  }
}

class _InstructionCardState extends State<InstructionCard> {
  Unit _unit;
  bool _isLoading = true;
  // String image = 'assets/apple.png';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _unit = await new UnitRepo().getUnit(widget.text.toLowerCase());
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
    bool noImage = (_unit?.image?.length ?? 0) == 0;
    Color bgColor = Theme.of(context).accentColor;
    return Container(
        decoration: noImage ? BoxDecoration(color: bgColor) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Align(
              alignment: Alignment(1.0, 0.0),
              child: IconButton(
                  icon: new Icon(Icons.volume_up),
                  color: noImage ? Colors.white : bgColor,
                  onPressed: () =>
                      AppStateContainer.of(context).play(widget.text)),
            ),
            Expanded(
              child: noImage
                  ? new Center(
                      child: Text(
                      widget.text,
                      style: TextStyle(color: Colors.white, fontSize: 48.0),
                    ))
                  : new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(_unit.image),
                    ),
            ),
            noImage
                ? Container()
                : Container(
                    color: bgColor,
                    child: new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                          child: Text(widget.text,
                              style: TextStyle(color: Colors.white))),
                    ))
          ],
        ));
  }
}
