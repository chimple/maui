import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:flores/flores.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/db/entity/notif.dart';
import 'package:maui/screens/chat_screen.dart';

class FriendListView extends StatefulWidget {
  const FriendListView({Key key}) : super(key: key);

  @override
  _FriendListViewState createState() {
    return new _FriendListViewState();
  }
}

class _FriendListViewState extends State<FriendListView> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initData();
  }

  void _initData() async {
    await AppStateContainer.of(context).getUsers();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    var appUsers = AppStateContainer.of(context).users;
    print('FriendListView.users $appUsers');
    var users = [user];
    if (appUsers != null) users.addAll(appUsers);
    var notifs = AppStateContainer.of(context).notifs;
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return Container(

          color: const Color(0xff36C5E4),
          child: new GridView.count(
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          crossAxisCount: media.size.height > media.size.width ? 3 : 4,
          children: users.map((u) {
            var notif = notifs.firstWhere((n) => n.userId == u.id,
                orElse: () => Notif(userId: u.id, numNotifs: 0));
            return FriendItem(
                id: u.id,
                imageUrl: u.image,
                numNotifs: notif.numNotifs,
                onTap: () => user.id == u.id
                    ? Navigator.of(context).pushNamed('/chatbot')
                    : Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) => new ChatScreen(
                            myId: user.id,
                            friendId: u.id,
                            friendImageUrl: u.image))));
          }).toList(growable: false),
        ),
    );
  }
}
