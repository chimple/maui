import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/article_progress.dart';
import 'package:sqflite/sqflite.dart';

class ArticleProgressDao {
  const ArticleProgressDao();

  Future<ArticleProgress> getArticleProgressByTopicIdAndArticleIdAndUserId(
      String topicId, String articleId, String userId,
      {Database db}) async {
    print("Inside article_progress_dao $topicId, $articleId, $userId");
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ArticleProgress.table,
        columns: [
          ArticleProgress.userIdCol,
          ArticleProgress.topicIdCol,
          ArticleProgress.articleIdCol,
          ArticleProgress.timeStampIdCol
        ],
        where:
            '''${ArticleProgress.topicIdCol} = ? AND ${ArticleProgress.articleIdCol} = ? AND ${ArticleProgress.userIdCol} = ?''',
        whereArgs: [
          topicId,
          articleId,
          userId
        ]);
    if (maps.length > 0) {
      print(maps);
      return ArticleProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getArticleProgressStatusByTopicIdAndUserId(
      String topicId, String userId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> articlesAttempted = await db.query(ArticleProgress.table,
        columns: [ArticleProgress.articleIdCol],
        where:
            '''${ArticleProgress.topicIdCol} = ? AND ${ArticleProgress.userIdCol} = ?''',
        whereArgs: [topicId, userId]);

    return articlesAttempted.length;
  }

  Future<void> insertArticleProgress(ArticleProgress articleProgress,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(ArticleProgress.table, articleProgress.toMap());
  }
}
