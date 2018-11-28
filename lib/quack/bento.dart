import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/home/home_screen.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/fab_icon.dart';
import 'package:maui/quack/friend_strip.dart';
import 'package:maui/quack/post_comments.dart';

class Bento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final fontSizeFactor =
        max(1.0, min(media.size.height, media.size.width) / 600);
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:
            Theme.of(context).textTheme.apply(fontSizeFactor: fontSizeFactor),
      ),
      child: Scaffold(
        backgroundColor: Color(0xffeeeeee),
        floatingActionButton: FancyFab(),
        body: Column(
          children: <Widget>[
            FriendStrip(),
            Expanded(
              child: HomeScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
