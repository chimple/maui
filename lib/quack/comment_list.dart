import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/comment_card.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/repos/comment_repo.dart';

class CommentList extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final bool showInput;

  const CommentList(
      {Key key, this.parentId, this.tileType, this.showInput = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Connect<RootState, List<Comment>>(
      convert: (state) => state.commentMap[parentId],
      where: (prev, next) {
        return next != prev;
      },
      builder: (comments) {
        print(comments);
        return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => index == 0 && showInput
                  ? Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CommentTextField(
                        parentId: parentId,
                        tileType: tileType,
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
      },
      nullable: true,
    );
  }
}
