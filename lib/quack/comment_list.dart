import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/comment_card.dart';
import 'package:maui/repos/comment_repo.dart';

class CommentList extends StatelessWidget {
  final String parentId;
  final TileType tileType;

  const CommentList({Key key, this.parentId, this.tileType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('CommentList:build');
    return Connect<RootState, List<Comment>>(
      convert: (state) => state.comments,
      where: (prev, next) {
        print('CommentList:where "$prev" "$next"');
        return next != prev;
      },
      builder: (comments) {
        print('CommentList:builder: $comments');
        return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => CommentCard(
                    comment: comments[index],
                  ),
              childCount: comments?.length ?? 0),
        );
      },
      nullable: true,
    );
  }
}
