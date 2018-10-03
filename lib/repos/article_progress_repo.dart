import 'dart:async';
import 'package:maui/db/entity/article_progress.dart';
import 'package:maui/db/dao/article_progress_dao.dart';
import "package:maui/repos/article_topic_repo.dart";

class ArticleProgressRepo {
  const ArticleProgressRepo();
  static final ArticleProgressDao articleProgressDao = new ArticleProgressDao();

  Future<double> getArticleProgressStatus(
      String topicId, String userId) async {
    int articlesAttempted = await articleProgressDao
        .getArticleProgressStatusByTopicIdAndUserId(topicId, userId);
    int articlesPresent =
        await ArticleTopicRepo().getTopicArticlesByTopicId(topicId);
    double articlesCompleted = (articlesAttempted / articlesPresent);
    return articlesCompleted;
  }

  Future<String> insertArticleProgress(String id, String userId, String topicId,
      String articleId) async {
    print(
        "InsertArticleProgressRepo $topicId, $articleId, $userId");
    ArticleProgress articleProgress = await articleProgressDao
        .getArticleProgressByTopicIdAndArticleIdAndUserId(
      topicId,
      articleId,
      userId,
    );
    if (articleProgress == null) {
      await articleProgressDao.insertArticleProgress(new ArticleProgress(
          id: id,
          topicId: topicId,
          userId: userId,
          articleId: articleId,
          timeStampId: DateTime.now()));
      return "Inserted";
    } else {
      print(articleProgress);
      return "Entry already present";
    }
  }
}
