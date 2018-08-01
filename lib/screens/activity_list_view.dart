import 'package:flutter/material.dart';
import 'package:maui/components/topic_button.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/loca.dart';
import '../repos/activity_repo.dart';

class ActivityListView extends StatefulWidget {
  const ActivityListView({Key key}) : super(key: key);

  @override
  _ActivityListViewState createState() {
    return new _ActivityListViewState();
  }

  showModes(BuildContext context, String game) {
    Navigator.of(context).pushNamed('/categories/$game');
  }
}

class _ActivityListViewState extends State<ActivityListView> {
  List<Activity> _dataActivity;
  bool _isLoading = true;
  static const activityTopicId = 'lion';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    setState(() => _isLoading = true);
    _dataActivity =
        await ActivityRepo().getActivitiesByTopicId(activityTopicId);

    print("object...category data is......$_dataActivity");
    print("data of the ${_dataActivity}");
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new GridView.count(
      key: new Key('Category_page'),
      primary: true,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      crossAxisCount: media.size.height > media.size.width ? 3 : 2,
      children: new List.generate(_dataActivity.length, (i) {
        return TopicButton(
          text: "${_dataActivity[i].text}",
          image: "assets/category/lion.svg",
        );
      }),
    );
  }
}
