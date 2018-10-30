import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                backgroundImage: FileImage(File(comment.user.image)),
              ),
            ),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(comment.user.name, style: TextStyle(fontSize: 30.0)),
                  new Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: new Text(
                      comment.comment,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
