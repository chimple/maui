import 'dart:async';
import 'package:maui/db/entity/article_progress.dart';
import 'package:maui/db/dao/article_progress_dao.dart';

class ArticleProgressRepo {
  const ArticleProgressRepo();
  static final ArticleProgressDao articleProgressDao = new ArticleProgressDao();

  Future<String> insertArticleProgress(String id, String userId, String topicId,
      String articleId, String timeStampId) async {
    print(
        "InsertArticleProgressRepo $topicId, $articleId, $userId, $timeStampId");
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
          timeStampId: timeStampId));
      return "Inserted";
    } else {
      print(articleProgress);
      return "Entry already present";
    }
  }
}
