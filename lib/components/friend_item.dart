import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  String id;
  String imageUrl;
  FriendItem({Key key, @required this.id, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final encImageUrl = imageUrl.replaceAll(new RegExp(r'/'), '&#x2F;');
    return new Center(
        child: new InkWell(
            onTap: () => Navigator.of(context).pushNamed('/chat/$id/$encImageUrl'),
            child: new Container(
                width: 120.0,
                height: 120.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        image: new NetworkImage(imageUrl),
                        fit: BoxFit.fill
                    )))));
  }
}
