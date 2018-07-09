import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';
import './score.dart' as score;
import './graph.dart' as graph;
import 'package:maui/screens/login_screen.dart';
import 'package:maui/state/app_state_container.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  ProfileDrawerState createState() {
    return new ProfileDrawerState();
  }
}

class ProfileDrawerState extends State<ProfileDrawer>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            currentAccountPicture: new CircleAvatar(
                radius: 1000.0,
                backgroundColor: Colors.white,
                child: new Image.file(new File(user.image))),
            accountName: new Text('test'),
            accountEmail: new Text('test@chimple.org'),
          ),
          new TabBar(
            controller: controller,
            tabs: <Tab>[
              new Tab(
                  child: new Text("Score",
                      style:
                          new TextStyle(color: Colors.blue, fontSize: 30.0))),
              new Tab(
                  child: new Text("Graph",
                      style:
                          new TextStyle(color: Colors.blue, fontSize: 30.0))),
            ],
          ),
          new Expanded(
            child: new TabBarView(
              controller: controller,
              children: <Widget>[new score.Score(), new graph.Graph()],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileDrawerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;

    return new Container(
        child: new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: new FileImage(new File(user.image)),
      ),
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
    ));
  }
}
