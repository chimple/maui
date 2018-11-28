import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_comment.dart';
import 'package:maui/actions/post_tile.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_stack.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class QuizOpen extends StatefulWidget {
  final Quiz quiz;
  final CanProceed canProceed;

  const QuizOpen({Key key, this.quiz, this.canProceed}) : super(key: key);

  @override
  QuizOpenState createState() {
    return new QuizOpenState();
  }
}

class QuizOpenState extends State<QuizOpen> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children:
            widget.quiz.choices.map((q) => Text(q)).toList(growable: false),
      ),
      Flexible(
        child: TextField(
          controller: _textController,
          keyboardType: TextInputType.multiline,
          autofocus: true,
          maxLines: 5,
          onChanged: (String text) {
            setState(() {
              _isComposing = text.trim().isNotEmpty;
            });
          },
          decoration: InputDecoration(hintText: 'Write something'),
          onSubmitted: _handleSubmitted,
        ),
      ),
      IconButton(
        icon: Icon(Icons.send),
        onPressed:
            _isComposing ? () => _handleSubmitted(_textController.text) : null,
      )
    ]);
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    Provider.dispatch<RootState>(
        context,
        AddComment(
            comment: Comment(
                id: Uuid().v4(),
                parentId: widget.quiz.id,
                userId: AppStateContainer.of(context).state.loggedInUser.id,
                timeStamp: DateTime.now(),
                comment: text,
                user: AppStateContainer.of(context).state.loggedInUser),
            tileType: TileType.card,
            addTile: true));
    widget.canProceed();
  }
}
