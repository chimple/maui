import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/state/app_state_container.dart';

class ArticleProgressTracker extends StatefulWidget {
  final String topicId;

  ArticleProgressTracker({Key key, this.topicId}) : super(key: key);

  @override
  State createState() => new ArticleProgressTrackerState();
}

class ArticleProgressTrackerState extends State<ArticleProgressTracker> {
  double _articleProgress;
  bool _isLoading = true;
  User user;

  @override
  void initState() {
    super.initState();
    articleProgressTracker();
  }

  void articleProgressTracker() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = AppStateContainer.of(context).state.loggedInUser;
      _articleProgress = await CardProgressRepo()
          .getProgressStatusByCollectionAndTypeAndUserId(
              widget.topicId, CardType.knowledge, user.id);
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return new Container(
        child: new LinearProgressIndicator(
          value: null,
          backgroundColor: Colors.green,
        ),
      );
    }

    return new Container(
      child: new LinearProgressIndicator(
        value: _articleProgress,
        backgroundColor: Colors.green,
      ),
    );
  }
}
