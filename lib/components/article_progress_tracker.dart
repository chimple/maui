import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/article_progress_repo.dart';
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
  void _initState() async {
    articleProgressTracker();
    super.initState();
  }

   void articleProgressTracker() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = AppStateContainer.of(context).state.loggedInUser;
      _articleProgress = await ArticleProgressRepo()
        .getArticleProgressStatus(widget.topicId, user.id);
    });
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return new Container(
        child: new LinearProgressIndicator(
          value: 0.0,
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
