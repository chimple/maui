import 'package:flutter/material.dart';
import 'package:tahiti/tahiti.dart';
import 'package:maui/repos/activity_repo.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/screens/drawing_list_screen.dart';

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
      _drawingSelect = DrawingSelect.latest;
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
            icon: new Icon(Icons.add_circle),
            tooltip: 'Create new drawing',
            onPressed: () =>
                setState(() => _drawingSelect = DrawingSelect.create),
          ),
          new IconButton(
            icon: new Icon(Icons.view_list),
            tooltip: 'View all drawings',
            onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return DrawingListScreen(
                    activityId: widget.activityId,
                  );
                })),
          ),
        ],
      ),
      body: DrawingWrapper(
        activityId: widget.activityId,
        drawingSelect: _drawingSelect,
        drawingId: widget.drawingId,
      ),
    );
  }
}
