import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_comment.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/like_button.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class CommentTextField extends StatefulWidget {
  final String parentId;
  final TileType tileType;

  const CommentTextField({Key key, this.parentId, this.tileType})
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(40.0), right: Radius.circular(40.0)),
        ),
        child: Row(children: <Widget>[
          Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: LikeButton(
                parentId: widget.parentId,
                tileType: widget.tileType,
              )),
          Flexible(
            child: new TextField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
              ),
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
//              iconSize: 20.0,
                color: Colors.blue,
                icon: new Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(context, _textController.text)
                    : null,
              )),
        ]),
      ),
    );
  }

  Future<Null> _handleSubmitted(BuildContext context, String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    Provider.dispatch<RootState>(
      context,
      AddComment(
          comment: Comment(
              id: Uuid().v4(),
              parentId: widget.parentId,
              userId: AppStateContainer.of(context).state.loggedInUser.id,
              timeStamp: DateTime.now(),
              comment: text,
              user: AppStateContainer.of(context).state.loggedInUser),
          tileType: widget.tileType),
    );
    _focusNode.unfocus();
  }
}
