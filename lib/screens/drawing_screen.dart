import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:tahiti/tahiti.dart';
import 'package:maui/repos/activity_repo.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/screens/drawing_list_screen.dart';
import 'package:maui/repos/activity_progress_repo.dart';

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
  Activity _activity;
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
    _activity = await ActivityRepo().getActivity(widget.activityId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User user = AppStateContainer.of(context).state.loggedInUser;
      await ActivityProgressRepo().insertActivityProgress(
          user.id,
          _activity.topicId,
          widget.activityId,
          (new DateTime.now().millisecondsSinceEpoch).toString());
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
          title: _activity.text),
    );
  }
}
