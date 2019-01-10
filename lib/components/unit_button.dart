import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:meta/meta.dart';
import 'dart:math';

import 'flash_card.dart';

int valuesofCount = 0;

class UnitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  final UnitMode unitMode;
  Widget child;
  final bool disabled;
  final bool highlighted;
  final bool primary;
  final bool showHelp;
  final String bgImage;
  final double maxWidth;
  final double maxHeight;
  final double fontSize;
  final bool forceUnitMode;
  final int flag;

  UnitButton(
      {Key key,
      @required this.text,
      this.onPress,
      this.flag,
      this.disabled = false,
      this.child,
      this.showHelp = true,
      this.highlighted = false,
      this.primary = true,
      this.forceUnitMode = false,
      this.bgImage,
      this.maxHeight,
      this.maxWidth,
      this.fontSize,
      this.unitMode = UnitMode.text})
      : super(key: key);

  @override
  _UnitButtonState createState() {
    return new _UnitButtonState();
  }

  static void saveButtonSize(
      BuildContext context, int maxChars, double maxWidth, double maxHeight) {
    final container = ButtonStateContainer.of(context);
    final fontWidthFactor = maxChars == 1 ? 1.1 : 0.7;
    final fontSizeByWidth = maxWidth / (maxChars * fontWidthFactor);
    final fontSizeByHeight = maxHeight / 1.8;
    final buttonFontSize = min(fontSizeByHeight, fontSizeByWidth);
    final buttonRadius = min(maxWidth, maxHeight) / 8.0;

    final buttonWidth = (maxChars == 1)
        ? min(maxWidth, maxHeight)
        : buttonFontSize * maxChars * 0.7;
    final buttonHeight = (maxChars == 1)
        ? min(maxWidth, maxHeight)
        : min(maxHeight, maxWidth * 0.75);
    print(
        'width: ${buttonWidth} height: ${buttonHeight} maxWidth: ${maxWidth} maxHeight: ${maxHeight} maxChars: ${maxChars}');
    print(
        'fontsize: ${buttonFontSize} fontSizeByWidth: ${fontSizeByWidth} fontSizeByHeight ${fontSizeByHeight}');
    container.updateButtonConfig(
        fontSize: buttonFontSize,
        width: buttonWidth,
        height: buttonHeight,
        radius: buttonRadius);
  }
}

class _UnitButtonState extends State<UnitButton> {
  Unit _unit;
  bool _isLoading = true;
  UnitMode _unitMode;

  Widget widgetDots;
  @override
  void initState() {
    super.initState();
    _unitMode = widget.unitMode;

    _getData();
  }

  @override
  void didUpdateWidget(UnitButton oldWidget) {
    if (widget.text != oldWidget.text && widget.flag == 1) {
      _getData();
    }
  }

  void _getData() async {
    _isLoading = true;
    _unit = await new UnitRepo().getUnit(widget.text.toLowerCase());
    if (!widget.forceUnitMode &&
        ((_unitMode == UnitMode.audio && (_unit.sound?.length ?? 0) == 0) ||
            (_unitMode == UnitMode.image && (_unit.image?.length ?? 0) == 0))) {
      _unitMode = UnitMode.text;
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.showHelp
        ? new GestureDetector(
            onLongPress: () {
              AppStateContainer.of(context).playWord(widget.text.toLowerCase());
              if (_unit != null && _unitMode != UnitMode.audio) {
                AppStateContainer.of(context).display(context, widget.text);
              }
            },
            child: _buildButton(context))
        : _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    // double affectHeight=widget.maxWidth ?? buttonConfig.width;
    final buttonConfig = ButtonStateContainer.of(context)?.buttonConfig;
    double affectwidth = widget.maxWidth ?? buttonConfig.width;
    double affectHeight = widget.maxHeight ?? buttonConfig.height;
    double widthOfButton = affectwidth - 10;
    double heightOfButton = affectHeight - 5;
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
        constraints: BoxConstraints.tightFor(
            height: widget.maxHeight ?? heightOfButton,
            width: widget.maxWidth ?? widthOfButton),
        // color: Colors.white,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black,
            borderRadius:
                BorderRadius.all(Radius.circular(buttonConfig?.radius ?? 8.0))),
      ),
      Container(
          constraints: BoxConstraints.tightFor(
              height: widget.maxHeight ?? buttonConfig.height,
              width: widget.maxWidth ?? buttonConfig.width),
          decoration: new BoxDecoration(
              image: widget.bgImage != null
                  ? new DecorationImage(
                      image: new AssetImage(widget.bgImage),
                      fit: BoxFit.contain)
                  : null),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(buttonConfig?.radius ?? 8.0))),
            elevation: 5.0,
            child: FlatButton(
                color: widget.highlighted
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                splashColor: Theme.of(context).accentColor,
                highlightColor: Theme.of(context).accentColor,
                disabledColor: Color(0xFFDDDDDD),
                onPressed: widget.disabled
                    ? null
                    : () {
                        AppStateContainer.of(context)
                            .play(widget.text.toLowerCase());
                        widget.onPress();
                      },
                padding: EdgeInsets.all(0.0),
                shape: new RoundedRectangleBorder(
                    side: new BorderSide(
                        color: widget.disabled
                            ? Color(0xFFDDDDDD)
                            : widget.primary
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                        width: 4.0),
                    borderRadius: BorderRadius.all(
                        Radius.circular(buttonConfig?.radius ?? 8.0))),
                child: _buildUnit(widget.fontSize ?? buttonConfig.fontSize)),
          )),
    ]);
  }

  Widget _buildUnit(double fontSize) {
    int rowSize = 1;
    int checkingNumber = 0;

    if (int.tryParse(widget.text) != null) {
      checkingNumber = int.tryParse(widget.text);
      if (checkingNumber > 9) {
        checkingNumber = 0;
      }
    }
    if (checkingNumber > 0) {
      List numberDots = new List(checkingNumber);
      if (numberDots.length > 5) {
        rowSize = 2;
      } else {
        rowSize = 1;
      }

      List<Widget> rows = new List<Widget>();

      for (var i = 0; i < rowSize + 1; ++i) {
        List<Widget> cells = numberDots.skip(i * 5).take(5).map((e) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: new Icon(
              Icons.lens,
              color: Colors.black,
              size: 13.0,
            ),
          );
        }).toList(growable: false);
        rows.add(Row(
          children: cells,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
      }

      widgetDots = Column(
        children: rows,
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      widgetDots = null;
    }

    if (_unitMode == UnitMode.audio) {
      return new Icon(Icons.volume_up);
    } else if (_unitMode == UnitMode.image) {
      return _isLoading
          ? new Container()
          : new Image.file(
              File(AppStateContainer.of(context).extStorageDir + _unit.image),
              fit: BoxFit.cover,
            );
    }
    return widgetDots == null
        ? Center(
            child: Text(widget.text,
                style: new TextStyle(
                    color: widget.highlighted || !widget.primary
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: fontSize)))
        : Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text("${widget.text}",
                style: new TextStyle(
                    color: widget.highlighted || !widget.primary
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: fontSize / 2)),
            widgetDots
          ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
