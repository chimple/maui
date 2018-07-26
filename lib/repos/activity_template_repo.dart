import 'dart:async';

import '../db/dao/activity_template_dao.dart';
import '../db/entity/activity_template.dart';

class ActivityTemplateRepo {
  static final ActivityTemplateDao activityTemplateDao = ActivityTemplateDao();

  const ActivityTemplateRepo();

  Future<ActivityTemplate> getTopic(String activityId) async {
    print("hello boss data is is there or not");
    return await activityTemplateDao.getTopic(activityId);
  }

  Future<List<ActivityTemplate>> getalltemplate() async {
    return await activityTemplateDao.getalltemplate();
  }
}
