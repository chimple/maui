import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/quack/card_pager.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/loca.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/screens/home_page_view.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'profile_view.dart';

class TabHome extends StatefulWidget {
  TabHome({Key key}) : super(key: key);

  @override
  TabHomeState createState() {
    return new TabHomeState();
  }
}

class TabHomeState extends State<TabHome> {
  int _currentIndex = 0;
  Widget _body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(Loca.of(context).home),
              backgroundColor: Colors.redAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text(Loca.of(context).chat),
              backgroundColor: Colors.pinkAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library),
              title: Text(Loca.of(context).category),
              backgroundColor: Colors.greenAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              title: Text(Loca.of(context).game),
              backgroundColor: Colors.blueAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(Loca.of(context).profile),
              backgroundColor: Colors.orangeAccent),
        ],
        onTap: _onTap,
      ),
      body: _body,
    );
  }

  void _onTap(int i) {
    setState(() {
      _currentIndex = i;
      switch (i) {
        case 0:
          _body = HomePageView();
          break;
        case 1:
          _body = FriendListView();
          break;
        case 2:
          _body = CardPager(
            cardId: 'main',
            cardType: CardType.concept,
            initialPage: 0,
          );
          break;
        case 3:
          _body = GameListView();
          break;
        case 4:
          _body = ProfileView();
          break;
      }
    });
  }
}
