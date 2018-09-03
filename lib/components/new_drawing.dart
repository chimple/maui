import 'package:flutter/material.dart';
import 'package:tahiti/tahiti.dart';
import 'package:maui/repos/activity_template_repo.dart';
import 'package:maui/db/entity/activity_template.dart';

class NewDrawing extends StatefulWidget {
  final String activityId;

  const NewDrawing({Key key, this.activityId}) : super(key: key);

  @override
  NewDrawingState createState() {
    return new NewDrawingState();
  }
}

class NewDrawingState extends State<NewDrawing> {
  bool _isLoading = true;
  List<ActivityTemplate> templates;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    templates = await ActivityTemplateRepo()
        .getActivityTemplatesByAtivityId(widget.activityId);
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
    return ActivityBoard();
  }
}
