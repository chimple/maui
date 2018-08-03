import 'dart:async';

import 'package:maui/db/entity/multiple_choice.dart';
import 'package:maui/db/dao/multiple_choice_dao.dart';

class MultipleChoiceRepo {
  static final MultipleChoiceDao relTopicDao = MultipleChoiceDao();

  const MultipleChoiceRepo();

  Future<List<MultipleChoice>> getMultipleChoiceDataByTopicId(
      String topicId) async {
    return relTopicDao.getMultipleChoiceDataByTopicId(topicId);
  }
}
