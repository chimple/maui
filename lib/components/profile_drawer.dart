import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new Drawer(
        child: new ListView(
      primary: false,
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: new Text('test'),
          accountEmail: new Text('test@chimple.org'),
          currentAccountPicture: new Image.file(new File(user.image)),
        ),
        new Text('hello')
      ],
    ));
  }
}

class ProfileDrawerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new FlatButton(
        child: new CircleAvatar(
          child: new Image.file(new File(user.image)),
          backgroundColor: Colors.white,
        ),
        onPressed: () => Scaffold.of(context).openDrawer());
  }
}
