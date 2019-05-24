import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:maui/models/display_item.dart';

class DisplayItemWidget extends StatelessWidget {
  final DisplayItem displayItem;
  final Size size;

  const DisplayItemWidget({Key key, this.displayItem, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Center(child: buildInnerChild()),
    );
  }

  Widget buildInnerChild() {
    switch (displayItem.displayType) {
      case DisplayTypeEnum.audio:
        break;
      case DisplayTypeEnum.image:
        return Image.asset(displayItem.image);
        break;
      case DisplayTypeEnum.letter:
        final fontWidthFactor = 1.1;
        final fontSizeByWidth = size.width / fontWidthFactor;
        final fontSizeByHeight = size.height / 1.8;
        final buttonFontSize = min(fontSizeByHeight, fontSizeByHeight);
        return AutoSizeText(
          displayItem.item,
          style: TextStyle(fontSize: 500),
        );
        break;
      case DisplayTypeEnum.syllable:
        break;
      case DisplayTypeEnum.word:
        return AutoSizeText(
          displayItem.item,
          style: TextStyle(fontSize: 200),
        );
        break;
      case DisplayTypeEnum.sentence:
        return AutoSizeText(
          displayItem.item,
          style: TextStyle(fontSize: 200),
        );
        break;
    }
    return Container();
  }
}
