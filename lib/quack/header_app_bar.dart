import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_header.dart';

class HeaderAppBar extends StatelessWidget {
  final bool showBackButton;
  final QuackCard card;
  final String parentCardId;

  const HeaderAppBar(
      {Key key, this.showBackButton, this.card, this.parentCardId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return SliverAppBar(
      automaticallyImplyLeading: showBackButton,
      expandedHeight: media.size.height / 4,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(card.title ?? ''),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CardHeader(
              card: card,
              parentCardId: parentCardId,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, -0.4),
                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
