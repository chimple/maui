import 'package:flutter/material.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:tahiti/tahiti.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/screens/drawing_list_screen.dart';
import 'package:maui/repos/card_progress_repo.dart';

class DrawingScreen extends StatefulWidget {
  final String activityId;
  final String drawingId;
  DrawingScreen({Key key, this.activityId, this.drawingId}) : super(key: key);

  @override
  DrawingScreenState createState() {
    return new DrawingScreenState();
  }
}

class DrawingScreenState extends State<DrawingScreen> {
  bool _isLoading = true;
  QuackCard _activity;
  DrawingSelect _drawingSelect;

  @override
  void initState() {
    super.initState();
    if (widget.drawingId != null)
      _drawingSelect = DrawingSelect.id;
    else
      _drawingSelect = DrawingSelect.create;
    _initData();
  }

  void _initData() async {
    _activity = await CardRepo().getCard(widget.activityId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User user = AppStateContainer.of(context).state.loggedInUser;
      await CardProgressRepo().upsert(CardProgress(
          cardId: widget.activityId,
          userId: user.id,
          updatedAt: DateTime.now()));
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return Scaffold(
      body: DrawingWrapper(
          activityId: widget.activityId,
          drawingSelect: _drawingSelect,
          drawingId: widget.drawingId,
          title: _activity.content),
    );
  }
}
