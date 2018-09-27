import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/article.dart';
import 'package:sqflite/sqflite.dart';

class ArticleDao {
  Future<Article> getArticleByTopicId(String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Article.table,
        columns: [
          Article.idCol,
          Article.nameCol,
          Article.topicIdCol,
          Article.serialCol,
          Article.videoCol,
          Article.audioCol,
          Article.imageCol,
          Article.textCol
        ],
        where: '${Article.topicIdCol} = ?',
        whereArgs: [topicId]);
    if (maps.length > 0) {
      return Article.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Article>> getArticlesByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Article.table,
      columns: [
        Article.idCol,
        Article.nameCol,
        Article.topicIdCol,
        Article.serialCol,
        Article.videoCol,
        Article.audioCol,
        Article.imageCol,
        Article.textCol,
      ],
      where: '${Article.topicIdCol} = ?',
      whereArgs: [topicId],
    );
    return maps.map((article) => new Article.fromMap(article)).toList();
  }
}
