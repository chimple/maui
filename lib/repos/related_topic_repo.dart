import 'dart:async';

import 'package:maui/db/entity/related_topic.dart';
import 'package:maui/db/dao/related_topic_dao.dart';

class RelatedTopicRepo {
  static final RelatedTopicDao relTopicDao = RelatedTopicDao();

  const RelatedTopicRepo();

  Future<List<RelatedTopic>> getRelatedTopic(String id) async {
    return relTopicDao.getRelatedTopic(id);
  }
}
