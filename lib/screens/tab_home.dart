import 'dart:async';
import 'dart:io';

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
  List<Color> tabsColorList = [
    Color(0xFFEF823F),
    Color(0xFF5BBB93),
    Color(0xFFF5C851),
    Color(0xFF7CC5F2),
    Color(0xFFEF3F69)
  ];
  List<String> appBarTitleList = [
    "News Feed",
    "Friend's Messenger",
    "Quack",
    "Games",
    "Profile"
  ];
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var user = AppStateContainer.of(context).state.loggedInUser;
    final _currentUserImage = new Container(
      height: 28.0,
      width: 28.0,
      child: CircleAvatar(
        backgroundImage: FileImage(File(user.image)),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text(appBarTitleList[_currentIndex]),
        centerTitle: true,
        leading: new FlatButton(
          child: new Center(
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
              title: Container(
                width: (mediaQuery.size.width) / 5,
                color: _currentIndex == 0
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
                child: new Image.asset(
                  "assets/news_feed.png",
                  height: 28.0,
                  width: 28.0,
                ),
              ),
              // title: Text(Loca.of(context).home),
              icon: new Text(""),
            ),
            BottomNavigationBarItem(
              title: Container(
                width: (mediaQuery.size.width) / 5,
                color: _currentIndex == 1
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
                child: new Image.asset(
                  "assets/messenger.png",
                  height: 28.0,
                  width: 28.0,
                ),
              ),
              // title: Text(Loca.of(context).chat),
              icon: new Text(""),
            ),
            BottomNavigationBarItem(
              title: Container(
                width: (mediaQuery.size.width) / 5,
                color: _currentIndex == 2
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
                child: new Image.asset(
                  "assets/quack.png",
                  height: 28.0,
                  width: 28.0,
                ),
              ),
              // title: Text(Loca.of(context).category),
              icon: new Text(""),
            ),
            BottomNavigationBarItem(
              title: Container(
                width: (mediaQuery.size.width) / 5,
                color: _currentIndex == 3
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
                child: new Image.asset(
                  "assets/games.png",
                  height: 28.0,
                  width: 28.0,
                ),
              ),
              // title: Text(Loca.of(context).game),
              icon: new Text(""),
            ),
            BottomNavigationBarItem(
              // activeIcon: _currentUserImage,
              title: _currentIndex == 4
                  ? Container(
                      width: (mediaQuery.size.width) / 5,
                      color: _currentIndex == 4
                          ? tabsColorList[_currentIndex]
                          : Color(0xFF0E4476),
                      child: _currentUserImage,
                    )
                  : Container(
                      width: (mediaQuery.size.width) / 5,
                      color: _currentIndex == 4
                          ? tabsColorList[_currentIndex]
                          : Color(0xFF0E4476),
                      child: new Image.asset(
                        "assets/profile.png",
                        height: 28.0,
                        width: 28.0,
                      ),
                    ),
              // title: Text(Loca.of(context).profile),
              icon: new Text(""),
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
