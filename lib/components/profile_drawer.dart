import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/components/played_games_score.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/screens/login_screen.dart';
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
            currentAccountPicture: new Container(
                  child: new GestureDetector(
                    child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(40.0),
                          border: new Border.all(
                            width: 3.0,
                            color: Colors.black
                          )
                        ),
                        child: new CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: new FileImage(new File(user.image),),
                      ),
                    ),
                    onTap: () {
                      //Navigate to Camera Screen
                      print("Hello World..!!");
                    },
                )),
            accountName: new Text('${user.name}',
                                    textAlign: TextAlign.left, 
                                    style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
            accountEmail: new Text('${user.name}@Chimple.org',
                                    textAlign: TextAlign.left, 
                                    style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.indigo),
                                    ),
          ),
          new Expanded(
            child: new PlayedGamesScoreDisplay(),
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
      child: Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(30.0),
            border: new Border.all(
              width: 3.0,
              color: Colors.black
            )
          ),
          child: new CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: new FileImage(new File(user.image),),
        ),
      ),
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
    ));
  }
}
