import 'dart:async';

import 'package:maui/db/entity/article.dart';
import 'package:maui/db/dao/article_dao.dart';

class ArticleRepo {
  static final ArticleDao articleDao = ArticleDao();

  const ArticleRepo();

  Future<Article> getArticle(String topicId) async {
    return articleDao.getArticleByTopicId(topicId);
  }

  Future<List<Article>> getArticles(String topicId) async {
    return articleDao.getArticlesByTopicId(topicId);
  }
}
