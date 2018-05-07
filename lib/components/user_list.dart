import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:meta/meta.dart';

import 'user_item.dart';

class UserList extends StatelessWidget {
  final List<User> users;

  UserList({Key key, @required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        key: new Key('user-list'),
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: users
            .map((user) => new LoginUserItem(
                  key: new Key('user-${user.name}'),
                  user: user,
                ))
            .toList());
  }
}
