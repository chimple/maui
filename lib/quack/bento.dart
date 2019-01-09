import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/home/home_screen.dart';
import 'package:maui/quack/fab_icon.dart';
import 'package:maui/quack/friend_strip.dart';

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
