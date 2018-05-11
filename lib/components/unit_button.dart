import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:meta/meta.dart';
import 'dart:math';

import 'flash_card.dart';

class UnitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  final UnitMode unitMode;
  final bool disabled;
  final bool highlighted;
  final bool primary;
  final bool showHelp;

  UnitButton(
      {Key key,
      @required this.text,
      this.onPress,
      this.disabled = false,
      this.showHelp = true,
      this.highlighted = false,
      this.primary = true,
      this.unitMode = UnitMode.text})
      : super(key: key);

  @override
  _UnitButtonState createState() {
    return new _UnitButtonState();
  }

  static void saveButtonSize(
      BuildContext context, int maxChars, double maxWidth, double maxHeight) {
    AppState state = AppStateContainer.of(context).state;
    final fontSizeByWidth = maxWidth / (maxChars * 0.7);
    final fontSizeByHeight = maxHeight / 1.8;
    state.buttonFontSize = min(fontSizeByHeight, fontSizeByWidth);
    state.buttonRadius = min(maxWidth, maxHeight) / 8.0;

    state.buttonWidth = (maxChars == 1)
        ? min(maxWidth, maxHeight)
        : state.buttonFontSize * maxChars * 0.7;
    state.buttonHeight = (maxChars == 1)
        ? min(maxWidth, maxHeight)
        : min(maxHeight, maxWidth * 0.75);
    print(
        'fontsize: ${state.buttonFontSize} width: ${state.buttonWidth} height: ${state.buttonHeight} maxWidth: ${maxWidth} maxHeight: ${maxHeight} maxChars: ${maxChars}');
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
            child: _buildButton(context))
        : _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    AppState state = AppStateContainer.of(context).state;
    return SizedBox(
        height: state.buttonHeight,
        width: state.buttonWidth,
        child: FlatButton(
            color: widget.highlighted
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            splashColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).accentColor,
            disabledColor: Color(0xFFDDDDDD),
            onPressed: widget.disabled ? null : widget.onPress,
            padding: EdgeInsets.all(0.0),
            shape: new RoundedRectangleBorder(
                side: new BorderSide(
                    color: widget.disabled
                        ? Color(0xFFDDDDDD)
                        : widget.primary
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                    width: 4.0),
                borderRadius:
                    BorderRadius.all(Radius.circular(state.buttonRadius))),
            child: _buildUnit(state.buttonFontSize)));
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
                color: widget.highlighted || !widget.primary
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                fontSize: fontSize)));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
