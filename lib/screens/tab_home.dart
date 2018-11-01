import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/profile_drawer.dart';
import 'package:maui/home/home_screen.dart';
import 'package:maui/quack/card_pager.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/quack/main_collection.dart';
import 'package:maui/screens/Page_Route.dart';
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
  List<Color> tabsColorList = [
    Color(0xFFEF823F),
    Color(0xFF5BBB93),
    Color(0xFFF5C851),
    Color(0xFF7CC5F2),
  ];
  List<String> appBarTitleList = [
    "News Feed",
    "Friend's Messenger",
    "Quack",
    "Games",
  ];
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text(appBarTitleList[_currentIndex]),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: Center(
              child: new Image.asset("assets/profile.png"),
            ),
            onPressed: () {
               Navigator.of(context).push(new NewPageRoute());
            },
          ),
        ],
        leading: new IconButton(
          icon: new Center(
            child: new Image.asset("assets/quack_header.png"),
          ),
          onPressed: () {
            print("object");
          },
        ),
        backgroundColor: tabsColorList[_currentIndex],
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(canvasColor: Color(0xFF0E4476)),
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _currentIndex == 0
                        ? tabsColorList[_currentIndex]
                        : Color(0xFF0E4476),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/news_feed.png",
                      height: 28.0,
                      width: 28.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).home),
              title: new Container(
                color: _currentIndex == 0
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _currentIndex == 1
                        ? tabsColorList[_currentIndex]
                        : Color(0xFF0E4476),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/messenger.png",
                      height: 28.0,
                      width: 28.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).chat),
              title: new Container(
                color: _currentIndex == 1
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _currentIndex == 2
                        ? tabsColorList[_currentIndex]
                        : Color(0xFF0E4476),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/quack.png",
                      height: 28.0,
                      width: 28.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).category),
              title: new Container(
                color: _currentIndex == 2
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: _currentIndex == 3
                        ? tabsColorList[_currentIndex]
                        : Color(0xFF0E4476),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/games.png",
                      height: 28.0,
                      width: 28.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).game),
              title: new Container(
                color: _currentIndex == 3
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
              ),
            ),
          ],
          onTap: (int i) => setState(() => _currentIndex = i),
        ),
      ),
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
        return MainCollection();
        break;
      case 3:
        return GameListView();
        break;
    }
  }
}
