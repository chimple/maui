import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/home/home_screen.dart';
import 'package:maui/quack/main_collection.dart';
import 'package:maui/quack/story_page.dart';
import 'package:maui/screens/Page_Route.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/components/animations.dart';

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
    "Story"
  ];
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final media = MediaQuery.of(context);
    final fontSizeFactor =
        max(1.0, min(media.size.height, media.size.width) / 600);
    var user = AppStateContainer.of(context).state.loggedInUser;

    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:
            Theme.of(context).textTheme.apply(fontSizeFactor: fontSizeFactor),
      ),
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            appBarTitleList[_currentIndex],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            Container(
              child: new IconButton(
                iconSize: 38.0,
                icon: new Center(
                  child: new Image.asset("assets/Wallet.png"),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => Animations(),
                  );
                  // Perform some action
                },
              ),
              // padding: EdgeInsets.only(top: 20.0, right: 20.0),
            ),
            Container(
              child: Text(
                "${user.points}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.only(top: 20.0, right: 20.0),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(new NewPageRoute());
              },
              splashColor: Colors.white,
              child: CircleAvatar(
                child: new Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: new ShapeDecoration(
                        shape: CircleBorder(
                            side: BorderSide(
                                color: Colors.blueAccent,
                                width: 1.0,
                                style: BorderStyle.solid)),
                        image: new DecorationImage(
                            image: new FileImage(new File(user.image)),
                            fit: BoxFit.fill))),
                radius: 20.0,
              ),
            ),
          ],
          leading: new IconButton(
            icon: new Center(
              child: new Image.asset("assets/quack_header.png"),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => Animations(),
              );
              // Perform some action
            },
          ),
          backgroundColor: tabsColorList[_currentIndex],
        ),
        bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
//                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                color: _currentIndex == 0
                    ? tabsColorList[_currentIndex]
                    : Color(0xFF0E4476),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/news_feed.png",
                      height: 35.0,
                      width: 35.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).home),
              title: new Container(),
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 1
                      ? tabsColorList[_currentIndex]
                      : Color(0xFF0E4476),
//                shape: BoxShape.rectangle,
                  // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/messenger.png",
                      height: 35.0,
                      width: 35.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).chat),
              title: new Container(),
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  color: _currentIndex == 2
                      ? tabsColorList[_currentIndex]
                      : Color(0xFF0E4476),
                  shape: BoxShape.rectangle,
                  // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/quackicon.png",
                      height: 35.0,
                      width: 35.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).category),
              title: new Container(),
            ),
            BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    color: _currentIndex == 3
                        ? tabsColorList[_currentIndex]
                        : Color(0xFF0E4476),
                    shape: BoxShape.rectangle,
                    // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  width: (mediaQuery.size.width) / 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: new Image.asset(
                        "assets/games.png",
                        height: 35.0,
                        width: 35.0,
                      ),
                    ),
                  ),
                ),
                // title: Text(Loca.of(context).game),
                title: new Container()),
            BottomNavigationBarItem(
              // activeIcon: _currentUserImage,
              icon: Container(
//              margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                decoration: BoxDecoration(
                  color: _currentIndex == 4
                      ? tabsColorList[_currentIndex]
                      : Color(0xFF0E4476),
                ),
                width: (mediaQuery.size.width) / 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: new Image.asset(
                      "assets/story.png",
                      height: 35.0,
                      width: 35.0,
                    ),
                  ),
                ),
              ),
              // title: Text(Loca.of(context).profile),
              title: new Container(),
            ),
          ],
          onTap: (int i) => setState(() => _currentIndex = i),
        ),
        body: _buildBody(),
        backgroundColor: Color(0xffeeeeee),
      ),
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
      case 4:
        return StoryPage();
        break;
    }
  }
}
