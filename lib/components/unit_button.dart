import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';
import 'dart:math';

import 'flash_card.dart';

class UnitButton extends StatefulWidget {
  final String text;
  final int maxChars;
  final VoidCallback onPress;
  final UnitMode unitMode;
  final bool disabled;
  final bool showHelp;

  UnitButton(
      {Key key,
      @required this.text,
      this.onPress,
      this.maxChars = 24,
      this.disabled = false,
      this.showHelp = true,
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
    return widget.showHelp
        ? new GestureDetector(
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
            child: _buildButton())
        : _buildButton();
  }

  Widget _buildButton() {
    return new FlatButton(
        splashColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).accentColor,
        disabledColor: Color(0xFFDDDDDD),
        onPressed: widget.disabled ? null : widget.onPress,
        shape: new RoundedRectangleBorder(
            side: new BorderSide(
                color: widget.disabled
                    ? Color(0xFFDDDDDD)
                    : Theme.of(context).primaryColor,
                width: 4.0),
            borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
        child: _buildUnit());
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
        style: new TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: max(12.0, min(36.0, 96.0 - 2.9 * widget.maxChars))));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
