import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:maui/app.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/quack/activity_drawing_grid.dart';
import 'package:maui/quack/header_app_bar.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';

class KnowledgeDetail extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;
  final bool showBackButton;

  KnowledgeDetail(
      {key, @required this.card, this.parentCardId, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        LimitedBox(
          maxHeight: size.height * 0.75,
          child: CardHeader(
            card: card,
            parentCardId: parentCardId,
          ),
        ),
        Text(card.title ?? ''),
        Text(card.content ?? '')
      ],
    );
  }
}
