import 'package:flutter/material.dart';
import 'package:maui/repos/drawing_repo.dart';
import 'package:maui/repos/activity_repo.dart';
import 'package:maui/db/entity/drawing.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/components/drawing_list.dart';

class DrawingListScreen extends StatefulWidget {
  final String activityId;
  DrawingListScreen({Key key, this.activityId}) : super(key: key);

  @override
  DrawingListScreenState createState() {
    return new DrawingListScreenState();
  }
}

class DrawingListScreenState extends State<DrawingListScreen> {
  bool _isLoading = true;
  Activity _activity;
  List<Drawing> _drawings;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _activity = await ActivityRepo().getActivity(widget.activityId);
    _drawings = await DrawingRepo().getDrawingsByActivityId(widget.activityId);
    setState(() => _isLoading = false);
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
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            _activity.text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: DrawingList(
          drawings: _drawings,
        ));
  }
}
