import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_comment.dart';
import 'package:maui/actions/post_tile.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: widget.quiz.choices
              .map((q) => Container(
                  decoration: new BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      q,
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  )))
              .toList(growable: false),
        ),
      ),
      Flexible(
        child: TextField(
          controller: _textController,
          keyboardType: TextInputType.multiline,
          autofocus: true,
          maxLines: 5,
          style: TextStyle(fontSize: 24.0, color: Colors.black),
          onChanged: (String text) {
            setState(() {
              _isComposing = text.trim().isNotEmpty;
            });
          },
          decoration: InputDecoration(
              fillColor: Colors.grey[110],
              filled: true,
              border: InputBorder.none,
              hintText: Loca.of(context).writeSomething),
          onSubmitted: _handleSubmitted,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(32.0))),
          color: Color(0xFF0E4476),
          padding: EdgeInsets.all(8.0),
          onPressed: _isComposing
              ? () => _handleSubmitted(_textController.text)
              : null,
          child: Text(
            Loca.of(context).post,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
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
