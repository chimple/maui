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
                   otherAccountsPictures: <Widget>[
                      new IconButton(
                        iconSize: 40.0,
                        color: Colors.white,
                        icon: new Icon(Icons.person_outline),
                        onPressed: (){
                          //Navigate here
                          AppStateContainer.of(context).setLoggedInUser(null);
                          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context)=>new LoginScreen()) );
                        },
                      ),
                   ],
                  currentAccountPicture: new Image.file(new File(user.image)),
                  accountName: new Text('test'),
                  accountEmail: new Text('test@chimple.org'),     
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
