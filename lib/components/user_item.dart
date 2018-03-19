import 'dart:io';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:maui/models/models.dart';
import 'package:maui/state/app_state_container.dart';

class UserItem extends StatelessWidget {
  final User user;

  UserItem({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new InkWell(
          onTap: () => AppStateContainer.of(context).setLoggedInUser(user),
          child: new Container(
            width: 120.0,
            height: 120.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  image: new FileImage(new File(user.image)),
                  fit: BoxFit.fill
                )))));
  }
}
