import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/entity/quack_card.dart';

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
          child: SvgPicture.asset(
            card.header,
            allowDrawingOutsideViewBox: false,
            package: 'maui_assets',
          ),
        ),
      );
    } else if (card.header?.endsWith('png') ||
        card.header?.endsWith('jpg') ||
        card.header?.endsWith('jpeg')) {
      return Hero(
        tag: '$parentCardId/${card.type}/${card.id}',
        child: Image.asset(
          card.header,
          fit: BoxFit.cover,
          package: 'maui_assets',
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
