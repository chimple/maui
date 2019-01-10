import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool like;
  final Function onLike;
  final bool isInteractive;

  const LikeButton({Key key, this.like, this.isInteractive = true, this.onLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (like ?? false)
      return Icon(
        Icons.favorite_border,
        color: Colors.red,
      );
    else if (!isInteractive) {
      return Icon(
        Icons.favorite_border,
        color: Colors.black,
      );
    } else {
      return InkWell(
        child: Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        onTap: () => (!isInteractive) ? null : onLike(),
      );
    }
  }
}
