import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/article_topic.dart';
import 'package:sqflite/sqflite.dart';

class ArticleTopicDao {
  Future<List<ArticleTopic>> getArticleTopicByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ArticleTopic.table,
        columns: [
          ArticleTopic.articleIdCol,
          ArticleTopic.topicIdCol,
        ],
        where: "${ArticleTopic.topicIdCol} = ?",
        whereArgs: [topicId]);
    if (maps.length > 0) {
      return maps.map((el) => new ArticleTopic.fromMap(el)).toList();
    }
    return null;
  }
}
