import 'dart:io';
import 'package:flutter/material.dart';
import 'package:badge/badge.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/db/entity/user.dart';
import 'package:meta/meta.dart';

class FriendItem extends StatelessWidget {
  String id;
  String imageUrl;
  int color;
  List<int> imageMemory;
  bool isFile;
  Function onTap;
  int numNotifs;
  bool replaceWithHoodie;
  FriendItem(
      {Key key,
      @required this.id,
      this.color = 0xFF48AECC,
      this.imageUrl,
      this.imageMemory,
      this.onTap,
      this.numNotifs = 0,
      this.replaceWithHoodie = true,
      this.isFile = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    print('FriendItem: $id $imageUrl');

    final encImageUrl = imageUrl.replaceAll(new RegExp(r'/'), '&#x2F;');
    return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Center(
          child: numNotifs > 0
              ? Badge(value: '$numNotifs', child: _buildFriendItem(id, user))
              : _buildFriendItem(id, user),
        ));
  }

  Widget _buildFriendItem(String id, User user) {
    return new InkWell(
        onTap: onTap,
        child: new Stack(
          children: <Widget>[
            new Center(
                child: new CircleAvatar(
              radius: 80.0,
//                maxRadius: 40.0,
              backgroundImage:
                  new AssetImage("assets/chat_image/chat icon_01.png"),
              child: new Center(
                child: RawMaterialButton(
                  elevation: 20.0,

                  shape: new CircleBorder(
                    side: new BorderSide(
                      color: Color(color),
                      width: 5.0,
                    ),
                  ),
                  child: new CircleAvatar(
                      radius: 50.0,
                      child: new Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  image: replaceWithHoodie && user.id == id
                                      ? new AssetImage(
                                          'assets/koala_neutral.png')
                                      : isFile
                                          ? FileImage(File(imageUrl))
                                          : imageMemory != null
                                              ? MemoryImage(imageMemory)
                                              : AssetImage(
                                                  'assets/hoodie_bear.png'),
                                  fit: BoxFit.fill)))),
//                            child: new Container(
//                                width: 100.0,
//                                height: 100.0,
//                        decoration: new BoxDecoration(
//                              shape: BoxShape.circle,
//
//                              image: new DecorationImage(
//                                  image: replaceWithHoodie && user.id == id
//                                      ? new AssetImage('assets/koala_neutral.png')
//                                      : isFile
//                                      ? FileImage(File(imageUrl))
//                                      : imageMemory != null
//                                      ? MemoryImage(imageMemory)
//                                      : AssetImage('assets/hoodie_bear.png'),
//                                  fit: BoxFit.fill))),
                ),
              ),
            )),
          ],
        ));
  }
}
