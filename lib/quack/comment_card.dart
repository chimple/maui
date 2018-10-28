import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: FileImage(File(comment.user.image)),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(comment.comment),
        ))
      ],
    );
  }
}
