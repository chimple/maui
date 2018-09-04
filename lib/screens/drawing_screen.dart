import 'package:flutter/material.dart';
import 'package:tahiti/tahiti.dart';
import 'package:maui/repos/activity_repo.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/components/new_drawing.dart';

class DrawingScreen extends StatefulWidget {
  final String activityId;
  DrawingScreen({Key key, this.activityId}) : super(key: key);

  @override
  DrawingScreenState createState() {
    return new DrawingScreenState();
  }
}

class DrawingScreenState extends State<DrawingScreen> {
  bool _isLoading = true;
  Activity _activity;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _activity = await ActivityRepo().getActivity(widget.activityId);
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
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          _activity.text,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.playlist_play),
            tooltip: 'Air it',
            onPressed: () => print('1'),
          ),
          new IconButton(
            icon: new Icon(Icons.playlist_add),
            tooltip: 'Restitch it',
            onPressed: () => print('2'),
          ),
          new IconButton(
            icon: new Icon(Icons.playlist_add_check),
            tooltip: 'Repair it',
            onPressed: () => print('3'),
          ),
        ],
      ),
      body: NewDrawing(
        activityId: widget.activityId,
      ),
    );
  }
}
