import 'dart:async';



import '../db/dao/activity_template_dao.dart';
import '../db/entity/activity_template.dart';

class ActivityTemplateRepo {
  static final ActivityTemplateDao activityTemplateDao = ActivityTemplateDao();

  const ActivityTemplateRepo();

  Future<ActivityTemplate> getTopic(String id) async {
    return activityTemplateDao.getTopic(id);
  }
}
