import 'dart:async';

import 'package:maui/db/entity/sub_category.dart';
import 'package:maui/db/dao/sub_category_dao.dart';

class SubCategoryRepo {
  static final SubCategoryDao subCategoryDao = SubCategoryDao();

  const SubCategoryRepo();

  Future<Subcategory> getCategory(String id) async {
    return subCategoryDao.getSubCategory(id);
  }
}