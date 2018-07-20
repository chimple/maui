import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/components/played_games_score.dart';
import 'package:maui/components/videoplayer.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/components/gameaudio.dart';

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
    //  play.tap();
    return new Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: new Color(0xffF0557F),
            ),
            otherAccountsPictures: <Widget>[
              GestureDetector(
                onTap: () {
                  button3(context);
                  print("valueme incresing");
                },
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: new Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(100.0),
                    ),
                    child: new Center(
                      child: Image.asset('assets/videohelp.png'),
                    ),
                  ),
                ),
              )
            ],
            currentAccountPicture: new Container(
                child: new GestureDetector(
              child: Container(
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    border: new Border.all(width: 3.0, color: Colors.black)),
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: new FileImage(
                    new File(user.image),
                  ),
                ),
              ),
              onTap: () {
                //Navigate to Camera Screen
                print("Hello World..!!");
              },
            )),
            accountName: new Text(
              '${user.name}',
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            accountEmail: new Text(' '),
          ),
          new Expanded(
            child: new PlayedGamesScoreDisplay(),
          )
        ],
      ),
    );
  }

  void button3(BuildContext context) {
    print("Button 1");
    String tutorial = "tutorial";
    final gamename = tutorial;
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new VideoApp(gamename: gamename)));
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
            border: new Border.all(width: 3.0, color: Colors.black)),
        child: new CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: new FileImage(
            new File(user.image),
          ),
        ),
      ),
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
    ));
  }
}
