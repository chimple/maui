import 'dart:async';

import 'package:maui/db/entity/multiple_choice.dart';
import 'package:maui/db/dao/multiple_choice_dao.dart';

class MultipleChoiceRepo {
  static final MultipleChoiceDao multipleChoiceDao = MultipleChoiceDao();

  const MultipleChoiceRepo();

  Future<List<MultipleChoice>> getMultipleChoicesByTopicId(
      String topicId) async {
    return multipleChoiceDao.getMultipleChoicesByTopicId(topicId);
  }
}
