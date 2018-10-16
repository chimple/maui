import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/like_button.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

typedef void AddComment(Comment comment);

class CommentTextField extends StatefulWidget {
  final String parentId;
  final TileType tileType;
  final AddComment addComment;

  const CommentTextField(
      {Key key, this.parentId, this.tileType, this.addComment})
      : super(key: key);

  @override
  CommentTextFieldState createState() {
    return new CommentTextFieldState();
  }
}

class CommentTextFieldState extends State<CommentTextField> {
  final TextEditingController _textController = new TextEditingController();
  FocusNode _focusNode;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: LikeButton(
            parentId: widget.parentId,
            tileType: widget.tileType,
            userId: AppStateContainer.of(context).state.loggedInUser.id,
          )),
      Flexible(
        child: new TextField(
          maxLength: null,
          keyboardType: TextInputType.multiline,
          controller: _textController,
          focusNode: _focusNode,
          onChanged: (String text) {
            setState(() {
              _isComposing = text.trim().isNotEmpty;
            });
          },
          onSubmitted: (String text) => _handleSubmitted(context, text),
          decoration:
              new InputDecoration.collapsed(hintText: Loca().addAComment),
        ),
      ),
      Container(
          margin: new EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            icon: new Icon(Icons.send),
            onPressed: _isComposing
                ? () => _handleSubmitted(context, _textController.text)
                : null,
          )),
    ]);
  }

  Future<Null> _handleSubmitted(BuildContext context, String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    final comment = Comment(
        id: Uuid().v4(),
        parentId: widget.parentId,
        userId: AppStateContainer.of(context).state.loggedInUser.id,
        comment: text,
        timeStamp: DateTime.now(),
        user: AppStateContainer.of(context).state.loggedInUser);
    await CommentRepo().insert(comment, widget.tileType);
    widget.addComment(comment);
    _focusNode.unfocus();
  }
}
