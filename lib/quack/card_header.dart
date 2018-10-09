import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/entity/quack_card.dart';

class CardHeader extends StatelessWidget {
  QuackCard card;

  CardHeader({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (card.header?.endsWith('.svg')) {
      return Hero(
        tag: '${card.type}/${card.id}',
        child: SvgPicture.asset(
          card.header,
          allowDrawingOutsideViewBox: false,
        ),
      );
    } else if (card.header?.endsWith('png') ||
        card.header?.endsWith('jpg') ||
        card.header?.endsWith('jpeg')) {
      return Hero(
        tag: '${card.type}/${card.id}',
        child: Image.asset(
          card.header,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container();
  }
}
