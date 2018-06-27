import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class FriendItem extends StatelessWidget {
  String id;
  String imageUrl;
  List<int> imageMemory;
  bool isFile;
  Function onTap;
  FriendItem(
      {Key key,
      @required this.id,
      this.imageUrl,
      this.imageMemory,
      this.onTap,
      this.isFile = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('FriendItem: $id $imageUrl');
    var user = AppStateContainer.of(context).state.loggedInUser;

    final encImageUrl = imageUrl.replaceAll(new RegExp(r'/'), '&#x2F;');
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Center(
          child: new InkWell(
              onTap: onTap,
              child: new Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: user.id == id
                              ? new AssetImage('assets/koala_neutral.png')
                              : isFile
                                  ? FileImage(File(imageUrl))
                                  : imageMemory != null
                                      ? MemoryImage(imageMemory)
                                      : AssetImage('assets/hoodie_bear.png'),
                          fit: BoxFit.fill))))),
    );
  }
}
