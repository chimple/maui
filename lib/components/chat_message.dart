import 'dart:io';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {@required this.snapshot,
      @required this.animation,
      this.image,
      this.imageUrl});
  final DataSnapshot snapshot;
  final Animation animation;
  final String imageUrl;
  final String image;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                  backgroundImage: image != null
                      ? new FileImage(new File(image))
                      : new NetworkImage(imageUrl)),
            ),
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: snapshot.value['imageUrl'] != null
                    ? new Image.network(
                        snapshot.value['imageUrl'],
                        width: 250.0,
                      )
                    : new Text(snapshot.value['text']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
