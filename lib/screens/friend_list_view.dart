import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:maui/components/friend_item.dart';
import 'package:maui/components/firebase_grid.dart';

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
  Widget build(BuildContext context) {
    return new FirebaseAnimatedGrid(
        query: usersRef,
        sort: (a, b) => b.key.compareTo(a.key),
        padding: new EdgeInsets.all(8.0),
        itemBuilder: (_, DataSnapshot snapshot) {
          return new FriendItem(
              id: snapshot.value['id'], imageUrl: snapshot.value['image']);
        });
  }
}
