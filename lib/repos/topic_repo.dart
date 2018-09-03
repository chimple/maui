import 'dart:async';

import 'package:maui/db/entity/topic.dart';
import 'package:maui/db/dao/topic_dao.dart';

class TopicRepo {
  static final TopicDao topicDao = TopicDao();

  const TopicRepo();

  Future<Topic> getTopic(String id) async {
    return topicDao.getTopic(id);
  }

  Future<List<Topic>> getTopicsForCategoryId(String categoryId) async {
    return topicDao.getTopicsForCategoryId(categoryId);
  }

  Future<List<Topic>> getAllTopics() async {
    return await topicDao.getAllTopics();
  }
}
