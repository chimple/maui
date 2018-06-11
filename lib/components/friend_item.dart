import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class FriendItem extends StatelessWidget {
  String id;
  String imageUrl;
  bool isFile;
  FriendItem(
      {Key key, @required this.id, @required this.imageUrl, this.isFile = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;

    final encImageUrl = imageUrl.replaceAll(new RegExp(r'/'), '&#x2F;');
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Center(
          child: new InkWell(
              onTap: () => user.id == id
                  ? Navigator.of(context).pushNamed('/chatbot')
                  : Navigator.of(context).pushNamed('/chat/$id/$encImageUrl'),
              child: new Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: user.id == id
                              ? new AssetImage('assets/koala_neutral.png')
                              : isFile
                                  ? NetworkImage(imageUrl)
                                  : MemoryImage(base64.decode(imageUrl)),
                          fit: BoxFit.fill))))),
    );
  }
}
