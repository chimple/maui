import 'package:flutter/material.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/comment_card.dart';
import 'package:maui/quack/comment_text_field.dart';

class CommentList extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final List<Comment> comments;
  final bool showInput;
  final Function(Comment, TileType, bool) onAdd;

  const CommentList(
      {Key key,
      this.parentId,
      this.tileType,
      this.showInput = true,
      this.comments,
      this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => index == 0 && showInput
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CommentTextField(
                    parentId: parentId,
                    tileType: tileType,
                    onAdd: onAdd,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CommentCard(
                    comment: comments[index - (showInput ? 1 : 0)],
                  ),
                ),
          childCount: (comments?.length ?? 0) + (showInput ? 1 : 0)),
    );
  }
}
