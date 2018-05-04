import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

import 'flash_card.dart';

class UnitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  final UnitMode unitMode;


  UnitButton(
      {Key key,
      @required this.text,
      this.onPress,
      this.unitMode = UnitMode.text})
      : super(key: key);

  @override
  _UnitButtonState createState() {
    return new _UnitButtonState();
  }
}

class _UnitButtonState extends State<UnitButton> {
  Unit _unit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('initState');
    _getData();
  }

  void _getData() async {
    if (widget.unitMode == UnitMode.audio ||
        widget.unitMode == UnitMode.image) {
      _unit = await new UnitRepo().getUnit(widget.text);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: () {
          AppStateContainer.of(context).play(widget.text);
          if (widget.unitMode != UnitMode.audio) {
            showDialog(
                context: context,
                child: new FractionallySizedBox(
                    heightFactor: 0.5,
                    widthFactor: 0.8,
                    child: new FlashCard(text: widget.text)));
          }
        },
        child: new RaisedButton(
            onPressed: widget.onPress,
            color: widget.unitMode == UnitMode.image
                ? Colors.white
                : Theme.of(context).buttonColor,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0))),
            child: _buildUnit()));
  }

  Widget _buildUnit() {
    if (widget.unitMode == UnitMode.audio) {
      return new Icon(Icons.volume_up);
    } else if (widget.unitMode == UnitMode.image) {
      return _isLoading
          ? new Text(widget.text)
          : new Image.asset('assets/apple.png');
    }
    return new Text(widget.text,
        style: new TextStyle(color: Colors.white, fontSize: 24.0));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
