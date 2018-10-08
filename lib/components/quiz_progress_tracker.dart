import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/state/app_state_container.dart';

class QuizProgressTracker extends StatefulWidget {
  final String topicId;

  QuizProgressTracker({Key key, this.topicId}) : super(key: key);

  @override
  State createState() => new QuizProgressTrackerState();
}

class QuizProgressTrackerState extends State<QuizProgressTracker> {
  double _quizProgress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    User _user = AppStateContainer.of(context).state.loggedInUser;
    _quizProgress = await CardProgressRepo()
        .getProgressStatusByCollectionAndTypeAndUserId(
            widget.topicId, CardType.question, _user.id);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_quizProgress == null) {
      return new Container();
    }

    return new Container(
      child: _quizProgress != null
          ? new LinearProgressIndicator(value: _quizProgress)
          : new Container(),
    );
  }
}
