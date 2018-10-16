import 'package:flutter/material.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/comment_card.dart';
import 'package:maui/repos/comment_repo.dart';

class CommentList extends StatefulWidget {
  final String parentId;
  final TileType tileType;

  const CommentList({Key key, this.parentId, this.tileType}) : super(key: key);

  @override
  CommentListState createState() {
    return new CommentListState();
  }
}

class CommentListState extends State<CommentList> {
  bool _isLoading = true;
  List<Comment> _comments;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void addComment(Comment comment) {
    setState(() {
      if (_comments == null) {
        _comments = [];
      }
      _comments.add(comment);
    });
  }

  void initData() async {
    _comments = await CommentRepo()
        .getCommentsByParentId(widget.parentId, widget.tileType);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => CommentCard(
                comment: _comments[index],
              ),
          childCount: _comments?.length ?? 0),
    );
  }
}
