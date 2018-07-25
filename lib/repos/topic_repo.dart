import 'dart:async';

import 'package:maui/db/entity/topic.dart';
import 'package:maui/db/dao/topic_dao.dart';

class TopicRepo {
  static final TopicDao topicDao = TopicDao();

  const TopicRepo();

  Future<Topic> getTopic(String id) async {
    return topicDao.getTopic(id);
  }
}
