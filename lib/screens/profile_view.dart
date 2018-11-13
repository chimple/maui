import 'dart:io';
import 'package:maui/quack/user_collection.dart';
import 'package:maui/quack/user_drawing_grid.dart';
import 'package:maui/quack/user_progress.dart';
import '../loca.dart';
import 'package:flutter/material.dart';
import '../state/app_state_container.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  List<String> categories = ["gallery", "collection", "progress"];
  TabController tabController;

  @override
  void initState() {
    super.initState();
    print("Welcome to QuizProgressTracker class");
    tabController = new TabController(length: categories.length, vsync: this);
  }

  Widget getTabBar() {
    return TabBar(
        isScrollable: false,
        indicatorColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 5.0,
        labelColor: Colors.black,
        labelStyle: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal),
        controller: tabController,
        tabs: [
          new Tab(text: Loca.of(context).gallery),
          new Tab(text: Loca.of(context).collection),
          new Tab(text: Loca.of(context).progress),
        ]);
  }

  Widget getTabBarPages() {
    return Expanded(
      child: TabBarView(controller: tabController, children: <Widget>[
        UserDrawingGrid(),
        UserCollection(),
        UserProgress(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = media.orientation;
    var user = AppStateContainer.of(context).state.loggedInUser;

    return Scaffold(
      body: SafeArea(
        // top: false,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              alignment: new FractionalOffset(0.0, 1.0),
              child: new IconButton(
                  icon: new Icon(Icons.cancel),
                  iconSize: 40.0,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            new Container(
                height: 125.0,
                width: 125.0,
                decoration: new BoxDecoration(
                    border: new Border.all(width: 3.0, color: Colors.blueAccent),
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        image: new FileImage(new File(user.image)),
                        fit: BoxFit.fill))),
            new SizedBox(height: 25.0),
            new Text(
              "${user.name}",
              style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            getTabBar(),
            getTabBarPages()
          ],
        ),
      ),
    );
  }
}
