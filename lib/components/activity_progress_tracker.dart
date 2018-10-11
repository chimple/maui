import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/db/entity/quack_card.dart';

class ActivityProgressTracker extends StatefulWidget {
  final String topicId;

  ActivityProgressTracker({Key key, this.topicId}) : super(key: key);

  @override
  State createState() => new ActivityProgressTrackerState();
}

class ActivityProgressTrackerState extends State<ActivityProgressTracker> {
  double _activityProgress;
  bool _isLoading = true;

  void _initData() async {
    User _user = AppStateContainer.of(context).state.loggedInUser;
    _activityProgress = await CardProgressRepo()
        .getProgressStatusByCollectionAndTypeAndUserId(
            widget.topicId, CardType.activity, _user.id);
    setState(() => _isLoading = false);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return new Container(
        child: new LinearProgressIndicator(
          value: 0.0,
          backgroundColor: Colors.orange,
        ),
      );
    }

    return new Container(
      child: new LinearProgressIndicator(
        value: _activityProgress,
        backgroundColor: Colors.orange,
      ),
    );
  }
}
