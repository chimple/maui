import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/components/firebase_grid.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:flores/flores.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/screens/chat_screen.dart';

final usersRef = FirebaseDatabase.instance.reference().child('users');

class FriendListView extends StatefulWidget {
  const FriendListView({Key key}) : super(key: key);

  @override
  _FriendListViewState createState() {
    return new _FriendListViewState();
  }
}

class _FriendListViewState extends State<FriendListView> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    await AppStateContainer.of(context).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    var users = AppStateContainer.of(context).users;
    MediaQueryData media = MediaQuery.of(context);
    if (users == null) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return GridView.count(
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      crossAxisCount: media.size.height > media.size.width ? 3 : 4,
      children: users.map((u) {
        return FriendItem(
            id: u.id,
            imageUrl: u.image,
            onTap: () => user.id == u.id
                ? Navigator.of(context).pushNamed('/chatbot')
                : Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder: (BuildContext context) => new ChatScreen(
                        myId: user.id,
                        friendId: u.id,
                        friendImageUrl: u.image))));
      }).toList(growable: false),
    );
  }
}
