import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/unit.dart';
import 'package:maui/db/dao/unit_dao.dart';

class UnitRepo {
  static final UnitDao unitDao = new UnitDao();

  const UnitRepo();

  Future<Unit> getUnit(String id) async {
    return unitDao.getUnit(id);
  }

  Future<List<Unit>> getUnitsOfSameTypeAs(String id) async {
    return unitDao.getUnitsOfSameTypeAs(id);
  }

  Future<List<Unit>> getUnits() async {
    return unitDao.getUnits();
  }

  Future<List<Unit>> getUnitsByType(int type) async {
    return unitDao.getUnitsByType(type);
  }

  Future<Unit> insert(Unit unit) async {
    return unitDao.insert(unit);
  }
}
