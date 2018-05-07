import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class LoginUserItem extends StatelessWidget {
  final User user;

  LoginUserItem({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(user);
    return new Center(
        child: new InkWell(
            onTap: () => AppStateContainer.of(context).setLoggedInUser(user),
            child: new UserItem(user: user)));
  }
}

class UserItem extends StatelessWidget {
  final User user;

  UserItem({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        width: 120.0,
        height: 120.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: new FileImage(new File(user.image)), fit: BoxFit.fill)));
  }
}
