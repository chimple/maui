import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/components/firebase_grid.dart';
import 'package:flores/flores.dart';

final usersRef = FirebaseDatabase.instance.reference().child('users');

class FriendListView extends StatefulWidget {
  const FriendListView({Key key}) : super(key: key);

  @override
  _FriendListViewState createState() {
    return new _FriendListViewState();
  }
}

class _FriendListViewState extends State<FriendListView> {
  List<dynamic> _friends;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    List<dynamic> friends;
    try {
      friends = await Flores().users;
    } on PlatformException {
      print('Failed getting friends');
    }
    print('Friends: $friends');
    if (!mounted) return;
    setState(() {
      _friends = friends;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    if ((_friends?.length ?? 0) == 0) {
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
      children: _friends.map((f) {
        List<int> memoryImage;
        try {
          memoryImage = base64.decode(f['message']);
        } catch (e) {
          print(e);
        }
        return FriendItem(
          id: f['userId'],
          imageUrl: f['message'],
          imageMemory: memoryImage,
          isFile: false,
        );
      }).toList(growable: false),
    );
  }
}
