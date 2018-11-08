import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/entity/quack_card.dart';

class CardHeader extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;

  CardHeader({Key key, @required this.card, this.parentCardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (card.header == null) return Container();
    if (card.header?.endsWith('.svg')) {
      return Hero(
        tag: '$parentCardId/${card.type}/${card.id}',
        child: SvgPicture.asset(
          card.header,
          allowDrawingOutsideViewBox: false,
          package: 'maui_assets',
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
    return Container();
  }
}
