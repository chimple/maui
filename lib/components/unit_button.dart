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
  final double maxWidth;
  final double maxHeight;

  UnitButton(
      {Key key,
      @required this.text,
      this.onPress,
      this.maxChars = 8,
      this.maxWidth = 100.0,
      this.maxHeight = 70.0,
      this.disabled = false,
      this.showHelp = true,
      this.unitMode = UnitMode.text})
      : super(key: key);

  @override
  _UnitButtonState createState() {
    return new _UnitButtonState();
  }

  static double getFontSize(int maxChars, double maxWidth, double maxHeight) {
    final fontSizeByWidth = maxWidth / (maxChars * 0.7);
    final fontSizeByHeight = maxHeight / 1.8;
    return min(fontSizeByHeight, fontSizeByWidth);
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
    final maxWidth = widget.maxWidth;
    final maxHeight = widget.maxHeight;
    final fontSize = UnitButton.getFontSize(widget.maxChars, maxWidth, maxHeight)
    final double radius = min(maxWidth, maxHeight) / 8.0;

    final width = (widget.maxChars == 1 || widget.unitMode != UnitMode.text)
        ? min(maxWidth, maxHeight)
        : fontSize * widget.maxChars * 0.7;
    final height = (widget.maxChars == 1 || widget.unitMode != UnitMode.text)
        ? min(maxWidth, maxHeight)
        : min(maxHeight, maxWidth * 0.75);
    print(
        'fontsize: $fontSize width: ${width} height: ${height} maxWidth: ${maxWidth} maxHeight: ${maxHeight} maxChars: ${widget.maxChars}');

    return SizedBox(
        height: height,
        width: width,
        child: FlatButton(
            splashColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).accentColor,
            disabledColor: Color(0xFFDDDDDD),
            onPressed: widget.disabled ? null : widget.onPress,
            padding: EdgeInsets.all(0.0),
            shape: new RoundedRectangleBorder(
                side: new BorderSide(
                    color: widget.disabled
                        ? Color(0xFFDDDDDD)
                        : Theme.of(context).primaryColor,
                    width: 4.0),
                borderRadius: BorderRadius.all(Radius.circular(radius))),
            child: _buildUnit(fontSize)));
  }

  Widget _buildUnit(double fontSize) {
    if (widget.unitMode == UnitMode.audio) {
      return new Icon(Icons.volume_up);
    } else if (widget.unitMode == UnitMode.image) {
      return _isLoading
          ? new Text(widget.text)
          : new Image.asset('assets/apple.png');
    }
    return Center(
        child: Text(widget.text,
            style: new TextStyle(
                color: Theme.of(context).primaryColor, fontSize: fontSize)));
  }

  @override
  void dispose() {
    super.dispose();
  }

}
