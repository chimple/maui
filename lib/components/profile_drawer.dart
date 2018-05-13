import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';
import './score.dart' as score;
import './graph.dart' as graph;

class ProfileDrawer extends StatefulWidget {
  @override
  ProfileDrawerState createState() {
    return new ProfileDrawerState();
  }
}

class ProfileDrawerState extends State<ProfileDrawer> with SingleTickerProviderStateMixin{
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
                  accountName: new Text('test'),
                  accountEmail: new Text('test@chimple.org'),
                  currentAccountPicture: new Image.file(new File(user.image)),
            ),
          
            new TabBar(
            controller: controller,
              tabs: <Tab>[
                  new Tab( child: new Text("Score",style: new TextStyle( color: Colors.blue , fontSize: 30.0))),
                  new Tab( child: new Text("Graph",style: new TextStyle( color: Colors.blue , fontSize: 30.0))),
                ],
              ),

            new Expanded(
                child: new TabBarView(
                controller: controller,
                children: <Widget>[
                  new score.Score(),
                  new graph.Graph()
                ],
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
    return new FlatButton(
        child: new CircleAvatar(
          backgroundImage: new FileImage(new File(user.image)),
          backgroundColor: Colors.white,
        ),
        onPressed: () => Scaffold.of(context).openDrawer());
  }
}
