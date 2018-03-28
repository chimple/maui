import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/unit.dart';
import 'package:maui/db/entity/unit_part.dart';
import 'package:maui/db/entity/eager_unit_part.dart';
import 'package:maui/db/dao/unit_part_dao.dart';

class UnitPartRepo {
  static final UnitPartDao unitPartDao = new UnitPartDao();

  const UnitPartRepo();

  Future<List<UnitPart>> getUnitPartsByUnitIdAndType(String unitId,
      UnitType type) async {
    return unitPartDao.getUnitPartsByUnitIdAndType(unitId, type);
  }

  Future<List<EagerUnitPart>> getEagerUnitPartsByUnitIdAndType(String unitId,
      UnitType type) async {
    return unitPartDao.getEagerUnitPartsByUnitIdAndType(unitId, type);
  }

}