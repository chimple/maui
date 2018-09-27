import 'dart:async';

import 'package:maui/db/entity/related_topic.dart';
import 'package:maui/db/dao/related_topic_dao.dart';
import 'package:maui/db/entity/topic.dart';

class RelatedTopicRepo {
  static final RelatedTopicDao relTopicDao = RelatedTopicDao();

  const RelatedTopicRepo();

  Future<List<RelatedTopic>> getRelatedTopicsByTopicId(String topicId) async {
    return relTopicDao.getRelatedTopicsByTopicId(topicId);
  }

  Future<List<Topic>> getTopicsByRelatedTopicId(String topicId) async {
    return relTopicDao.getTopicsByRelatedTopicId(topicId);
  }
}
