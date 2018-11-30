import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/screens/Page_Route.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/db/entity/notif.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/components/gameaudio.dart';

class FriendStrip extends StatefulWidget {
  const FriendStrip({Key key}) : super(key: key);

  @override
  _FriendStripState createState() {
    return new _FriendStripState();
  }
}

class _FriendStripState extends State<FriendStrip> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initData();
  }

  void _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppStateContainer.of(context).getUsers();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    final user = AppStateContainer.of(context).state.loggedInUser;
    var users = List.from(AppStateContainer.of(context).users);
    var notifs = AppStateContainer.of(context).notifs;
    MediaQueryData media = MediaQuery.of(context);
    return Material(
      elevation: 8.0,
      color: Color(0xFFEF823F),
      child: SafeArea(
        child: SizedBox(
          height: 96.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: users.map((u) {
                    var notif = notifs.firstWhere((n) => n.userId == u.id,
                        orElse: () => Notif(userId: u.id, numNotifs: 0));
                    return SizedBox(
                      width: 96.0,
                      child: FriendItem(
                          id: u.id,
                          name: u.name,
                          imageUrl: u.image,
                          color: u.color,
                          numNotifs: notif.numNotifs,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) =>
                                    new ChatScreen(
                                        myId: user.id,
                                        friend: u,
                                        friendImageUrl: u.image)));
                          }),
                    );
                  }).toList(growable: false),
                ),
              ),
              SizedBox(
                width: 96.0,
                child: FriendItem(
                  replaceWithHoodie: false,
                  id: user.id,
                  name: user.name,
                  imageUrl: user.image,
                  color: user.color,
                  numNotifs: user.points,
                  onTap: () {
                    Navigator.of(context).push(NewPageRoute());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
