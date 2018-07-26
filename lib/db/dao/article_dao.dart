import 'dart:async';

import 'package:maui/app_database.dart';
import 'package:maui/db/entity/article.dart';
import 'package:sqflite/sqflite.dart';

class ArticleDao {
  Future<Article> getArticle(String id,String topicId, {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(Article.table,
        columns: [
          Article.idCol,
          Article.nameCol,
          Article.topicIdCol,
          Article.videoCol,
          Article.audioCol,
          Article.imageCol,
          Article.textCol,
          Article.orderCol
        ],
        where: '${Article.idCol} = ? AND ${Article.topicIdCol} = ?',
        whereArgs: [id,topicId]);
    if (maps.length > 0) {
      return Article.fromMap(maps.first);
    }
    return null;
  }
}
