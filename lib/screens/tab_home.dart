import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/home/home_screen.dart';
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
          onTap: (int i) => setState(() => _currentIndex = i)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen();
        break;
      case 1:
        return FriendListView();
        break;
      case 2:
        return CardPager(
          cardId: 'main',
          cardType: CardType.concept,
          initialPage: 0,
        );
        break;
      case 3:
        return GameListView();
        break;
      case 4:
        return ProfileView();
        break;
    }
  }
}
