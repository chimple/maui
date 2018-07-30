import 'dart:async';

import 'package:maui/db/entity/article.dart';
import 'package:maui/db/dao/article_dao.dart';

class ArticleRepo {
  static final ArticleDao articleDao = ArticleDao();

  const ArticleRepo();

  Future<Article> getArticleByTopicId(String topicId) async {
    return articleDao.getArticleByTopicId(topicId);
  }

  Future<List<Article>> getArticlesByTopicId(String topicId) async {
    return articleDao.getArticlesByTopicId(topicId);
  }
}
