import 'dart:async';
import 'package:maui/db/entity/article_topic.dart';
import 'package:maui/db/dao/article_topic_dao.dart';

class ArticleTopicRepo {
  static final ArticleTopicDao articleTopicDao = ArticleTopicDao();

  const ArticleTopicRepo();

  Future<List<ArticleTopic>> getArticleTopicByTopicId(String topicId) async {
    return await articleTopicDao.getArticleTopicByTopicId(topicId);
  }

  Future<int> getTopicArticlesByTopicId(String topicId) async {
    return (await (articleTopicDao.getArticleTopicByTopicId(topicId))).length;
  }
}
