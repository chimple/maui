import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/state/app_state_container.dart';

class CardHeader extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;
  final double minHeight;
  CardHeader({Key key, @required this.card, this.parentCardId, this.minHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (card.header == null)
      return Container(
        constraints: minHeight == null
            ? null
            : BoxConstraints.loose(Size(minHeight, 10.0)),
      );
    if (card.header?.endsWith('.svg')) {
      return Hero(
        tag: '$parentCardId/${card.type}/${card.id}',
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: card.backgroundColor,
          child: SvgPicture.file(
            File(AppStateContainer.of(context).extStorageDir + card.header),
            allowDrawingOutsideViewBox: false,
          ),
        ),
      );
    } else if (card.header?.endsWith('png') ||
        card.header?.endsWith('JPG') ||
        card.header?.endsWith('jp2') ||
        card.header?.endsWith('jpg') ||
        card.header?.endsWith('gif') ||
        card.header?.endsWith('jpeg')) {
      return Hero(
        tag: '$parentCardId/${card.type}/${card.id}',
        child: Image.file(
          File(AppStateContainer.of(context).extStorageDir + card.header),
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints.loose(Size(minHeight, 10.0)),
    );
  }
}
