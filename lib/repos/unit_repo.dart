import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/unit.dart';
import 'package:maui/db/dao/unit_dao.dart';

class UnitRepo {
  static final UnitDao unitDao = new UnitDao();

  const UnitRepo();

  Future<Unit> getUnit(int id) async {
    return unitDao.getUnit(id);
  }

  Future<Unit> insert(Unit unit) async {
    return unitDao.insert(unit);
  }
}
