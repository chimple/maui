import 'dart:async';

import 'package:maui/db/entity/article.dart';
import 'package:maui/db/dao/article_dao.dart';

class ArticleRepo {
  static final ArticleDao articleDao = ArticleDao();

  const ArticleRepo();

  Future<Article> getArticle(String id,String topicId) async {
    return articleDao.getArticle(id,topicId);
  }
}
